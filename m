Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3EGIws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:52:48 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:41301 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758924Ab3EGIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:52:45 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 04:52:45 EDT
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <5188BEF7.7090505@vodafone.de>
Date: Tue, 07 May 2013 10:44:39 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
CC: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] radeon: Allow disabling UVD
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com> <1367910123.12136.7.camel@thor.local>
In-Reply-To: <1367910123.12136.7.camel@thor.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.05.2013 09:02, schrieb Michel Dänzer:
> On Mon, 2013-05-06 at 19:11 -0400, Parag Warudkar wrote:
>> Apparently UVD doesn't yet work everywhere - so allow it to be
>> disabled. Shaves off some reboot and suspend/resume time on machines
>> where it doesn't work. Might be useful for problematic chips in the
>> future as well.
>>
>> Patch attached as well as inline below.
>>
>> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

The patch shouldn't be necessary because just removing the firmware 
should have pretty much the same effect.

On the other hand we only have three reports of failed VCPU bootup, 
while it just seems to be a setup problems in two of those cases 
(identical hardware seems to work for other people).

The only case where we indeed seems to have a problem are Macs with 
integrated cards, and we can always just blacklist those if the problem 
doesn't seems to be solvable.

Christian.

> [...]
>
>> @@ -168,6 +169,9 @@ int radeon_fastfb = 0;
>>   MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
>>   module_param_named(no_wb, radeon_no_wb, int, 0444);
>>
>> +MODULE_PARM_DESC(no_uvd, "Disable UVD");
>> +module_param_named(no_uvd, radeon_no_uvd, int, 0444);
> No more negative boolean options please.
>
>
>> diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c
>> b/drivers/gpu/drm/radeon/radeon_uvd.c
>> index 906e5c0..93a7dbb 100644
>> --- a/drivers/gpu/drm/radeon/radeon_uvd.c
>> +++ b/drivers/gpu/drm/radeon/radeon_uvd.c
>> @@ -58,7 +58,8 @@ int radeon_uvd_init(struct radeon_device *rdev)
>>    unsigned long bo_size;
>>    const char *fw_name;
>>    int i, r;
>> -
>> + if (radeon_no_uvd)
>> + return -EINVAL;
>>    INIT_DELAYED_WORK(&rdev->uvd.idle_work, radeon_uvd_idle_work_handler);
> Returning -EINVAL here results in rather misleading dmesg output I
> think. This should probably be handled more gracefully.
>
> Anyway, the return statement would need to be indented per the kernel
> coding style, and please leave empty lines before the if and after the
> return.
>
>

