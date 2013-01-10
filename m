Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3AJUrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:47:04 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:44201 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3AJUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:47:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130110203248.GI23008@liondog.tnic>
References: <20130110093831.GA19503@liondog.tnic>
	<CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
	<20130110203248.GI23008@liondog.tnic>
Date: Thu, 10 Jan 2013 15:47:01 -0500
Message-ID: <CADnq5_MMk51H+Zy9GT9esfm_ndVqYzwU4t_6tYHu9zzSiqSr9g@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 3:32 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 10, 2013 at 11:21:21AM -0500, Alex Deucher wrote:
>> I'm assuming you didn't also update your userspace gfx stack?
>
> By that you mean x.org etc, right? Or GPU microcode too? In any case, I
> haven't touched any of those deliberately, AFAICR at least.

Right.  Xorg drivers or mesa drivers.

>
>> Does disabling the new DMA ring for ttm bo moves avoid the issue?
>
> How do I do that?

diff --git a/drivers/gpu/drm/radeon/radeon_asic.c
b/drivers/gpu/drm/radeon/radeon_asic.c
index 9056faf..b0cc46d 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -974,8 +974,8 @@ static struct radeon_asic r600_asic = {
                .blit_ring_index = RADEON_RING_TYPE_GFX_INDEX,
                .dma = &r600_copy_dma,
                .dma_ring_index = R600_RING_TYPE_DMA_INDEX,
-               .copy = &r600_copy_dma,
-               .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
+               .copy = &r600_copy_blit,
+               .copy_ring_index = RADEON_RING_TYPE_GFX_INDEX,
        },
        .surface = {
                .set_reg = r600_set_surface_reg,
@@ -1058,8 +1058,8 @@ static struct radeon_asic rs780_asic = {
                .blit_ring_index = RADEON_RING_TYPE_GFX_INDEX,
                .dma = &r600_copy_dma,
                .dma_ring_index = R600_RING_TYPE_DMA_INDEX,
-               .copy = &r600_copy_dma,
-               .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
+               .copy = &r600_copy_blit,
+               .copy_ring_index = RADEON_RING_TYPE_GFX_INDEX,
        },
        .surface = {
                .set_reg = r600_set_surface_reg,


>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
