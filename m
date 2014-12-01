Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaLALpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:45:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaLALpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:45:33 -0500
Message-ID: <1417434133.4624.9.camel@pengutronix.de>
Subject: Re: [PATCH v14 05/12] drm: imx: imx-hdmi: move imx-hdmi to
 bridge/dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Mon, 01 Dec 2014 12:42:13 +0100
In-Reply-To: <1417433086-12964-1-git-send-email-andy.yan@rock-chips.com>
References: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com>
	 <1417433086-12964-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Am Montag, den 01.12.2014, 19:24 +0800 schrieb Andy Yan:
[...]
> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
> new file mode 100644
> index 0000000..1bbf3ca
> --- /dev/null
> +++ b/include/drm/bridge/dw_hdmi.h
> @@ -0,0 +1,57 @@
> +/*
> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __DW_HDMI__
> +#define __DW_HDMI__
> +
> +#include <drm/drmP.h>
> +
> +enum {
> +	RES_8,
> +	RES_10,
> +	RES_12,
> +	RES_MAX,
> +};
> +
> +enum dw_hdmi_devtype {
> +	IMX6Q_HDMI,
> +	IMX6DL_HDMI,
> +};
> +
> +struct mpll_config {
> +	unsigned long mpixelclock;
> +	struct {
> +		u16 cpce;
> +		u16 gmp;
> +	} res[RES_MAX];
> +};
> +
> +struct curr_ctrl {
> +	unsigned long mpixelclock;
> +	u16 curr[RES_MAX];
> +};
> +
> +struct sym_term {
> +	unsigned long mpixelclock;
> +	u16 sym_ctr;    /*clock symbol and transmitter control*/
> +	u16 term;       /*transmission termination value*/
> +};

since this is going to be used by multiple drivers, the enums and
structs should all be properly namespaced. How about DW_HDMI_RES_x,
struct dw_hdmi_mpll_config, struct dw_hdmi_curr_ctrl, and struct
dw_hdmi_sym_term?

> +struct dw_hdmi_plat_data {
> +	enum dw_hdmi_devtype dev_type;
> +	const struct mpll_config *mpll_cfg;
> +	const struct curr_ctrl *cur_ctr;
> +	const struct sym_term *sym_term;
> +};
> +
> +void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
> +int dw_hdmi_bind(struct device *dev, struct device *master,
> +		 void *data, struct drm_encoder *encoder,
> +		 const struct dw_hdmi_plat_data *plat_data);
> +#endif /* __IMX_HDMI_H__ */

regards
Philipp

