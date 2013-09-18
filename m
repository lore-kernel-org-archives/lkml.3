Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3IRTXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:23:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50956 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393Ab3IRTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:23:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+jsOwcvYZMFc87cHZEA0hn
Date: Wed, 18 Sep 2013 12:23:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFCv2 2/3] ARM: OMAP2+: HSI: Introduce OMAP SSI driver
Message-ID: <20130918192331.GD9994@atomide.com>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379277856-24571-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [130915 13:56]:
> This patch adds an OMAP SSI driver to the HSI framework.

Thanks for working on this.
 
> +config OMAP_SSI
> +	tristate "OMAP SSI hardware driver"
> +	depends on ARCH_OMAP && HSI
> +	default n
> +	---help---
> +	  SSI is a legacy version of HSI. It is usually used to connect
> +	  an application engine with a cellular modem.
> +	  If you say Y here, you will enable the OMAP SSI hardware driver.

You can drop the "default n" line here, it's the default.

> +/* TODO: HACK: define omap_pm_get_dev_context_loss_count, because it is defined
> + * in arch/arm/mach-omap2/omap-pm.h and thus not available via #include */
> +int omap_pm_get_dev_context_loss_count(struct device *dev);

You can drop this and related calls completely and rely on some
SSI configuration registers instead to detect if context was lost.

The reason for that is that the context loss count should be
implemented in Linux generic way if needed at all and we can leave
out a dependency to that.

If there's a chance that the context is only partially lost,
then of course something else is needed. So far I have not
hit that issue for MMC or serial at least, but you'd have to
test this with off-idle to verify it.

Regards,

Tony

