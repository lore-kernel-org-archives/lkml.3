Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaAaMhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:37:01 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:60525 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343AbaAaMg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:36:59 -0500
Message-ID: <52EB974D.3070403@st.com>
Date: Fri, 31 Jan 2014 12:30:05 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Patrice CHOTARD <patrice.chotard@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Cc: <maxime.coquelin@st.com>, <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 2/4] pinctrl: st: add stid127 support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-3-git-send-email-patrice.chotard@st.com>
In-Reply-To: <1391093744-19905-3-git-send-email-patrice.chotard@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good for me.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

On 30/01/14 14:55, Patrice CHOTARD wrote:
> From: Alexandre TORGUE <alexandre.torgue@st.com>
> 
> Add STid127 PIOs (psouth, pwest, peast) in pinctrl.
> 
> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
> ---
>  drivers/pinctrl/pinctrl-st.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 9cadc68..01227de 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -336,6 +336,27 @@ static const struct st_pctl_data  stih416_data = {
>  	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
>  };
>  
> +/* STid127 data */
> +static const struct st_pctl_data  stid127_data = {
> +	.rt_style	= st_retime_style_dedicated,
> +	/* reuse stih416 delays as they are identical */
> +	.input_delays	= stih416_delays,
> +	.ninput_delays	= 14,
> +	/* reuse stih416 delays as they are identical */
> +	.output_delays	= stih416_delays,
> +	.noutput_delays = 14,
> +	.alt = 0, .oe = 8, .pu = 10, .od = 12, .rt = 14,
> +};
> +
> +static const struct st_pctl_data  stid127_psouth_data = {
> +	.rt_style	= st_retime_style_dedicated,
> +	.input_delays	= stid127_delays,
> +	.ninput_delays	= 14,
> +	.output_delays	= stid127_delays,
> +	.noutput_delays = 14,
> +	.alt = 0, .oe = 7, .pu = 9, .od = 11, .rt = 13,
> +};
> +
>  /* Low level functions.. */
>  static inline int st_gpio_bank(int gpio)
>  {
> @@ -1264,6 +1285,10 @@ static struct of_device_id st_pctl_of_match[] = {
>  	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
>  	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
> +	{ .compatible = "st,stid127-pwest-pinctrl", .data = &stid127_data },
> +	{ .compatible = "st,stid127-psouth-pinctrl",
> +		.data = &stid127_psouth_data },
> +	{ .compatible = "st,stid127-peast-pinctrl", .data = &stid127_data },
>  	{ /* sentinel */ }
>  };
>  
> 

