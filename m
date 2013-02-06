Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3BFJhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:37:45 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:48833 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3BFJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <201302061031.04264.poeschel@lemonage.de>
References: <1359647903-15801-1-git-send-email-larsi@wh2.tu-dresden.de>
	<CACRpkda_HjzWNMD1H_a_fsWtbRWuTDsutS8kndb9jY31qf7Yyg@mail.gmail.com>
	<20130205142909.4F5B83E1265@localhost>
	<201302061031.04264.poeschel@lemonage.de>
Date: Wed, 6 Feb 2013 10:37:41 +0100
Message-ID: <CACRpkdawOE4WfUcCGpVSR9n5ZR9j1gFnMQ-EAOWOixcpM7uDUg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] gpio: mcp23s08: convert driver to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, w.sang@pengutronix.de,
        ben-linux@fluff.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:31 AM, Lars Poeschel <poeschel@lemonage.de> wrote:

> The thing that confused me was, that the platform_data for the chip has a
> mandatory "base" member, that sets the linux global gpio number at which the
> chip should appear.

Yes this is common. I think you should look at other drivers
under drivers/gpio using device tree, and how they work around
this.

As stated, as a last resort you can use AUXDATA to anyway assign
a piece of platform data per instance.

In the Nomadik driver, we use the block instance ID and multiply
by a factor of the numbers of GPIOs on each instance.
And luckily the base is zero. Not elegant maybe, but the
global GPIO numberspace is not elegant by nature.

Yours,
Linus Walleij
