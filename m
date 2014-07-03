Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbaGCXBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:01:31 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53600 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755047AbaGCXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:01:29 -0400
Date: Fri, 4 Jul 2014 00:01:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Belisko <marek@goldelico.com>, Olof Johansson <olof@lixom.net>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, tony@atomide.com,
        balajitk@ti.com, chris@printf.net, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, hns@goldelico.com,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] mmc: hsmmc: Add reset gpio configuration option.
Message-ID: <20140703230113.GR3705@n2100.arm.linux.org.uk>
References: <1404420564-30245-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404420564-30245-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 10:49:23PM +0200, Marek Belisko wrote:
> From: NeilBrown <neilb@suse.de>
> 
> If a 'gpio_reset' is specified, then hold it low while
> turning the power regulator on.
> This is needed for some wi2wi wireless modules, particularly
> when the regulator is held active by some other client.
> The wi2wi needs to be reset if power isn't actually removed, and
> the gpio can be used to do this.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Obvious statement knowing what's been going on elsewhere...

A while back, Olof produced a couple of patches to add /generic/ support
to deal with power and reset controls for SDIO WIFI cards.  Patches
were posted to linux-arm-kernel and other places around January time
this year.

No real conclusion came out of it, and it kind of died.  The point here
is that this is not an OMAP problem.  We have this very same problem
on different platforms and different SoCs.

Why should we have N different solutions to the same problem.  Why can't
we have one solution to fix this issue, rather than having every host
driver implement some different solution to what's a common problem.

If everyone is going to run away from generic problems and continue
inventing their own private solutions to generic problems, the kernel
is just going to become severely bloated and unmaintainable...

Please, sort out generic problems with generic solutions.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
