Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaDSTtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:49:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59450 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:49:37 -0400
Date: Sat, 19 Apr 2014 21:49:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [PATCHv3 10/14] HSI: Introduce driver for SSI Protocol
Message-ID: <20140419194936.GJ5148@amd.pavel.ucw.cz>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-11-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396053110-21639-11-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This adds a driver for the SSI McSAAB protocol as used in
> the Nokia N900.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

> +#define SSIP_MIN_PN_HDR		6	/* FIXME: Revisit */
> +#define SSIP_WDTOUT		2000	/* FIXME: has to be 500 msecs> */

Can they be fixed now, or do they have to wait?


> +#ifdef __LITTLE_ENDIAN
> +	((u16 *)skb->data)[2] = swab16(((u16 *)skb->data)[2]);
> +	dev_dbg(&dev->dev, "RX length fixed (%04x -> %u)\n",
> +			((u16 *)skb->data)[2], ntohs(((u16 *)skb->data)[2]));
> +#endif

Uh. Can this be replaced by
    ((u16 *)skb->data)[2] = htons(((u16 *)skb->data)[2]);

(without the ifdef?)

> +	/*
> +	 * Modem sends Phonet messages over SSI with its own endianess...
> +	 * Assume that modem has the same endianess as we do.
> +	 */
> +	if (skb_cow_head(skb, 0))
> +		goto drop;
> +#ifdef __LITTLE_ENDIAN
> +	((u16 *)skb->data)[2] = swab16(((u16 *)skb->data)[2]);
> +#endif

Here, too?

But it looks like the comment does not match the code, because we
swap.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
