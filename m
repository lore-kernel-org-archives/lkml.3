Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaCLVUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:20:17 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35241 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaCLVUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <1394658983.32465.203.camel@willson.li.ssimo.org>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com> <5320CAEC.6030008@amacapital.net>
 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com> <1394658983.32465.203.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 14:19:54 -0700
Message-ID: <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
To: Simo Sorce <ssorce@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 2:16 PM, Simo Sorce <ssorce@redhat.com> wrote:
> On Wed, 2014-03-12 at 14:12 -0700, Andy Lutomirski wrote:
>> On Wed, Mar 12, 2014 at 2:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On 03/12/2014 01:46 PM, Vivek Goyal wrote:
>> >> Implement SO_PEERCGROUP along the lines of SO_PEERCRED. This returns the
>> >> cgroup of first mounted hierarchy of the task. For the case of client,
>> >> it represents the cgroup of client at the time of opening the connection.
>> >> After that client cgroup might change.
>> >
>> > Even if people decide that sending cgroups over a unix socket is a good
>> > idea, this API has my NAK in the strongest possible sense, for whatever
>> > my NAK is worth.
>> >
>> > IMO SO_PEERCRED is a disaster.  Calling send(2) or write(2) should
>> > *never* imply the use of a credential.  A program should always have to
>> > *explicitly* request use of a credential.  What you want is SCM_CGROUP.
>> >
>> > (I've found privilege escalations before based on this observation, and
>> > I suspect I'll find them again.)
>> >
>> >
>> > Note that I think that you really want SCM_SOMETHING_ELSE and not
>> > SCM_CGROUP, but I don't know what the use case is yet.
>>
>> This might not be quite as awful as I thought.  At least you're
>> looking up the cgroup at connection time instead of at send time.
>>
>> OTOH, this is still racy -- the socket could easily outlive the cgroup
>> that created it.
>
> I think you do not understand how this whole problem space works.
>
> The problem is exactly the same as with SO_PEERCRED, so we are taking
> the same proven solution.

You mean the same proven crappy solution?

>
> Connection time is all we do and can care about.

You have not answered why.

>
> Simo.
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
