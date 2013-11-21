Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3KUBjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:39:22 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60680 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146Ab3KUBjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:39:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KOoME4OYU6ufRDnKEYz9b
Date: Wed, 20 Nov 2013 17:38:59 -0800
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
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20131121013858.GK10317@atomide.com>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379277856-24571-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [130915 13:56]:
> +
> +Example for Nokia N900:
> +
> +ssi-controller@48058000 {
> +	compatible = "ti,omap3-ssi";
> +	ti,hwmods = "ssi";
> +
> +	reg = <0x48058000 0x1000>,
> +	      <0x48059000 0x1000>;
> +	reg-names = "sys",
> +		    "gdd";
> +
> +	interrupts = <55>;
> +	interrupt-names = "gdd_mpu";
> +
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +
> +	ssi-port@0 {
> +		compatible = "ti,omap3-ssi-port";
> +
> +		reg = <0x4805a000 0x800>,
> +		      <0x4805a800 0x800>;
> +		reg-names = "tx",
> +			    "rx";
> +
> +		interrupt-parent = <&intc>;
> +		interrupts = <51>,
> +			     <52>;
> +		interrupt-names = "mpu_irq0",
> +				  "mpu_irq1";
> +
> +		ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
> +	}
> +}

These should be in the omap3.dtsi file and not nested but separate. I'm almost
certain that these are completely independent hardware modules and this
means they can live their own PM life independently.

So can you please do a minimal patch for omap3.dtsi that just sets up
the standard resources separately for both modules the same way we have
for other hardware modules in omap3.dtsi do?

One of them should be called ssi, no idea what the other module name should
be as those register ranges show up as reserved in the docs I have.

The other binding pieces can be added later on as they get are ready.

Regards,

Tony
