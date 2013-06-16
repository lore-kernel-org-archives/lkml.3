Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3FPLvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:51:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3FPLvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:51:14 -0400
Date: Sun, 16 Jun 2013 13:51:08 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Brian Lilly <brian@crystalfontz.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: mxs: dt: Add the Crystalfontz CFA-10055 device
 tree
Message-ID: <20130616135108.229d216e@skate>
In-Reply-To: <1371131025-12200-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
	<1371131025-12200-4-git-send-email-maxime.ripard@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

Some nitpicking below.

On Thu, 13 Jun 2013 15:43:44 +0200, Maxime Ripard wrote:

> -static void __init cfa10049_init(void)
> -{
> -	update_fec_mac_prop(OUI_CRYSTALFONTZ);
> -}
> -
> -static void __init cfa10037_init(void)
> +static void __init crystalfontz_init(void)
>  {
>  	update_fec_mac_prop(OUI_CRYSTALFONTZ);
>  }
> @@ -368,10 +363,10 @@ static void __init mxs_machine_init(void)
>  		imx28_evk_init();
>  	else if (of_machine_is_compatible("bluegiga,apx4devkit"))
>  		apx4devkit_init();
> -	else if (of_machine_is_compatible("crystalfontz,cfa10037"))
> -		cfa10037_init();
> -	else if (of_machine_is_compatible("crystalfontz,cfa10049"))
> -		cfa10049_init();
> +	else if (of_machine_is_compatible("crystalfontz,cfa10037") ||
> +		 of_machine_is_compatible("crystalfontz,cfa10049") ||
> +		 of_machine_is_compatible("crystalfontz,cfa10055"))
> +		crystalfontz_init();

Maybe this could be something like:

	else if (of_machine_is_compatible("crystalfontz,cfa10036"))
		crystalfontz_init();

with crystalfontz_init() something like:

	if (mac0 has status = "okay")
		update_fec_mac_prop(OUI_CRYSTALFONTZ);

This way, for all Crystalfontz boards that have an Ethernet interface,
it would call update_fec_mac_prop() without having to update mach-mxs.c
every time.

(Of course, this is based on the assumption that all Crystalfontz .dts
files have "crystalfontz,cfa10036" in their compatible string list)

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
