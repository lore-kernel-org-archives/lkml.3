Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaCCPCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:02:30 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36265 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753980AbaCCPC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:02:28 -0500
Date: Mon, 3 Mar 2014 15:02:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140303150215.GI21483@n2100.arm.linux.org.uk>
References: <20140207180836.GE8533@titan.lakedaemon.net> <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 08:00:36PM +0000, Jason Cooper wrote:
> The corresponding driver didn't make it into v3.14, so we need to remove
> the node.  Dove systems fail to boot with the node present and no
> driver.
> 
> This node will be re-added when the driver makes it to mainline.

I'm going to stick my oar in on this and ask what is a very fundamental
question.

If we're adding the PMU interrupt controller as a separate "device"
aren't we describing our implementation rather than the hardware?  It
isn't a separate device as far as the description of it in the reference
manuals.

Moreover, should the PMU interrupt controller be something which is
handled by a separate chunk of code to a driver for the PMU as a whole,
or are we storing up problems with resource clashes?  I can quite see
a PMU driver coming along in the future offering a pair of generic
power domains for the GPU and VPU, and such a driver would need to map
all the PMU registers so it can access the power control, reset and
isolator registers.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
