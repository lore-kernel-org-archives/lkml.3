Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3LTFzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:55:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9266 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab3LTFzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:55:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 20 Dec 2013 13:56:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <rjw@rjwysocki.net>, <festevam@gmail.com>, <b20788@freescale.com>,
        <viresh.kumar@linaro.org>
Subject: Re: [PATCH v3 1/2] ARM: imx6sl: Add cpu frequency scaling support
Message-ID: <20131220055642.GN7172@S2101-09.ap.freescale.net>
References: <1387512929-7304-1-git-send-email-john.tobias.ph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387512929-7304-1-git-send-email-john.tobias.ph@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:15:28PM -0800, John Tobias wrote:
> Re-use imx6q cpufreq driver to support cpu
> frequency scaling on imx6sl.
> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>

This one is already applied, so you do not have to resend.

Shawn

> ---
>  arch/arm/mach-imx/mach-imx6sl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
> index 2f952e3..3072e15 100644
> --- a/arch/arm/mach-imx/mach-imx6sl.c
> +++ b/arch/arm/mach-imx/mach-imx6sl.c
> @@ -34,6 +34,13 @@ static void __init imx6sl_fec_init(void)
>  	}
>  }
>  
> +static void __init imx6sl_init_late(void)
> +{
> +	/* imx6sl reuses imx6q cpufreq driver */
> +	if (IS_ENABLED(CONFIG_ARM_IMX6Q_CPUFREQ))
> +		platform_device_register_simple("imx6q-cpufreq", -1, NULL, 0);
> +}
> +
>  static void __init imx6sl_init_machine(void)
>  {
>  	struct device *parent;
> @@ -70,6 +77,7 @@ DT_MACHINE_START(IMX6SL, "Freescale i.MX6 SoloLite (Device Tree)")
>  	.map_io		= debug_ll_io_init,
>  	.init_irq	= imx6sl_init_irq,
>  	.init_machine	= imx6sl_init_machine,
> +	.init_late      = imx6sl_init_late,
>  	.dt_compat	= imx6sl_dt_compat,
>  	.restart	= mxc_restart,
>  MACHINE_END
> -- 
> 1.8.3.2
> 

