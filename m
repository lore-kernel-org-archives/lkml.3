Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaFEL5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:57:21 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44052 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaFEL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:57:18 -0400
Date: Thu, 5 Jun 2014 12:57:14 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, Olivier Bideau <olivier.bideau@st.com>,
        linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 05/12] drivers: clk: st: STiH407:
 Support for clockgenA0
Message-ID: <20140605115714.GA2294@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-6-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-6-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabi,

On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:

> The patch added support for DT registration of ClockGenA0
> It includes c32 type PLL.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
> ---
>  drivers/clk/st/clkgen-pll.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
> index d8b9b1a..6916cfa 100644
> --- a/drivers/clk/st/clkgen-pll.c
> +++ b/drivers/clk/st/clkgen-pll.c
> @@ -180,6 +180,18 @@ static struct clkgen_pll_data st_pll1200c32_gpu_416 = {
>  	.ops		= &st_pll1200c32_ops,
>  };
>  
> +static struct clkgen_pll_data st_pll3200c32_407_a0 = {
> +	/* 407 A0 */
> +	.pdn_status	= CLKGEN_FIELD(0x2a0,	0x1,			8),
> +	.locked_status	= CLKGEN_FIELD(0x2a0,	0x1,			24),
> +	.ndiv		= CLKGEN_FIELD(0x2a4,	C32_NDIV_MASK,		16),
> +	.idf		= CLKGEN_FIELD(0x2a4,	C32_IDF_MASK,		0x0),
> +	.num_odfs = 1,
> +	.odf		= { CLKGEN_FIELD(0x2b4, C32_ODF_MASK,		0) },
> +	.odf_gate	= { CLKGEN_FIELD(0x2b4,	0x1,			6) },
> +	.ops		= &stm_pll3200c32_ops,
> +};
> +
>  /**
I think these could be 'static const' as well, with some fixups in the function protoypes 
which use it.

Apart from that : -
 Acked-by: Peter Griffin <peter.griffin@linaro.org>

Regards,

Peter
