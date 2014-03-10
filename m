Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaCJOoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:44:37 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:45786 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaCJOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:44:34 -0400
Date: Mon, 10 Mar 2014 14:44:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: Re: [PATCH v3 3/5] pinctrl: st: add pinctrl support for the STiH407
 SoC
Message-ID: <20140310144429.GA13661@lee--X1>
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
 <1394203251-25361-4-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394203251-25361-4-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> 
> This patch adds the initial support for pinctrl based on H407 SoC.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

SOBs should be in order of submission flow and author's should only be
kept if the patch is unchanged. If it's been adapted you will require
a re-review and they Acked-by or Reviewed-by tag.

> ---
>  drivers/pinctrl/pinctrl-st.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 1721611..d1886b4 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -390,6 +390,19 @@ static const struct st_pctl_data  stih416_data = {
>  	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
>  };
>  
> +static const struct st_pctl_data  stih407_flashdata = {

Nit: Double space.

> +	.rt_style	= st_retime_style_none,
> +	.input_delays	= stih416_delays,
> +	.ninput_delays	= 14,

ARRAY_SIZE(stih416_delays)

> +	.output_delays	= stih416_delays,
> +	.noutput_delays = 14,

ARRAY_SIZE(stih416_delays)

> +	.alt = 0,
> +	.oe = -1, /* Not Available */
> +	.pu = -1, /* Not Available */
> +	.od = 60,
> +	.rt = 100,
> +};
> +
>  /* Low level functions.. */
>  static inline int st_gpio_bank(int gpio)
>  {
> @@ -1596,6 +1609,10 @@ static struct of_device_id st_pctl_of_match[] = {
>  	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-sbc-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-front-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-rear-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih407_flashdata},
>  	{ /* sentinel */ }
>  };

After the small changes above, feel free to add my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
