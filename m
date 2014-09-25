Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaIYTRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:17:32 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62302 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:17:30 -0400
Date: Thu, 25 Sep 2014 14:17:22 -0500
From: Michael Welling <mwelling@emacinc.com>
To: linux-kernel@vger.kernel.org
Cc: mwelling@emacinc.com, f.fainelli@gmail.com, grant.likely@linaro.org,
        linus.walleij@linaro.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org
Subject: GPIO registration for external Ethernet PHY oscillator enable/disable
Message-ID: <20140925191722.GA2481@sysresccd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923215226.GA29000@sysresccd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like my original message got buried in the mailing list.

Lets try this again with a few key developers CC'd.

Original Message:
I have some questions that span multiple subsystems including
gpio/pinctrl, apm, and net subsystems.

On some of our system on module designs, we use a GPIO to toggle the
enable pin on external oscillators. In particular, we are using a 50Mhz
oscillator to drive a clock on a RMII Ethernet PHY.

Though I can configure the pin such that the Ethernet interface works we
are looking to disable the oscillator during APM sleep but after the PHY
is put into a low power mode.

How do I register a GPIO for use in the PHY suspend and resume code?
Can it be handled outside of the PHY driver?
If so how do ensure the appropriate suspend and resume sequencing?

For reference, we are using a Micrel KSZ8081 PHY connected to a
AT91SAMA5D35 processor.

Addendum:
I ran into another situation where a GPIO enabled oscillator was used.
The oscillator in this case drives the master clock for a audio codec.
In the old days (before device tree), I could initialize the GPIO in the
platform board file. Now with device tree I can setup the pin multipler
but the initial state of the GPIO I am not sure how to set.

Is there a way to directly change the state of a GPIO pin from a
devicetree entry?
