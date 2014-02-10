Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBJNQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:16:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBJNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:16:44 -0500
Message-ID: <1392038191.6687.12.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] reset: Add generic GPIO reset driver.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Fuzzey <mfuzzey@parkeon.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 14:16:31 +0100
In-Reply-To: <20140210125432.10683.86571.stgit@localhost>
References: <20140210125432.10683.86571.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Am Montag, den 10.02.2014, 13:54 +0100 schrieb Martin Fuzzey:
> This driver allows GPIO lines to be used as reset signals.
> It has two main use cases:
> 
> 1) Allow drivers to reset their hardware via a GPIO line in a standard fashion
> as supplied by the reset framework.
> This allows adhoc driver code requesting GPIOs etc to be replaced with a
> single call to device_reset().

have you seen the patch at https://lkml.org/lkml/2014/1/8/190:
"reset: Add GPIO support to reset controller framework" ?

Adding a GPIO reset controller device node to the device tree is the
wrong approach for devices enumerated in the device tree. Those should
just declare their reset-gpios directly.

> 2) Allow hardware on discoverable busses to be rest via a GPIO line
> without driver modifications.
>
> Examples of the second use case include:
> * SDIO wifi modules
> * USB hub chips with a reset line

Now this is interesting. But if you export it to userspace anyway, why
not use the existing gpio sysfs API?

I think a proper solution should handle this in the kernel. For SDIO
wifi modules you usually have a powerdown line that can be implemented
as an rfkill switch.

regards
Philipp

