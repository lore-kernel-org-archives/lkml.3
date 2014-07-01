Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbaGANKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:10:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49803 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751513AbaGANKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:10:35 -0400
Date: Tue, 1 Jul 2014 14:10:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701131026.GO32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
> +	pdev = platform_device_register_full(&armada_drm_dev_info);
> +	/* assign last found lcd node to drm device for clk lookup */
> +	pdev->dev.of_node = clknp;

NAK.  This really isn't a good way to deal with this, even in a
temporary basis.  While assigning a DT node to a manually created
platform device does solve that problem, it also introduces the
problem that this platform device will now match any platform driver
which recognises the "marvell,dove-lcd" compatible type, which may
occur _before_ we find the driver to match using the legacy strings.

There really isn't an easy solution to this other than doing the thing
properly.

The other problem in this series is that while you introduce some
bindings which may work today, they're not going to work tomorrow, and
that's a problem.  Don't do DT piecemeal like this and end up having to
break the bindings (which we will have to do to add the endpoints.)

If you want to do this then you need to add the endpoints from the start
even though the driver doesn't yet make use of them - or don't add the
DT bits at all.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
