Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3HNOVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:21:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37755 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3HNOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:21:04 -0400
Date: Wed, 14 Aug 2013 09:20:56 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Message-ID: <20130814142056.GB2673@joshc>
References: <1376485183-2664-1-git-send-email-iivanov@mm-sol.com>
 <1376485183-2664-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376485183-2664-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:59:42PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> These drivers handles control and configuration of the HS
> and SS USB PHY transceivers. They are part of the driver
> which manage Synopsys DesignWare USB3 controller stack
> inside Qualcomm SoC's.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
[..]
> diff --git a/drivers/usb/phy/phy-msm-dwc3-hs.c b/drivers/usb/phy/phy-msm-dwc3-hs.c
> new file mode 100644
> index 0000000..465a8f5
> --- /dev/null
> +++ b/drivers/usb/phy/phy-msm-dwc3-hs.c
[..]
> +
> +struct msm_dwc3_hs_phy {
> +	struct usb_phy		phy;
> +	void __iomem		*base;
> +	struct device		*dev;
> +
> +	struct clk		*xo_clk;
> +	struct clk		*sleep_a_clk;
> +
> +	struct regulator	*v3p3;
> +	struct regulator	*v1p8;
> +	struct regulator	*vddcx;
> +	struct regulator	*vbus;
> +};
> +
> +#define	phy_to_dwc3_phy(x)	container_of((x), struct msm_dwc3_hs_phy, phy)
> +
> +
> +/**
> + *
> + * Write register with debug info.

what debug info?

> + *
> + * @base - DWC3 base virtual address.
> + * @offset - register offset.
> + * @val - value to write.
> + *
> + */
> +static inline void msm_dwc3_hs_write(void *base, u32 offset, u32 val)

You've dropped __iomem here; have you run through sparse?

> +{
> +	iowrite32(val, base + offset);
> +}
> +
> +/**
> + * Write register and read back masked value to confirm it is written
> + *
> + * @base - DWC3 base virtual address.
> + * @offset - register offset.
> + * @mask - register bitmask specifying what should be updated
> + * @val - value to write.
> + *
> + */
> +static inline void msm_dwc3_hs_write_readback(void *base, u32 offset,
> +					    const u32 mask, u32 val)
> +{

Same comment here.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
