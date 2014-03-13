Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaCMUSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCMUSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:18:04 -0400
Date: Thu, 13 Mar 2014 16:17:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Simo Sorce <ssorce@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
Message-ID: <20140313201755.GO18914@redhat.com>
References: <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org>
 <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
 <1394675038.32465.223.camel@willson.li.ssimo.org>
 <CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
 <1394733077.32465.243.camel@willson.li.ssimo.org>
 <CALCETrXWzja6W6y=p9MrtynGZMsrD5KQu0KBK6Bs1dQxnesv2A@mail.gmail.com>
 <20140313195349.GM18914@redhat.com>
 <CALCETrUj4aPEd6ujXnUJNFq+BQkfQoF=XRChP1p5=ZysTN-zwg@mail.gmail.com>
 <20140313200649.GN18914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313200649.GN18914@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 04:06:49PM -0400, Vivek Goyal wrote:
> On Thu, Mar 13, 2014 at 12:58:14PM -0700, Andy Lutomirski wrote:
> > On Thu, Mar 13, 2014 at 12:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Mar 13, 2014 at 10:55:16AM -0700, Andy Lutomirski wrote:
> > >
> > > [..]
> > >> >> 2. Docker is a container system, so use the "container" (aka
> > >> >> namespace) APIs.  There are probably several clever things that could
> > >> >> be done with /proc/<pid>/ns.
> > >> >
> > >> > pid is racy, if it weren't I would simply go straight
> > >> > to /proc/<pid>/cgroups ...
> > >>
> > >> How about:
> > >>
> > >> open("/proc/self/ns/ipc", O_RDONLY);
> > >> send the result over SCM_RIGHTS?
> > >
> > > As I don't know I will ask. So what will server now do with this file
> > > descriptor of client's ipc namespace.
> > >
> > > IOW, what information/identifier does it contain which can be
> > > used to map to pre-configrued per container/per namespace policies.
> > 
> > Inode number, which will match that assigned to the container at runtime.
> > 
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

Or could we do following.

open("/proc/self/cgroup", O_RDONLY);
send the result over SCM_RIGHTS

But this requires client modification.

Thanks
Vivek
