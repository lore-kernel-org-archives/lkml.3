Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaCMVWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:22:04 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:46898 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCMVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:22:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140313200649.GN18914@redhat.com>
References: <1394658983.32465.203.camel@willson.li.ssimo.org>
 <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org> <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
 <1394675038.32465.223.camel@willson.li.ssimo.org> <CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
 <1394733077.32465.243.camel@willson.li.ssimo.org> <CALCETrXWzja6W6y=p9MrtynGZMsrD5KQu0KBK6Bs1dQxnesv2A@mail.gmail.com>
 <20140313195349.GM18914@redhat.com> <CALCETrUj4aPEd6ujXnUJNFq+BQkfQoF=XRChP1p5=ZysTN-zwg@mail.gmail.com>
 <20140313200649.GN18914@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 14:21:40 -0700
Message-ID: <CALCETrUGOR=_QNvDXQ0+zvPg7ZKVVohaXj91EGop80hGM7xNLw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simo Sorce <ssorce@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 1:06 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 13, 2014 at 12:58:14PM -0700, Andy Lutomirski wrote:
>> On Thu, Mar 13, 2014 at 12:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Mar 13, 2014 at 10:55:16AM -0700, Andy Lutomirski wrote:
>> >
>> > [..]
>> >> >> 2. Docker is a container system, so use the "container" (aka
>> >> >> namespace) APIs.  There are probably several clever things that could
>> >> >> be done with /proc/<pid>/ns.
>> >> >
>> >> > pid is racy, if it weren't I would simply go straight
>> >> > to /proc/<pid>/cgroups ...
>> >>
>> >> How about:
>> >>
>> >> open("/proc/self/ns/ipc", O_RDONLY);
>> >> send the result over SCM_RIGHTS?
>> >
>> > As I don't know I will ask. So what will server now do with this file
>> > descriptor of client's ipc namespace.
>> >
>> > IOW, what information/identifier does it contain which can be
>> > used to map to pre-configrued per container/per namespace policies.
>>
>> Inode number, which will match that assigned to the container at runtime.
>>
>
> But what would I do with this inode number. I am assuming this is
> generated dynamically when respective namespace was created. To me
> this is like assigning a pid dynamically and one does not create
> policies in user space based on pid. Similarly I will not be able
> to create policies based on an inode number which is generated
> dynamically.
>
> For it to be useful, it should map to something more static which
> user space understands.

Like what?  I imagine that, at best, sssd will be hardcoding some
understanding of Docker's cgroup names.  As an alternative, it could
ask Docker for a uid or an inode number of something else -- it's
hardcoding an understanding of Docker anyway.  And Docker needs to
cooperate regardless, since otherwise it could change its cgroup
naming or stop using cgroups entirely.

--Andy
