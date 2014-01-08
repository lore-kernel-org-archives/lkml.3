Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaAHNXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:23:53 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48730 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaAHNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140107225345.GE29041@8bytes.org>
References: <1389134846-1000-1-git-send-email-joro@8bytes.org>
	<20140107225345.GE29041@8bytes.org>
Date: Wed, 8 Jan 2014 08:23:49 -0500
Message-ID: <CAF6AEGtHR9-oy+xaZM2bbJHnqhrwHiZeAC+asc7+Ds0x_hJeNQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Fix link error with !MSM_IOMMU
From: Rob Clark <robdclark@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 5:53 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Jan 07, 2014 at 11:47:26PM +0100, Joerg Roedel wrote:
>> The DRM driver for MSM depends on symbols from the MSM
>> IOMMU driver. Add this dependency to the Kconfig file.
>>
>> Fixes this comile error:
>>
>>   Kernel: arch/arm/boot/zImage is ready
>>   ERROR: "msm_iommu_get_ctx" [drivers/gpu/drm/msm/msm.ko]
>>   undefined!
>>   make[2]: *** [__modpost] Error 1

Thanks, I'll pull this into my pull req for 3.14 drm-next.. although,
after chatting with Stephen Boyd, I think we should eventually be able
to get rid of this (seems msm_iommu_get_ctx() was mainly for dealing
with secure playback (?))

BR,
-R

>>
>> Cc: Rob Clark <robdclark@gmail.com>
>> Signed-off-by: Joerg Roedel <joro@8bytes.org>
>> ---
>>  drivers/gpu/drm/msm/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
>> index f39ab75..d3de8e1 100644
>> --- a/drivers/gpu/drm/msm/Kconfig
>> +++ b/drivers/gpu/drm/msm/Kconfig
>> @@ -4,6 +4,7 @@ config DRM_MSM
>>       depends on DRM
>>       depends on ARCH_MSM
>>       depends on ARCH_MSM8960
>> +     depends on MSM_IOMMU
>>       select DRM_KMS_HELPER
>>       select SHMEM
>>       select TMPFS
>
> FYI, I put the patch to my arm/msm branch meanwhile to get the build
> error fixed. Please let me know when there is another solution merged
> and I will drop it.
>
>
>         Joerg
>
>
