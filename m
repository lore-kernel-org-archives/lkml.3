Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaGGO5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:57:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57986 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbaGGO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:57:24 -0400
Date: Mon, 7 Jul 2014 16:57:21 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com,
        Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 03/18] AT91: G45: DT: Declare a second ram controller
Message-ID: <20140707145721.GC3113@piout.net>
References: <1404743131-24569-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404743131-24569-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404743131-24569-4-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/07/2014 at 16:25:16 +0200, Maxime Ripard wrote :
> The G45 has two identical ram controller, that are defined as a single one,
> with two reg cells.
> 
> The proper way to support such a case is to have two separate DT nodes.
> 

This is also the case for the sam9263, please fix it there too.

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index ace6bf197b70..6f648b85b725 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -75,8 +75,12 @@
>  
>  			ramc0: ramc@ffffe400 {
>  				compatible = "atmel,at91sam9g45-ddramc";
> -				reg = <0xffffe400 0x200
> -				       0xffffe600 0x200>;
> +				reg = <0xffffe400 0x200>;
> +			};
> +
> +			ramc1: ramc@ffffe600 {
> +				compatible = "atmel,at91sam9g45-ddramc";
> +				reg = <0xffffe600 0x200>;
>  			};
>  
>  			pmc: pmc@fffffc00 {
> -- 
> 2.0.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
