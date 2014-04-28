Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaD1OxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:53:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54837 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756339AbaD1OxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:53:22 -0400
Date: Mon, 28 Apr 2014 15:52:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching
	nodes
Message-ID: <20140428145223.GL26756@n2100.arm.linux.org.uk>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org> <20140428142950.GB30292@saruman.home> <20140428143709.GC7719@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428143709.GC7719@beef>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:37:09AM -0400, Matt Porter wrote:
> The "fix" is tested against bcm281xx and bcm21664 as that is what the
> l2c cleanup breaks in -next. As mentioned, I don't have the sirfsoc h/w
> so this first attempt at a fix also breaks their platform. It can be
> addressed by adding those platform specific compatibles back to the dts,
> of course.
> 
> I'd much prefer that the sirfsoc folks fix this...it's going to break
> other platforms in a multi v7 build.

Well, it's about time we got rid of this from platform specific code
anyway, taking it away from platform maintainers to mess around with.
So that's what I'm doing.

It's worth noting that if you build a single zImage with exynos also
enabled, then you also end up with an unconditional call from that
code to l2x0_of_init() with it's own magic numbers - and that applies
before my changes.

So let's fix this properly and yank this crap from platform maintainers
fingers.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
