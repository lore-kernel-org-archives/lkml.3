Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3HTVyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:54:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HTVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:54:12 -0400
Date: Tue, 20 Aug 2013 22:52:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, robherring2@gmail.com, grant.likely@linaro.org,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 4/4] clkdev: Fix race condition in clock lookup from
	device tree
Message-ID: <20130820215221.GH17845@n2100.arm.linux.org.uk>
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com> <1377020063-30213-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377020063-30213-5-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 07:34:23PM +0200, Sylwester Nawrocki wrote:
> There is currently a race condition in the device tree part of clk_get()
> function, since the pointer returned from of_clk_get_by_name() may become
> invalid before __clk_get() call. I.e. due to the clock provider driver
> remove() callback being called in between of_clk_get_by_name() and
> __clk_get().
> 
> Fix this by doing both the look up and __clk_get() operations with the
> clock providers list mutex held. This ensures that the clock pointer
> returned from __of_clk_get_from_provider() call and passed to __clk_get()
> is valid, as long as the clock supplier module first removes its clock
> provider instance and then does clk_unregister() on the corresponding
> clocks.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Mike Turquette <mturquette@linaro.org>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
