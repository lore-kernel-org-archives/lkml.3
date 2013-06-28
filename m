Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3F1OoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:44:16 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40142 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3F1OoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130628072950.GI27010@pengutronix.de>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
	<20130628072950.GI27010@pengutronix.de>
Date: Fri, 28 Jun 2013 11:43:59 -0300
Message-ID: <CAOMZO5AtbfsrXnNyXKwyfqPn48bsuimk_D6gddXchzGcCfD-RA@mail.gmail.com>
Subject: Re: [PATCH 1/5] imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Jun 28, 2013 at 4:29 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Fri, Jun 28, 2013 at 12:32:01AM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we
>> get the following build error:
>>
>> ERROR: "imx_drm_encoder_get_mux_id" [drivers/staging/imx-drm/imx-ldb.ko] undefined!
> So imx-ldb.c needs a symbol from imx-drm-core.c right? The alternative
> to exporting this symbol for a single user(?) is to link these two files
> into a single module. Does this make sense? If yes, that would IMHO be
> the better fix.

The Makefile for these files is:

imxdrm-objs := imx-drm-core.o imx-fb.o

obj-$(CONFIG_DRM_IMX) += imxdrm.o

obj-$(CONFIG_DRM_IMX_PARALLEL_DISPLAY) += parallel-display.o
obj-$(CONFIG_DRM_IMX_TVE) += imx-tve.o
obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
obj-$(CONFIG_DRM_IMX_FB_HELPER) += imx-fbdev.o
obj-$(CONFIG_DRM_IMX_IPUV3_CORE) += ipu-v3/
obj-$(CONFIG_DRM_IMX_IPUV3)	+= ipuv3-crtc.o

so imx-drm-core is always built and imx-ldb is only built when
CONFIG_DRM_IMX_LDB is selected.

In this case, we should keep the two modules separate and fix this
error using the export.

Regards,

Fabio Estevam
