Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaBXPNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:13:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35485 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbaBXPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:13:03 -0500
Date: Mon, 24 Feb 2014 15:13:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv1 3/6] HSI: hsi-char: add Device Tree support
Message-ID: <20140224151301.GJ28555@e106331-lin.cambridge.arm.com>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
 <1393199401-27197-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393199401-27197-4-git-send-email-sre@debian.org>
Thread-Topic: [PATCHv1 3/6] HSI: hsi-char: add Device Tree support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 11:49:58PM +0000, Sebastian Reichel wrote:
> Add of_match_table to hsi_char driver, so that it can
> be referenced from Device Tree.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/hsi/clients/hsi_char.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/hsi/clients/hsi_char.c b/drivers/hsi/clients/hsi_char.c
> index e61e5f9..7f64bed 100644
> --- a/drivers/hsi/clients/hsi_char.c
> +++ b/drivers/hsi/clients/hsi_char.c
> @@ -42,6 +42,7 @@
>  #include <linux/stat.h>
>  #include <linux/hsi/hsi.h>
>  #include <linux/hsi/hsi_char.h>
> +#include <linux/of_device.h>
>  
>  #define HSC_DEVS		16 /* Num of channels */
>  #define HSC_MSGS		4
> @@ -758,12 +759,22 @@ static int hsc_remove(struct device *dev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id hsi_char_of_match[] = {
> +	{ .compatible = "ssi-char", },

This string is undocumented.

> +	{ .compatible = "hsi-char", },

I'm not sure either string makes sense though; this feels like a binding
for the sake of the driver rather than describing the device and
allowing the driver to pick it up if it makes sense to do so.

What exactly is a "ssi-char" device or a "hsi-char" device?

Cheers,
Mark.
