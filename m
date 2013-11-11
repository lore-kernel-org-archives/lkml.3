Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3KKQtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:49:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52667 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3KKQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:49:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yG1O3uZUBRk+DBcYicnrA
Date: Mon, 11 Nov 2013 08:49:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: linux@arm.linux.org.uk, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Message-ID: <20131111164917.GN15154@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <1381784555-18344-2-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381784555-18344-2-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [131014 14:11]:
> devconf1 reg access is localized only in mach-omap2 and we need to export
> updating of devconf1 from omapdss venc driver (bypass and acbias bits).
> Add simple api call which update only necessary bits.
...

> +void update_bypass_acbias(bool bypass, bool acbias)
> +{
> +#ifdef CONFIG_ARCH_OMAP3
> +	int val = omap_ctrl_readl(OMAP343X_CONTROL_DEVCONF1);
> +
> +	if (bypass)
> +		val |= OMAP2_TVOUTBYPASS;
> +	else
> +		val &= ~OMAP2_TVOUTBYPASS;
> +
> +	if (acbias)
> +		val |= OMAP2_TVACEN;
> +	else
> +		val &= ~OMAP2_TVACEN;
> +
> +	omap_ctrl_writel(val, OMAP343X_CONTROL_DEVCONF1);
> +#endif

If this is truly a pinmux, you could already access this
using pinctrl-single,bits device tree driver.

But I guess that won't work yet, so it's best to set this
up as a separate driver like we've done for the USB PHY
registers.

Regards,

Tony
