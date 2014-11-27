Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaK0VK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:10:26 -0500
Received: from mout.gmx.net ([212.227.15.18]:53178 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK0VKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:10:24 -0500
Date: Thu, 27 Nov 2014 22:10:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: ov2640: use the v4l2 size definitions
In-Reply-To: <1416905668-23029-2-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1411272209220.5267@axis700.grange>
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
 <1416905668-23029-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:F1FoBbBhpp7y+ay0jqd9bIgKWXsEjYKqrco9U9prdacQjps58s6
 dTGlBU2RUb7+yw8n/jqdafnCt5R8cx2kszu8Rq9vd83n9yY6kljGe1DbdTxmtUfKAcgwGBg
 CtcZJ/B33syKPZIHi/tdwgGuwku1WGBIj96YCualwSHzgMwydPiTkGXnvHnKgSCAvfQ1Hpg
 oKxHOVhU8wSD30CxAccfA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, 25 Nov 2014, Josh Wu wrote:

> Reuse the v4l2 size definitions from v4l2-image-sizes.h.
> So we can remove the rudundent definitions from ov2640.c.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Now this patch run-time depends on your "v4l2-image-sizes.h: correct the 
SVGA height definition" fix, without it SVGA will break for ov2640.

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/ov2640.c | 82 +++++++++++++----------------------
>  1 file changed, 30 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 6f2dd90..1fdce2f 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -25,6 +25,7 @@
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-image-sizes.h>
>  
>  #define VAL_SET(x, mask, rshift, lshift)  \
>  		((((x) >> rshift) & mask) << lshift)
> @@ -268,33 +269,10 @@ struct regval_list {
>  	u8 value;
>  };
>  
> -/* Supported resolutions */
> -enum ov2640_width {
> -	W_QCIF	= 176,
> -	W_QVGA	= 320,
> -	W_CIF	= 352,
> -	W_VGA	= 640,
> -	W_SVGA	= 800,
> -	W_XGA	= 1024,
> -	W_SXGA	= 1280,
> -	W_UXGA	= 1600,
> -};
> -
> -enum ov2640_height {
> -	H_QCIF	= 144,
> -	H_QVGA	= 240,
> -	H_CIF	= 288,
> -	H_VGA	= 480,
> -	H_SVGA	= 600,
> -	H_XGA	= 768,
> -	H_SXGA	= 1024,
> -	H_UXGA	= 1200,
> -};
> -
>  struct ov2640_win_size {
>  	char				*name;
> -	enum ov2640_width		width;
> -	enum ov2640_height		height;
> +	u32				width;
> +	u32				height;
>  	const struct regval_list	*regs;
>  };
>  
> @@ -495,17 +473,17 @@ static const struct regval_list ov2640_init_regs[] = {
>  static const struct regval_list ov2640_size_change_preamble_regs[] = {
>  	{ BANK_SEL, BANK_SEL_DSP },
>  	{ RESET, RESET_DVP },
> -	{ HSIZE8, HSIZE8_SET(W_UXGA) },
> -	{ VSIZE8, VSIZE8_SET(H_UXGA) },
> +	{ HSIZE8, HSIZE8_SET(UXGA_WIDTH) },
> +	{ VSIZE8, VSIZE8_SET(UXGA_HEIGHT) },
>  	{ CTRL2, CTRL2_DCW_EN | CTRL2_SDE_EN |
>  		 CTRL2_UV_AVG_EN | CTRL2_CMX_EN | CTRL2_UV_ADJ_EN },
> -	{ HSIZE, HSIZE_SET(W_UXGA) },
> -	{ VSIZE, VSIZE_SET(H_UXGA) },
> +	{ HSIZE, HSIZE_SET(UXGA_WIDTH) },
> +	{ VSIZE, VSIZE_SET(UXGA_HEIGHT) },
>  	{ XOFFL, XOFFL_SET(0) },
>  	{ YOFFL, YOFFL_SET(0) },
> -	{ VHYX, VHYX_HSIZE_SET(W_UXGA) | VHYX_VSIZE_SET(H_UXGA) |
> +	{ VHYX, VHYX_HSIZE_SET(UXGA_WIDTH) | VHYX_VSIZE_SET(UXGA_HEIGHT) |
>  		VHYX_XOFF_SET(0) | VHYX_YOFF_SET(0)},
> -	{ TEST, TEST_HSIZE_SET(W_UXGA) },
> +	{ TEST, TEST_HSIZE_SET(UXGA_WIDTH) },
>  	ENDMARKER,
>  };
>  
> @@ -519,45 +497,45 @@ static const struct regval_list ov2640_size_change_preamble_regs[] = {
>  	{ RESET, 0x00}
>  
>  static const struct regval_list ov2640_qcif_regs[] = {
> -	PER_SIZE_REG_SEQ(W_QCIF, H_QCIF, 3, 3, 4),
> +	PER_SIZE_REG_SEQ(QCIF_WIDTH, QCIF_HEIGHT, 3, 3, 4),
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_qvga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_QVGA, H_QVGA, 2, 2, 4),
> +	PER_SIZE_REG_SEQ(QVGA_WIDTH, QVGA_HEIGHT, 2, 2, 4),
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_cif_regs[] = {
> -	PER_SIZE_REG_SEQ(W_CIF, H_CIF, 2, 2, 8),
> +	PER_SIZE_REG_SEQ(CIF_WIDTH, CIF_HEIGHT, 2, 2, 8),
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_vga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_VGA, H_VGA, 0, 0, 2),
> +	PER_SIZE_REG_SEQ(VGA_WIDTH, VGA_HEIGHT, 0, 0, 2),
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_svga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_SVGA, H_SVGA, 1, 1, 2),
> +	PER_SIZE_REG_SEQ(SVGA_WIDTH, SVGA_HEIGHT, 1, 1, 2),
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_xga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_XGA, H_XGA, 0, 0, 2),
> +	PER_SIZE_REG_SEQ(XGA_WIDTH, XGA_HEIGHT, 0, 0, 2),
>  	{ CTRLI,    0x00},
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_sxga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_SXGA, H_SXGA, 0, 0, 2),
> +	PER_SIZE_REG_SEQ(SXGA_WIDTH, SXGA_HEIGHT, 0, 0, 2),
>  	{ CTRLI,    0x00},
>  	{ R_DVP_SP, 2 | R_DVP_SP_AUTO_MODE },
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov2640_uxga_regs[] = {
> -	PER_SIZE_REG_SEQ(W_UXGA, H_UXGA, 0, 0, 0),
> +	PER_SIZE_REG_SEQ(UXGA_WIDTH, UXGA_HEIGHT, 0, 0, 0),
>  	{ CTRLI,    0x00},
>  	{ R_DVP_SP, 0 | R_DVP_SP_AUTO_MODE },
>  	ENDMARKER,
> @@ -567,14 +545,14 @@ static const struct regval_list ov2640_uxga_regs[] = {
>  	{.name = n, .width = w , .height = h, .regs = r }
>  
>  static const struct ov2640_win_size ov2640_supported_win_sizes[] = {
> -	OV2640_SIZE("QCIF", W_QCIF, H_QCIF, ov2640_qcif_regs),
> -	OV2640_SIZE("QVGA", W_QVGA, H_QVGA, ov2640_qvga_regs),
> -	OV2640_SIZE("CIF", W_CIF, H_CIF, ov2640_cif_regs),
> -	OV2640_SIZE("VGA", W_VGA, H_VGA, ov2640_vga_regs),
> -	OV2640_SIZE("SVGA", W_SVGA, H_SVGA, ov2640_svga_regs),
> -	OV2640_SIZE("XGA", W_XGA, H_XGA, ov2640_xga_regs),
> -	OV2640_SIZE("SXGA", W_SXGA, H_SXGA, ov2640_sxga_regs),
> -	OV2640_SIZE("UXGA", W_UXGA, H_UXGA, ov2640_uxga_regs),
> +	OV2640_SIZE("QCIF", QCIF_WIDTH, QCIF_HEIGHT, ov2640_qcif_regs),
> +	OV2640_SIZE("QVGA", QVGA_WIDTH, QVGA_HEIGHT, ov2640_qvga_regs),
> +	OV2640_SIZE("CIF", CIF_WIDTH, CIF_HEIGHT, ov2640_cif_regs),
> +	OV2640_SIZE("VGA", VGA_WIDTH, VGA_HEIGHT, ov2640_vga_regs),
> +	OV2640_SIZE("SVGA", SVGA_WIDTH, SVGA_HEIGHT, ov2640_svga_regs),
> +	OV2640_SIZE("XGA", XGA_WIDTH, XGA_HEIGHT, ov2640_xga_regs),
> +	OV2640_SIZE("SXGA", SXGA_WIDTH, SXGA_HEIGHT, ov2640_sxga_regs),
> +	OV2640_SIZE("UXGA", UXGA_WIDTH, UXGA_HEIGHT, ov2640_uxga_regs),
>  };
>  
>  /*
> @@ -867,7 +845,7 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
>  	struct ov2640_priv *priv = to_ov2640(client);
>  
>  	if (!priv->win) {
> -		u32 width = W_SVGA, height = H_SVGA;
> +		u32 width = SVGA_WIDTH, height = SVGA_HEIGHT;
>  		priv->win = ov2640_select_win(&width, &height);
>  		priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
>  	}
> @@ -954,8 +932,8 @@ static int ov2640_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
>  	a->c.left	= 0;
>  	a->c.top	= 0;
> -	a->c.width	= W_UXGA;
> -	a->c.height	= H_UXGA;
> +	a->c.width	= UXGA_WIDTH;
> +	a->c.height	= UXGA_HEIGHT;
>  	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  
>  	return 0;
> @@ -965,8 +943,8 @@ static int ov2640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  {
>  	a->bounds.left			= 0;
>  	a->bounds.top			= 0;
> -	a->bounds.width			= W_UXGA;
> -	a->bounds.height		= H_UXGA;
> +	a->bounds.width			= UXGA_WIDTH;
> +	a->bounds.height		= UXGA_HEIGHT;
>  	a->defrect			= a->bounds;
>  	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	a->pixelaspect.numerator	= 1;
> -- 
> 1.9.1
> 
