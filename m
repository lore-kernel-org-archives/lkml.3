Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaIWVwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:52:35 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45164 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIWVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:52:34 -0400
Date: Tue, 23 Sep 2014 16:52:26 -0500
From: Michael Welling <mwelling@emacinc.com>
To: linux-kernel@vger.kernel.org
Subject: GPIO registration for external Ethernet PHY oscillator enable/disable
Message-ID: <20140923215226.GA29000@sysresccd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some questions that span multiple subsystems including
gpio/pinctrl, apm, and net subsystems.

On some of our system on module designs, we use a GPIO to toggle the
enable pin on external oscillators. In particular, we are using a 50Mhz
oscillator to drive a clock on a RMII Ethernet PHY.

Though I can configure the pin such that the Ethernet interface works we 
are looking to disable the oscillator during APM sleep but after the PHY is 
put into a low power mode.

How do I register a GPIO for use in the PHY suspend and resume code?
Can it be handled outside of the PHY driver?
If so how do ensure the appropriate suspend and resume sequencing?

For reference, we are using a Micrel KSZ8081 PHY connected to a
AT91SAMA5D35 processor.
