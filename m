Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaGaS1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:27:36 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48129 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaGaS1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:27:34 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@gmail.com>
CC: "dianders@chromium.org" <dianders@chromium.org>,
        "heiko@sntech.de" <heiko@sntech.de>, "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Topic: [PATCH v2 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Index: AQHPrHg1av/iig1Xn0mlifqp97n/PZu6gAxA
Date: Thu, 31 Jul 2014 18:24:59 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C33F1@US01WEMBX2.internal.synopsys.com>
References: <1406780999-17798-1-git-send-email-kever.yang@rock-chips.com>
 <1406780999-17798-3-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1406780999-17798-3-git-send-email-kever.yang@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kever Yang [mailto:kever.yang@gmail.com]
> Sent: Wednesday, July 30, 2014 9:30 PM
> 
> This patch add compatible data for dwc2 controller found on
> rk3066, rk3188 and rk3288 processors from rockchip.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v2:
> - set most parameters as driver auto-detect
> 
>  drivers/usb/dwc2/platform.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 5f0c4bb..5e610dd 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -77,6 +77,34 @@ static const struct dwc2_core_params params_bcm2835 = {
>  	.uframe_sched			= 0,
>  };
> 
> +static const struct dwc2_core_params params_rk3066 = {
> +	.otg_cap			= 2,	/* non-HNP/non-SRP */
> +	.otg_ver			= -1,
> +	.dma_enable			= -1,
> +	.dma_desc_enable		= 0,
> +	.speed				= -1,
> +	.enable_dynamic_fifo		= 1,
> +	.en_multiple_tx_fifo		= -1,
> +	.host_rx_fifo_size		= 520,	/* 520 DWORDs */
> +	.host_nperio_tx_fifo_size	= 128,	/* 128 DWORDs */
> +	.host_perio_tx_fifo_size	= 256,	/* 256 DWORDs */
> +	.max_transfer_size		= -1,
> +	.max_packet_count		= -1,
> +	.host_channels			= -1,
> +	.phy_type			= -1,
> +	.phy_utmi_width			= -1,
> +	.phy_ulpi_ddr			= -1,
> +	.phy_ulpi_ext_vbus		= -1,
> +	.i2c_enable			= -1,
> +	.ulpi_fs_ls			= -1,
> +	.host_support_fs_ls_low_power	= -1,
> +	.host_ls_low_power_phy_clk	= -1,
> +	.ts_dline			= -1,
> +	.reload_ctl			= -1,
> +	.ahbcfg				= 0x7, /* INCR16 */
> +	.uframe_sched			= -1,
> +};
> +
>  /**
>   * dwc2_driver_remove() - Called when the DWC_otg core is unregistered with the
>   * DWC_otg driver
> @@ -99,6 +127,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
> 
>  static const struct of_device_id dwc2_of_match_table[] = {
>  	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
> +	{ .compatible = "rockchip,rk3066-usb", .data = &params_rk3066 },
>  	{ .compatible = "snps,dwc2", .data = NULL },
>  	{},
>  };
> --

Acked-by: Paul Zimmerman <paulz@synopsys.com>

