Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaD1JQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:16:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54249 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754281AbaD1JQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:16:31 -0400
Date: Mon, 28 Apr 2014 10:15:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@linaro.org>
Cc: Barry Song <baohua@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching
	nodes
Message-ID: <20140428091532.GG26756@n2100.arm.linux.org.uk>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398644860-22973-1-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 08:27:40PM -0400, Matt Porter wrote:
> l2x0_of_init() is executed unconditionally within the sirfsoc_l2x0_init()
> early initcall. In a multi v7 kernel this causes bcm281xx and bcm21664
> platform to fail boot since they have their own pre l2x0 init sequence
> that is required. Fix this by checking that a matching OF ID is present
> before calling l2x0_of_init().
> 
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
> Applies against next-20140424 to fix the issue introduced in
> 50655e6 ARM: l2c: prima2: remove cache size override

Err, this only "fixes" it because it effectively disables the L2 cache
_entirely_ - in the above commit, I kill your private compatible strings.

This doesn't make sense.  If the cache is already enabled, then the L2C
code won't try to enable it again.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
