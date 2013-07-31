Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3GaNHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:07:19 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41739 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3GaNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <51F9005F.30501@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
	<51E97779.3020103@zytor.com>
	<87zjte9iah.fsf@rustcorp.com.au>
	<CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
	<51F9005F.30501@zytor.com>
Date: Wed, 31 Jul 2013 16:07:15 +0300
Message-ID: <CABpLfoiKnbkHq9oT3yk72583yYKz_AMotLVV-Cu1sw1B1GH0xw@mail.gmail.com>
Subject: Re: [QUERY] lguest64
From: Mike Rapoport <mike.rapoport@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 3:17 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/31/2013 02:39 AM, Mike Rapoport wrote:
>>
>> The use case I had in mind is to use lguest as a nested hypervisor in
>> public clouds. As of today, major public clouds do not support nested
>> virtualization and it's not clear at all if they will expose this
>> ability in their deployments. Addition of 64-bit support for lguest
>> won't require changes to pvops and, as far as I can tell, won't change
>> the number of pvops users...
>>
>
> "We can add a pvops user and that won't change the number of pvops
> users" What?!

We modify existing pvops user, IMHO. lguest is existing pvops user and
my idea was to extend it, rather than add lguest64 alongside lguest32.

>>> Yes, the subset of x86-64 machines for which there isn't hardware
>>> virtualization support is pretty uninteresting.
>>
>> There are plenty virtual machines in EC2, Rackspace, HP and other
>> clouds that do not have hardware virtualization. I believe that
>> running a hypervisor on them may be pretty interesting.
>
> The big problem with pvops is that they are a permanent tax on future
> development -- a classic case of "the hooks problem."  As such it is
> important that there be a real, significant, use case with enough users
> to make the pain worthwhile.  With Xen looking at sunsetting PV support
> with a long horizon, it might currently be possible to remove pvops some
> time in the early 2020s or so timeframe.  Introducing and promoting a
> new user now would definitely make that impossible.

I surely cannot predict how many users there will be for nested
virtualization in public cloud from now till the point when public
cloud providers will allow usage of hardware for that purpose.
Nevertheless, I believe that nested virtualization in public clouds is
a real use case which will have real users.

> So it matters that the use case be real.
>
>         -hpa
>

-- 
Sincerely yours,
Mike.
