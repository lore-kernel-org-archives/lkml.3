Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3KYNHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:07:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51436 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3KYNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:02 -0500
Date: Mon, 25 Nov 2013 14:07:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi
Subject: Re: [PATCH 3/3] dt: binding documentation for bq2415x charger
Message-ID: <20131125130700.GC21526@amd.pavel.ucw.cz>
References: <1385311771-447-1-git-send-email-sre@debian.org>
 <1385311771-447-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385311771-447-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-11-24 17:49:31, Sebastian Reichel wrote:
> Add devicetree binding documentation for bq2415x charger.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Thanks!

> +- reg: integer, i2c address of the device
> +- ti,current-limit: integer, current limit in mA

Does this need to be "ti," specific? Most of fields are likely to be
needed for other li-ion chargers....

"Specifies maximum current charger can pull from power supply"

?

> +- ti,charge-current: integer, charging current in mA

...why/how is it different from current-limit? Is the current-limit on
5V, while the charge-current relative to battery voltage... so that
charge-current can be > current-limit when battery voltage is low?

"Maximum current that will be supplied to the battery, as determined
by voltage on current sense resistor"?

> +- ti,weak-battery-voltage: integer, weak battery voltage threshold in mV

It would be good to explain what this threshold means. Voltage so low
that system needs to be shut down?

Hmm, it looks to me like it is "as long as battery is below this
voltage, fast charge is not started. Instead, slow 'precharge' is
performed."

> +- ti,battery-regulation-voltage: integer, battery regulation
>  voltage in mV

"Selects maximum voltage for charging."

> +- ti,termination-current: integer, termination current in mA

"When current in constant-voltage phase drops below this value, charge
is terminated".


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
