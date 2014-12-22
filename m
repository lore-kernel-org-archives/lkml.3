Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaLVI6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:58:31 -0500
Received: from pegasos-out.vodafone.de ([80.84.1.38]:40493 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaLVI6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:58:30 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.157
Authentication-Results: rohrpostix1.prod.vfnet.de (amavisd-new); dkim=softfail
	(invalid, public key: DNS query timeout for
	mail._domainkey.vodafone.de) header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de BF8B92602E3
Message-ID: <5497DD0E.7040400@vodafone.de>
Date: Mon, 22 Dec 2014 09:57:50 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, Dave Airlie <airlied@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>	<1419108374-7020-2-git-send-email-oded.gabbay@amd.com>	<5496AEAD.3090003@vodafone.de>	<5496B04C.50502@amd.com>	<5496BAE0.5090901@vodafone.de>	<5496C5EA.7050200@amd.com>	<5496CA0F.8000800@amd.com>	<5496EDF1.7080106@vodafone.de>	<5496EF34.70302@amd.com>	<5496F0DD.40903@vodafone.de>	<5497C98C.2080208@amd.com> <CAPM=9tzpvmu=6X32-jc4VeVTZENW9iQDq6aB1dxo6TkbkKOpkQ@mail.gmail.com> <5497CB91.2080306@amd.com>
In-Reply-To: <5497CB91.2080306@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.12.2014 um 08:43 schrieb Oded Gabbay:
>
>
> On 12/22/2014 09:40 AM, Dave Airlie wrote:
>>>>>>> There should be, but when the modules are compiled in, they are 
>>>>>>> loaded
>>>>>>> based on
>>>>>>> link order only, if they are in the same group, and the groups are
>>>>>>> loaded by a
>>>>>>> pre-defined order.
>>>>>>
>>>>>> Is that really still up to date? I've seen effort to change that
>>>>>> something like
>>>>>> 10+ years ago when Rusty reworked the module system. And it is 
>>>>>> comming
>>>>>> up on the
>>>>>> lists again from time to time.
>>>>>
>>>>>  From what I can see in the Makefile rules, code and google, yes, 
>>>>> that's
>>>>> still
>>>>> the situation. If someone will prove me wrong I will be more than 
>>>>> happy
>>>>> to
>>>>> correct my code.
>>>>>>
>>>>>>
>>>>>>> I don't want to move iommu before gpu, so I don't have a 
>>>>>>> solution for
>>>>>>> the
>>>>>>> order between amdkfd and amd_iommu_v2.
>>>>>>
>>>>>> Why not? That's still better than creating a kernel workqueue,
>>>>>> scheduling one
>>>>>> work item on it, rescheduling the task until everything is 
>>>>>> completed and
>>>>>> you can
>>>>>> continue.
>>>>>
>>>>> Because I don't know the consequences of moving an entire 
>>>>> subsystem in
>>>>> front
>>>>> of another one. In addition, even if everyone agrees, I'm pretty sure
>>>>> that
>>>>> Linus won't be happy to do that in -rc stages. So maybe this is 
>>>>> something
>>>>> to
>>>>> consider for 3.20 merge window, but I would still like to provide a
>>>>> solution
>>>>> for 3.19.
>>>>
>>>>
>>>> Yeah, true indeed. How about depending on everything being compiled as
>>>> module
>>>> for 3.19 then? Still better than having such a hack in the driver 
>>>> for as a
>>>> temporary workaround for one release.
>>>>
>>> I thought about it, but because this problem was originally reported 
>>> by a
>>> user that told us he couldn't use modules because of his setup, I 
>>> decided
>>> not to.
>>> I assume there are other users out there who needs this option 
>>> (compiled
>>> everything in the kernel - embedded ?), so I don't want to make 
>>> their life
>>> harder.
>>>
>>> In addition, saying it is a workaround for one release is true in case
>>> moving iommu subsystem in front of gpu subsystem is acceptable and 
>>> doesn't
>>> cause other problems, unknown at this point.
>>>
>>> Bottom line, my personal preference is to help the users _now_ and if a
>>> better fix is found in the future, change the code accordingly.
>>
>> My guess is moving the iommu subsystem in front of the GPU would be 
>> rational.
>>
>> It does seem like it would generally have a depend in that order.
>>
>> Dave.
>>
> Dave,
> I agree, but don't you think it is too risky for -rc stages ?
> If not, I can try it and if it works on KV, I can submit a patch.
> But if you do think it is risky, what do you recommend for 3.19 ? Do 
> the fix I suggested or disable build-in compilation option ?

I would say create the patch of changing the order (should be trivial), 
describe in detail in the commit message what this is supposed to fix 
and why such an severe change was done in -rc1 and submit it upstream.

We can still revert it in -rc2 if it breaks anything.

Christian.

>
>     Oded

