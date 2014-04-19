Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaDSTa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:30:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59226 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaDSTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:30:52 -0400
Date: Sat, 19 Apr 2014 21:30:51 +0200
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
Subject: Re: [PATCHv3 08/14] HSI: Introduce OMAP SSI driver
Message-ID: <20140419193050.GH5148@amd.pavel.ucw.cz>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-9-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396053110-21639-9-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add OMAP SSI driver to the HSI subsystem.
> 
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
> 
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

> +	bool			wktest:1; /* FIXME: HACK to be removed */
> +	bool			wkin_cken:1; /* Workaround */

There is more thanone FIXME in the code. It may be better to fix after
merge...


> +DEFINE_SIMPLE_ATTRIBUTE(ssi_sst_div_fops, ssi_div_get, ssi_div_set, "%llu\n");
> +
> +static int __init ssi_debug_add_port(struct omap_ssi_port *omap_port,
> +							struct dentry *dir)
> +{

A little strange indentation. Is it intentional?

> +	if (IS_ERR(dir))
> +		return PTR_ERR(dir);
> +	debugfs_create_file("divisor", S_IRUGO | S_IWUSR, dir, port,
> +							&ssi_sst_div_fops);

Here, too.

> +	dev_dbg(&ssi->device, "TX div %d for fck_rate %lu Khz speed %d Kb/s\n",
> +			tx_fckrate / omap_ssi->max_speed, omap_ssi->fck_rate,
> +							omap_ssi->max_speed);

...and here.

> +	if (--omap_port->wk_refcount) {
> +		spin_unlock_bh(&omap_port->wk_lock);
> +		return 0;
> +	}
> +	writel(SSI_WAKE(0),
> +				omap_ssi->sys + SSI_CLEAR_WAKE_REG(port->num));

...and here. Should be on one line, AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
