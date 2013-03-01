Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3CAD7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:59:19 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49558 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3CAD7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:59:18 -0500
Message-ID: <51302792.6040408@linaro.org>
Date: Thu, 28 Feb 2013 19:59:14 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 10/30] staging: sync: Export sync API symbols
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org> <1362098606-26469-11-git-send-email-john.stultz@linaro.org> <20130301020008.GB13367@kroah.com>
In-Reply-To: <20130301020008.GB13367@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 06:00 PM, Greg KH wrote:
> On Thu, Feb 28, 2013 at 04:43:06PM -0800, John Stultz wrote:
>> From: Erik Gilling <konkers@android.com>
>>
>> This is needed to allow modules to link against the sync subsystem
>>
>> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> Cc: Erik Gilling <konkers@android.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Rob Clark <robclark@gmail.com>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Signed-off-by: Erik Gilling <konkers@android.com>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>   drivers/staging/android/sync.c |   14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
>> index 54f84d9..6739a84 100644
>> --- a/drivers/staging/android/sync.c
>> +++ b/drivers/staging/android/sync.c
>> @@ -15,6 +15,7 @@
>>    */
>>   
>>   #include <linux/debugfs.h>
>> +#include <linux/export.h>
>>   #include <linux/file.h>
>>   #include <linux/fs.h>
>>   #include <linux/kernel.h>
>> @@ -64,6 +65,7 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
>>   
>>   	return obj;
>>   }
>> +EXPORT_SYMBOL(sync_timeline_create);
> As these are now global, should they be a bit more "specific"?  "sync_"
> seems pretty broad.

Given its the sync driver, its most obvious choice, but I agree its 
likely to collide with filesystem related or other sync_ named functions 
that don't have a subsystem prefix.

Any suggestions?

The only good alternative I can think of is that in some private 
conversations with DanielV, he referred to Android using "sync-points".

Erik: Would syncpoint_ be an ok prefix? Or do you have other ideas?

> Also, EXPORT_SYMBOL_GPL() perhaps?
>
> And who is using these exports?

 From some quick git grepping...

In the android exynos tree:
https://android.googlesource.com/kernel/exynos.git 
android-exynos-manta-3.4-jb-mr1.1

drivers/gpu/arm/t6xx/kbase/src/linux/mali_kbase_sync.c: tl = 
sync_timeline_creat
drivers/media/video/videobuf2-core.c:   q->timeline = 
sw_sync_timeline_create(q-
drivers/video/s3c-fb.c: sfb->timeline = sw_sync_timeline_create("s3c-fb");

In the android msm tree:
https://android.googlesource.com/kernel/msm.git 
android-msm-mako-3.4-jb-mr1.1

drivers/gpu/msm/kgsl_sync.c:    context->timeline = 
sync_timeline_create(&kgsl_s
drivers/video/msm/msm_fb.c:             mfd->timeline = 
sw_sync_timeline_create(

thanks
-john


