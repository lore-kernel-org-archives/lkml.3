Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaJNQvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:51:49 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63606 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaJNQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <1411591537-31636-3-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
	<1411591537-31636-3-git-send-email-oded.gabbay@amd.com>
Date: Tue, 14 Oct 2014 12:51:45 -0400
Message-ID: <CADnq5_MheJTp36qLzofuLj-gBiz6LB=-KcZuhjdtL1G-0_r6Xw@mail.gmail.com>
Subject: Re: [PATCH v4 02/23] drm/radeon/cik: Don't touch int of pipes 1-7
From: Alex Deucher <alexdeucher@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 4:45 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> amdkfd should set interrupts for pipes 1-7.
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/cik.c | 71 +-------------------------------------------
>  1 file changed, 1 insertion(+), 70 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
> index 1530e37..e789988 100644
> --- a/drivers/gpu/drm/radeon/cik.c
> +++ b/drivers/gpu/drm/radeon/cik.c
> @@ -7291,8 +7291,7 @@ static int cik_irq_init(struct radeon_device *rdev)
>  int cik_irq_set(struct radeon_device *rdev)
>  {
>         u32 cp_int_cntl;
> -       u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
> -       u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
> +       u32 cp_m1p0;
>         u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
>         u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
>         u32 grbm_int_cntl = 0;
> @@ -7326,13 +7325,6 @@ int cik_irq_set(struct radeon_device *rdev)
>         dma_cntl1 = RREG32(SDMA0_CNTL + SDMA1_REGISTER_OFFSET) & ~TRAP_ENABLE;
>
>         cp_m1p0 = RREG32(CP_ME1_PIPE0_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m1p1 = RREG32(CP_ME1_PIPE1_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m1p2 = RREG32(CP_ME1_PIPE2_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m1p3 = RREG32(CP_ME1_PIPE3_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m2p0 = RREG32(CP_ME2_PIPE0_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m2p1 = RREG32(CP_ME2_PIPE1_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m2p2 = RREG32(CP_ME2_PIPE2_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
> -       cp_m2p3 = RREG32(CP_ME2_PIPE3_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
>
>         if (rdev->flags & RADEON_IS_IGP)
>                 thermal_int = RREG32_SMC(CG_THERMAL_INT_CTRL) &
> @@ -7354,33 +7346,6 @@ int cik_irq_set(struct radeon_device *rdev)
>                         case 0:
>                                 cp_m1p0 |= TIME_STAMP_INT_ENABLE;
>                                 break;
> -                       case 1:
> -                               cp_m1p1 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 2:
> -                               cp_m1p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 3:
> -                               cp_m1p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       default:
> -                               DRM_DEBUG("si_irq_set: sw int cp1 invalid pipe %d\n", ring->pipe);
> -                               break;
> -                       }
> -               } else if (ring->me == 2) {
> -                       switch (ring->pipe) {
> -                       case 0:
> -                               cp_m2p0 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 1:
> -                               cp_m2p1 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 2:
> -                               cp_m2p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 3:
> -                               cp_m2p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
>                         default:
>                                 DRM_DEBUG("si_irq_set: sw int cp1 invalid pipe %d\n", ring->pipe);
>                                 break;
> @@ -7397,33 +7362,6 @@ int cik_irq_set(struct radeon_device *rdev)
>                         case 0:
>                                 cp_m1p0 |= TIME_STAMP_INT_ENABLE;
>                                 break;
> -                       case 1:
> -                               cp_m1p1 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 2:
> -                               cp_m1p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 3:
> -                               cp_m1p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       default:
> -                               DRM_DEBUG("si_irq_set: sw int cp2 invalid pipe %d\n", ring->pipe);
> -                               break;
> -                       }
> -               } else if (ring->me == 2) {
> -                       switch (ring->pipe) {
> -                       case 0:
> -                               cp_m2p0 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 1:
> -                               cp_m2p1 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 2:
> -                               cp_m2p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
> -                       case 3:
> -                               cp_m2p2 |= TIME_STAMP_INT_ENABLE;
> -                               break;
>                         default:
>                                 DRM_DEBUG("si_irq_set: sw int cp2 invalid pipe %d\n", ring->pipe);
>                                 break;
> @@ -7512,13 +7450,6 @@ int cik_irq_set(struct radeon_device *rdev)
>         WREG32(SDMA0_CNTL + SDMA1_REGISTER_OFFSET, dma_cntl1);
>
>         WREG32(CP_ME1_PIPE0_INT_CNTL, cp_m1p0);
> -       WREG32(CP_ME1_PIPE1_INT_CNTL, cp_m1p1);
> -       WREG32(CP_ME1_PIPE2_INT_CNTL, cp_m1p2);
> -       WREG32(CP_ME1_PIPE3_INT_CNTL, cp_m1p3);
> -       WREG32(CP_ME2_PIPE0_INT_CNTL, cp_m2p0);
> -       WREG32(CP_ME2_PIPE1_INT_CNTL, cp_m2p1);
> -       WREG32(CP_ME2_PIPE2_INT_CNTL, cp_m2p2);
> -       WREG32(CP_ME2_PIPE3_INT_CNTL, cp_m2p3);
>
>         WREG32(GRBM_INT_CNTL, grbm_int_cntl);
>
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
