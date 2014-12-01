Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaLALyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:54:06 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:36008 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaLALyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:54:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <4d9529808b8b167af6f177870c9b4a57>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547C56D2.5030302@rock-chips.com>
Date: Mon, 01 Dec 2014 19:53:54 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v14 05/12] drm: imx: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
References: <1417432770-12719-1-git-send-email-andy.yan@rock-chips.com> <1417433086-12964-1-git-send-email-andy.yan@rock-chips.com> <1417434133.4624.9.camel@pengutronix.de>
In-Reply-To: <1417434133.4624.9.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:

On 2014年12月01日 19:42, Philipp Zabel wrote:
> Hi Andy,
>
> Am Montag, den 01.12.2014, 19:24 +0800 schrieb Andy Yan:
> [...]
>> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
>> new file mode 100644
>> index 0000000..1bbf3ca
>> --- /dev/null
>> +++ b/include/drm/bridge/dw_hdmi.h
>> @@ -0,0 +1,57 @@
>> +/*
>> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __DW_HDMI__
>> +#define __DW_HDMI__
>> +
>> +#include <drm/drmP.h>
>> +
>> +enum {
>> +	RES_8,
>> +	RES_10,
>> +	RES_12,
>> +	RES_MAX,
>> +};
>> +
>> +enum dw_hdmi_devtype {
>> +	IMX6Q_HDMI,
>> +	IMX6DL_HDMI,
>> +};
>> +
>> +struct mpll_config {
>> +	unsigned long mpixelclock;
>> +	struct {
>> +		u16 cpce;
>> +		u16 gmp;
>> +	} res[RES_MAX];
>> +};
>> +
>> +struct curr_ctrl {
>> +	unsigned long mpixelclock;
>> +	u16 curr[RES_MAX];
>> +};
>> +
>> +struct sym_term {
>> +	unsigned long mpixelclock;
>> +	u16 sym_ctr;    /*clock symbol and transmitter control*/
>> +	u16 term;       /*transmission termination value*/
>> +};
> since this is going to be used by multiple drivers, the enums and
> structs should all be properly namespaced. How about DW_HDMI_RES_x,
> struct dw_hdmi_mpll_config, struct dw_hdmi_curr_ctrl, and struct
> dw_hdmi_sym_term?

   That sounds good, I will take your advice in PATCH V15.
   Thanks
>> +struct dw_hdmi_plat_data {
>> +	enum dw_hdmi_devtype dev_type;
>> +	const struct mpll_config *mpll_cfg;
>> +	const struct curr_ctrl *cur_ctr;
>> +	const struct sym_term *sym_term;
>> +};
>> +
>> +void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
>> +int dw_hdmi_bind(struct device *dev, struct device *master,
>> +		 void *data, struct drm_encoder *encoder,
>> +		 const struct dw_hdmi_plat_data *plat_data);
>> +#endif /* __IMX_HDMI_H__ */
> regards
> Philipp
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


