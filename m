Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaFYNuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:50:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42527 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756995AbaFYNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:50:49 -0400
Date: Wed, 25 Jun 2014 14:50:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 0/6] Enable L2 cache support on Exynos4210/4x12 SoCs
Message-ID: <20140625135039.GM3705@n2100.arm.linux.org.uk>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:37:25PM +0200, Tomasz Figa wrote:
> This series intends to add support for L2 cache on Exynos4 SoCs on boards
> running under secure firmware, which requires certain initialization steps
> to be done with help of firmware, as selected registers are writable only
> from secure mode.

What I said in my message on June 12th applies to this series.  I'm
not having the virtual address exposed via the write_sec call.

Yes, you need to read other registers in order to use your secure
firmware implementation.  Let's fix that by providing a better write_sec
interface so you don't have to read back these registers, rather than
working around this short-coming.

That's exactly what I meant when I talked on June 12th about turning
cache-l2x0.c back into a pile of crap.  You're working around problems
rather than fixing the underlying issue, as seems to be standard
platform maintainer behaviour when things like core ARM code is
concerned.  This is why things devolve over time into piles of crap,
because platforms just hack around problems rather than fixing the
root cause of the problem.

So... I'm NAKing the entire series.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
