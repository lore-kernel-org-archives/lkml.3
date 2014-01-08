Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbaAHOkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:40:14 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2462 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbaAHOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:40:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 Jan 2014 22:40:57 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: imx: select ARCH_HAS_CPUFREQ for iMX6SL
Message-ID: <20140108144056.GD10725@S2101-09.ap.freescale.net>
References: <1389148163-5243-1-git-send-email-john.tobias.ph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389148163-5243-1-git-send-email-john.tobias.ph@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 06:29:23PM -0800, John Tobias wrote:
> iMX6SL now supports the cpufreq scaling by re-using the imx6q-cpufreq driver.
> By adding it, the user has the capability to select the said driver without
> depending it to SOC_IMX6Q.
> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
> Changes since v1:
> - Fix typo in commit log
> - Added Shawn Guo on Cc
> 
>  arch/arm/mach-imx/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7a6e6f7..704e5ae 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -808,6 +808,7 @@ config SOC_IMX6Q
>  
>  config SOC_IMX6SL
>  	bool "i.MX6 SoloLite support"
> +	select ARCH_HAS_CPUFREQ

Since we will eventually enable CPUFREQ and OPP for most of the
platforms, maybe we should just move selection of ARCH_HAS_CPUFREQ,
ARCH_HAS_OPP and PM_OPP into 'config ARCH_MXC'?

Shawn

>  	select ARM_ERRATA_754322
>  	select ARM_ERRATA_775420
>  	select ARM_GIC
> -- 
> 1.8.3.2
> 

