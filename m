Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaAHTxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:53:50 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45811 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140108133514.GG29041@8bytes.org>
References: <1389134846-1000-1-git-send-email-joro@8bytes.org>
	<20140107225345.GE29041@8bytes.org>
	<CAF6AEGtHR9-oy+xaZM2bbJHnqhrwHiZeAC+asc7+Ds0x_hJeNQ@mail.gmail.com>
	<20140108133514.GG29041@8bytes.org>
Date: Wed, 8 Jan 2014 14:53:45 -0500
Message-ID: <CAF6AEGsrLR1ADoqiEixVsv8=E5zFVZeza3Q7AcBTY8xbZJbHgQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Fix link error with !MSM_IOMMU
From: Rob Clark <robdclark@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 8:35 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Jan 08, 2014 at 08:23:49AM -0500, Rob Clark wrote:
>> On Tue, Jan 7, 2014 at 5:53 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> > On Tue, Jan 07, 2014 at 11:47:26PM +0100, Joerg Roedel wrote:
>> >> The DRM driver for MSM depends on symbols from the MSM
>> >> IOMMU driver. Add this dependency to the Kconfig file.
>> >>
>> >> Fixes this comile error:
>> >>
>> >>   Kernel: arch/arm/boot/zImage is ready
>> >>   ERROR: "msm_iommu_get_ctx" [drivers/gpu/drm/msm/msm.ko]
>> >>   undefined!
>> >>   make[2]: *** [__modpost] Error 1
>>
>> Thanks, I'll pull this into my pull req for 3.14 drm-next.. although,
>> after chatting with Stephen Boyd, I think we should eventually be able
>> to get rid of this (seems msm_iommu_get_ctx() was mainly for dealing
>> with secure playback (?))
>
> It is already in my next-branch. So if you are ok with the approach for
> now there is no need for action. If you want it to go through your tree
> anyway please let me know and I will drop it from mine.

probably will be a slight merge conflict if it goes through your
branch.. although should be easy enough to resolve, basically the
result should look something like:

  depends on (ARCH_MSM && ARCH_MSM8960 && MSM_IOMMU) || (ARM && COMPILE_TEST)

BR,
-R

>
>         Joerg
>
>
