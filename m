Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaGBLXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:23:24 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51205 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751083AbaGBLXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:23:22 -0400
Date: Wed, 2 Jul 2014 12:23:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz =?utf-8?Q?Stanis=C5=82awski?= <t.stanislaws@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ABBA deadlock in Common Clock Framework
Message-ID: <20140702112314.GI32514@n2100.arm.linux.org.uk>
References: <53B3E5F8.80501@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3E5F8.80501@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:59:04PM +0200, Tomasz Figa wrote:
> Hi All,
> 
> While testing linux-next (next-20140625) on Exynos4412-based TRATS2
> board, from time to time I hit a deadlock between clk_disable_unused()
> of Common Clock Framework and parallel clk_prepare() from s3c24xx-i2c
> driver.

This is pretty sad.  The Linux kernel has quite a range of truely excellent
debugging tools which can be built in, but it seems many developers don't
enable them.  The important one here is lockdep (which I notice isn't on
in your kernel.)

Lockdep is a static lock checker - it tracks the dependencies and contexts
between various locks and can report whether deadlock is possible without
having to run into the deadlock.  It is /highly/ recommended that all
developers should run their changes through a kernel with this feature
on before submitting them upstream - see Documentation/SubmitChecklist
point 15.

It can really catch these things before the patch is even submitted...
The recommendation is that if you're doing kernel development, always
have lockdep enabled.  If you want to do performance checking, then
obviously it has an impact on that, so turn it off to do that, but
remember to turn it back on before you do further development.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
