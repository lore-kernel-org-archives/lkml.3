Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaAMDYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:24:52 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20840
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbaAMDYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:24:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 13 Jan 2014 11:26:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <festevam@gmail.com>
Subject: Re: [PATCH v4 2/2] cpufreq: imx6q-cpufreq driver depends on
 SOC_IMX6Q/SOC_IMX6SL
Message-ID: <20140113032603.GG23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
 <1389321592-33220-2-git-send-email-john.tobias.ph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389321592-33220-2-git-send-email-john.tobias.ph@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:39:52PM -0800, John Tobias wrote:
> The ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP are moved up to ARCH_MCX.
> The driver should show if the SOC_IMX6Q and/or SOC_IMX6SL is/are selected.
> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  drivers/cpufreq/Kconfig.arm | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 3ba5dcc..230c663 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -80,7 +80,7 @@ config ARM_HIGHBANK_CPUFREQ
>  
>  config ARM_IMX6Q_CPUFREQ
>  	tristate "Freescale i.MX6 cpufreq support"
> -	depends on ARCH_MXC
> +	depends on SOC_IMX6Q || SOC_IMX6SL

No.  We do not want to touch this line where there is another IMX6xx can
reuse the driver.  Depending on ARCH_MXC is good enough, since we
already have the symbol prompt and help text to tell the targets that
the driver supports.

Shawn

>  	depends on REGULATOR_ANATOP
>  	help
>  	  This adds cpufreq driver support for Freescale i.MX6 series SoCs.
> -- 
> 1.8.3.2
> 

