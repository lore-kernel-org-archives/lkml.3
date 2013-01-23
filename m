Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3AWK2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:28:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53167 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3AWK2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:28:01 -0500
Date: Wed, 23 Jan 2013 10:27:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add axi-clkgen driver
Message-ID: <20130123102755.GP23505@n2100.arm.linux.org.uk>
References: <1357755120-32735-1-git-send-email-lars@metafoo.de> <20130122175552.24671.27893@quantum> <50FFB4D8.5060801@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFB4D8.5060801@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:00:56AM +0100, Lars-Peter Clausen wrote:
> I think I read somewhere at some point that ioread{8,16,32} is preferred
> over write{b,h,l} in new code.

But... there's *no* point using ioread*() if you don't only use the
ioremap() interface.

ioread*() is there to allow PC IO and PC MMIO accesses through one
accessor depending on the cookie.  ioremap() only ever returns cookies
for MMIO accesses.
