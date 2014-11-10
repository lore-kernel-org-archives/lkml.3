Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaKJRxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:53:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33443 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753415AbaKJRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:53:53 -0500
Date: Mon, 10 Nov 2014 17:53:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141110175343.GB4047@n2100.arm.linux.org.uk>
References: <20141102180756.GH31454@atomide.com>
 <20141110124019.GZ21424@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110124019.GZ21424@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:40:19PM +0000, Lee Jones wrote:
> On Sun, 02 Nov 2014, Tony Lindgren wrote:
> 
> > Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> > configuration") enabled configuring the PM features for twl4030.
> > 
> > This caused poweroff command to fail on devices that have the
> > BCI charger on twl4030 wired, or have power wired for VBUS.
> > Instead of powering off, the device reboots. This is because
> > voltage is detected on charger or VBUS with the default bits
> > enabled for the power transition registers.
> > 
> > To fix the issue, let's just clear VBUS and CHG bits as we want
> > poweroff command to keep the system powered off.
> > 
> > Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
> > Cc: stable@vger.kernel.org # v3.16+
> > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> Applied to -fixes.
> 
> Not sure whether that was an Ack from Russell or not?

A Tested-by would've been more appropriate than an ack.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
