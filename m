Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3BFLmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:42:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36537 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3BFLmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:42:16 -0500
Date: Wed, 6 Feb 2013 11:36:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, gregkh@linuxfoundation.org,
        tony@atomide.com, eballetbo@gmail.com, javier@dowhile0.org,
        b-cousson@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: OMAP2: MUSB: Specify omap4 has mailbox
Message-ID: <20130206113656.GG17852@n2100.arm.linux.org.uk>
References: <1360130294-5976-1-git-send-email-kishon@ti.com> <1360130294-5976-4-git-send-email-kishon@ti.com> <20130206105713.GF17852@n2100.arm.linux.org.uk> <20130206110355.GH22064@arwen.pp.htv.fi> <20130206112231.GI22064@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206112231.GI22064@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 01:22:31PM +0200, Felipe Balbi wrote:
> there's a little more to it. When running allmodconfig,
> CONFIG_ARCH_MULTIPLATFORM is set but none of the other ARCHes
> (ARCH_OMAP, ARCH_AT91, ARCH_VERSATILE, etc) are set, so it turned out
> that the driver wasn't even included on my build test.
> 
> Russell, is this expected (the MULTIPLATFORM thing) ? Just so I fix my
> build test scripts to use another defconfig instead of allmod and
> allyes.

Don't know.  Most of that logic is sitting in arm-soc.  Nothing obvious
stands out as to why that's happening.

The first thing to check is which of the CONFIG_ARCH_MULTI_* options are
set.  It should be ARCH_MULTI_V7 and ARCH_MULTI_V6_V7.  This should then
allow ARCH_OMAP2PLUS to be set.

However, I've said this before, and I'll say it again: if you want to use
the all* targets, it's better to seed the configuration so that you end
up with the platform you're targetting selected.  I've always done this
with the build system, and even before it when I've wanted to use the all*
targets, because generally I want that behaviour, but I want it for a
particular platform.
