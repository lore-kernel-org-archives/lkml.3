Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaD3Iy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:54:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbaD3IyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:54:25 -0400
Message-ID: <1398848062.19894.38.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v4 1/2] Documentation: Add GPIO reset binding to reset
 binding documentation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>, Roger Quadros <rogerq@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 30 Apr 2014 10:54:22 +0200
In-Reply-To: <20140417115820.GD4132@lukather>
References: <1397463709-19405-1-git-send-email-p.zabel@pengutronix.de>
	 <20140417115820.GD4132@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Am Donnerstag, den 17.04.2014, 13:58 +0200 schrieb Maxime Ripard:
> I still feel like we should really treat gpios like just another reset
> controller, ie. using the resets property.

I now feel like we really shouldn't. If we do anything but use the
generic gpio bindings for reset gpios, we might force every OS or
bootloader using the device tree to implement some kind of reset
controller framework, even for hardware that only has gpio resets.

> I understand that you chose this pattern to be pretty much compatible
> with what have been done so fare, bu I don't see how to fulfill that
> goal completely, since most of the devices are actually using
> reset-gpios, but some are using other names too (including
> reset-gpio).

Yes, that is a problem that applies to all gpios, not only to reset
gpios, though.

> So if we can't be fully backward compatible, I don't see the benefit
> of being inconsistent with how reset controllers are used in general,

See above.

> and more globally on how gpios are tied for regulators for example.

Reset controllers are rather more similar to gpio or interrupt
controllers. Those also have a number of entities per device node,
as opposed to regulators.

> That would also make reset-gpio a regular reset driver, instead of
> adding logic to the core itself to handle this special case.

Which is what I initially tried and moved away from.

regards
Philipp

