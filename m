Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3ARPDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:03:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49616 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3ARPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:02:59 -0500
Date: Fri, 18 Jan 2013 15:02:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 06/22] mfd: omap-usb-tll: introduce and use
	mode_needs_tll()
Message-ID: <20130118150242.GF23505@n2100.arm.linux.org.uk>
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511445-26656-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:17:09PM +0200, Roger Quadros wrote:
> +/* only PHY and UNUSED modes don't need TLL */
> +#define omap_usb_mode_needs_tll(x)	((x != OMAP_USBHS_PORT_MODE_UNUSED) &&\
> +					 (x != OMAP_EHCI_PORT_MODE_PHY))

Growl.

These parens do not make anything safer at all - they just obfuscate.  The
safe version of the above macro would have been:

#define omap_usb_mode_needs_tll(x)	((x) != OMAP_USBHS_PORT_MODE_UNUSED &&\
					 (x) != OMAP_EHCI_PORT_MODE_PHY)

If you're going to use a macro argument in an expression, it needs parens.
Simple expressions like a != b && c != d do _not_ need parens.

