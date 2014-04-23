Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaDWAhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:37:50 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33431 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaDWAhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:37:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140422.163251.1863774803211446171.davem@davemloft.net>
References: <CALCETrWHA5ZmzOHnz9LO+7v4byc8QiynGyjE_ju5sjokNqrjZA@mail.gmail.com>
 <20140422.162927.2182797573155988911.davem@davemloft.net> <CALCETrX_TCbKy-3W590wG3rq9O3Hzbqc_wu3EGg7PKn2NNsTpQ@mail.gmail.com>
 <20140422.163251.1863774803211446171.davem@davemloft.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 17:37:26 -0700
Message-ID: <CALCETrXzN=EOJk7HB3P9NuBCvpQohJ7Y9U75ew9fCrTeN77VCw@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP socket options
To: David Miller <davem@davemloft.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        lpoetter@redhat.com, kay@redhat.com, Daniel Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:32 PM, David Miller <davem@davemloft.net> wrote:
> From: Andy Lutomirski <luto@amacapital.net>
> Date: Tue, 22 Apr 2014 13:31:13 -0700
>
>> On Tue, Apr 22, 2014 at 1:29 PM, David Miller <davem@davemloft.net> wrote:
>>> From: Andy Lutomirski <luto@amacapital.net>
>>> Date: Tue, 22 Apr 2014 13:08:59 -0700
>>>
>>>> On Tue, Apr 22, 2014 at 1:05 PM, David Miller <davem@davemloft.net> wrote:
>>>>> From: Vivek Goyal <vgoyal@redhat.com>
>>>>> Date: Tue, 15 Apr 2014 17:15:44 -0400
>>>>>
>>>>>> This is another version of patchset to add support passing cgroup
>>>>>> information of client over unix socket API.
>>>>>
>>>>> I'm marking this patch series as "changes requested" in patchwork
>>>>> because if we still end up adding this feature SO_PASSCGROUP needs to
>>>>> be changed to behave like SO_PASSCRED.
>>>>>
>>>>> Specifically, like SO_PASSCRED, it should pass the "real" cgroup, ie.
>>>>> the cgroup at socket open() time.
>>>>>
>>>>
>>>> I suspect that making this change will render it useless,
>>>> unfortunately.  I really want to understand the use case.
>>>
>>> There was no use case, it is simply the fact that when I discussed this
>>> feature with Vivek and Simo I told them that it should be implemented
>>> the same as the existing credential facilities.
>>>
>>> For datagram situations there is no "peer" to consider in between
>>> sendmsg() calls, as the binding is only active during the sendmsg()
>>> call.
>>>
>>> That's why SO_PASSCRED exists in the first place.
>>>
>>> Otherwise, without SO_PASSCGROUP, there is no way for datagram sockets
>>> to find out the peer's open() time cgroup.
>>
>> Right.
>>
>> I'd still like to know what userspace applications want this feature.
>> The canonical example seems to be journald, but journald doesn't use
>> unix datagram sockets AFAICS, nor is the process that opened the
>> socket interesting (that process is always systemd).
>
> It's about rounding out the interface properly, now, rather than having
> to have a specific use case.
>
> I really don't consider a specific use case as a requirement in this
> case.

Sure, but we'll feel really dumb if some variant of this is merged and
then we learn that it doesn't actually serve the intended purpose and
we have to extend it before anyone uses it.

I think that my SCM_IDENTITY proposal from the other thread would be
better an all counts, but it's rather more complicated.

--Andy
