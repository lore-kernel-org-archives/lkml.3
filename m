Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaKGL0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:26:06 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58855 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751437AbaKGL0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:26:00 -0500
Date: Fri, 7 Nov 2014 11:25:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141107112549.GA4047@n2100.arm.linux.org.uk>
References: <20141102180756.GH31454@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102180756.GH31454@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 10:07:56AM -0800, Tony Lindgren wrote:
> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> configuration") enabled configuring the PM features for twl4030.
> 
> This caused poweroff command to fail on devices that have the
> BCI charger on twl4030 wired, or have power wired for VBUS.
> Instead of powering off, the device reboots. This is because
> voltage is detected on charger or VBUS with the default bits
> enabled for the power transition registers.
> 
> To fix the issue, let's just clear VBUS and CHG bits as we want
> poweroff command to keep the system powered off.
> 
> Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
> Cc: stable@vger.kernel.org # v3.16+
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

This fixes the problem for me, thanks.  This needs to go into -rc as
it's a regression between booting non-DT and DT, and stands in the way
of me switching from non-DT booting on OMAP3430.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
