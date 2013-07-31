Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3GaOct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:32:49 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61353 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab3GaOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <51F90EE0.4070108@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
	<51E97779.3020103@zytor.com>
	<87zjte9iah.fsf@rustcorp.com.au>
	<CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
	<51F9005F.30501@zytor.com>
	<CABpLfoiKnbkHq9oT3yk72583yYKz_AMotLVV-Cu1sw1B1GH0xw@mail.gmail.com>
	<51F90EE0.4070108@zytor.com>
Date: Wed, 31 Jul 2013 17:32:36 +0300
Message-ID: <CABpLfogfNauoLgs-Z_p9VeVeFMguTrTWVa8841jSh0vs1RR8LA@mail.gmail.com>
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

On Wed, Jul 31, 2013 at 4:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/31/2013 06:07 AM, Mike Rapoport wrote:
>>>
>>> "We can add a pvops user and that won't change the number of pvops
>>> users" What?!
>>
>> We modify existing pvops user, IMHO. lguest is existing pvops user and
>> my idea was to extend it, rather than add lguest64 alongside lguest32.
>>
>
> That is nothing but creative accounting, sorry.

If you count Xen PV 32 and 64 as two pvops users than indeed so :)

>>>>> Yes, the subset of x86-64 machines for which there isn't hardware
>>>>> virtualization support is pretty uninteresting.
>>>>
>>>> There are plenty virtual machines in EC2, Rackspace, HP and other
>>>> clouds that do not have hardware virtualization. I believe that
>>>> running a hypervisor on them may be pretty interesting.
>>>
>>> The big problem with pvops is that they are a permanent tax on future
>>> development -- a classic case of "the hooks problem."  As such it is
>>> important that there be a real, significant, use case with enough users
>>> to make the pain worthwhile.  With Xen looking at sunsetting PV support
>>> with a long horizon, it might currently be possible to remove pvops some
>>> time in the early 2020s or so timeframe.  Introducing and promoting a
>>> new user now would definitely make that impossible.
>>
>> I surely cannot predict how many users there will be for nested
>> virtualization in public cloud from now till the point when public
>> cloud providers will allow usage of hardware for that purpose.
>> Nevertheless, I believe that nested virtualization in public clouds is
>> a real use case which will have real users.
>
> Then that will show... however, whether or not lguest64 will be used for
> that purpose is anyone's guess.  I suspect personally that people will
> use the already-deployed Xen PV for that purpose and it will stretch the
> lifespan of that technology.

Well, nesting Xen PV in a cloud VM, even fully-virtualied, seems to me
significantly more complicated than nesting an lguest.

> Now, nested PV is an even uglier case, and at least some public clouds
> are using PV at the base layer.

Unfortunately, majority of public cloud VMs are PV. And, indeed,
nested PV is not nice...

>         -hpa
>
>

-- 
Sincerely yours,
Mike.
