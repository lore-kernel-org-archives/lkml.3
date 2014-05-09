Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbaEIVp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:45:26 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6636 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757812AbaEIVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:45:25 -0400
Date: Fri, 9 May 2014 14:45:42 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Andy Gross <agross@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [Patch v2] pinctrl: msm: Add more MSM8X74 pin definitions
Message-ID: <20140509214541.GB25733@sonymobile.com>
References: <1399657974-32695-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399657974-32695-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09 May 10:52 PDT 2014, Andy Gross wrote:

> This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
> include:
> 
> BLSP devices (I2C, UART, UART flow control, SPI, and UIM), mi2s, gp clk, pdm,
> gcc clk, cci_timer, cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted
> pins.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Awesome stuff, only have some minor comments.

> +       MSM_MUX_blsp_uart1,
> +       MSM_MUX_blsp_uart1_flow,
[...]
> +static const char * const blsp_uim1_groups[] = { "gpio0", "gpio1" };
> +static const char * const blsp_uart1_flow_groups[] = { "gpio2", "gpio3" };

You don't need to separate uart and flow control into two different functions
here.  If you have gpio0-gpio3 in a group named uart1 both of the following
snippets are valid:

uart1 {
	pins = "gpio0", "gpio1";
	function = "uart1";
};

uart1 {
	pins = "gpio0", "gpio1", "gpio2", "gpio3";
	function = "uart1";
};

This is how I had to handle gsbis in family a, where a gsbi is pairs of pins
with different configurations.

[...]
> +static const char * const hdmi_cec_groups[] = { "gpio31" };
> +static const char * const hdmi_ddc_groups[] = { "gpio32", "gpio33" };
> +static const char * const hdmi_hpd_groups[] = { "gpio34" };

As with the uart vs uart_flow you could group these as "hdmi", but maybe not as
useful.

[...]
> +       PINGROUP(35,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(36,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(37,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(38,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(39,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(40,  NA, sdc3, NA, NA, NA, NA, NA),
> +       PINGROUP(41,  NA, blsp_spi7, blsp_uart7, blsp_uim7, NA, NA, NA),
> +       PINGROUP(42,  NA, blsp_spi7, blsp_uart7, blsp_uim7, NA, NA, NA),
> +       PINGROUP(43,  NA, blsp_spi7, blsp_uart7_flow, blsp_i2c7, NA, NA, NA),
> +       PINGROUP(44,  NA, blsp_spi7, blsp_uart7_flow, blsp_i2c7, NA, NA, NA),

I was expecting wcnss, bt and fm as function 1 for pins 35-44. Adding those and
I think we have everything we use in our devices.

[...]
> +       PINGROUP(72,  NA, spkr_mi2s, NA, NA, NA, NA, NA),

spkr_mi2s is function 1 for pin 72.

Regards,
Bjorn
