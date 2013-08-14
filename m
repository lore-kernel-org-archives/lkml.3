Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab3HNMRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:17:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41504 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab3HNMRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:17:37 -0400
Date: Wed, 14 Aug 2013 13:15:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] drm/i2c: tda998x: ensure VIP output mux is
	properly set
Message-ID: <20130814121511.GA23840@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:12AM +0200, Sebastian Hesselbarth wrote:
>  	switch (mode) {
>  	case DRM_MODE_DPMS_ON:
> +		/* Write the default value MUX register */
> +		reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);

This looks like an old version of my patch.  I ended up with this register
write at the bottom of tda998x_reset():

 drivers/gpu/drm/i2c/tda998x_drv.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d71c408..dc0428d 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -110,6 +110,7 @@ struct tda998x_priv {
 #define REG_VIP_CNTRL_5           REG(0x00, 0x25)     /* write */
 # define VIP_CNTRL_5_CKCASE       (1 << 0)
 # define VIP_CNTRL_5_SP_CNT(x)    (((x) & 3) << 1)
+#define REG_MUX_VP_VIP_OUT        REG(0x00, 0x27)     /* read/write */
 #define REG_MAT_CONTRL            REG(0x00, 0x80)     /* write */
 # define MAT_CONTRL_MAT_SC(x)     (((x) & 3) << 0)
 # define MAT_CONTRL_MAT_BP        (1 << 2)
@@ -415,6 +416,9 @@ tda998x_reset(struct drm_encoder *encoder)
 	reg_write(encoder, REG_PLL_SCGR1,    0x5b);
 	reg_write(encoder, REG_PLL_SCGR2,    0x00);
 	reg_write(encoder, REG_PLL_SCG2,     0x10);
+
+	/* Ensure VP output bus muxes result in no swapping */
+	reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
 }
 
 /* DRM encoder functions */
