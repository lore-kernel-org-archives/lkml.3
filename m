Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3APOzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:55:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47786 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3APOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:55:46 -0500
Date: Wed, 16 Jan 2013 14:55:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        sshtylyov@mvista.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, bjorn@mork.no,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 04/22] mfd: omap-usb-tll: Clean up clock handling
Message-ID: <20130116145530.GU23505@n2100.arm.linux.org.uk>
References: <1358347433-329-1-git-send-email-rogerq@ti.com> <1358347433-329-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358347433-329-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 04:43:35PM +0200, Roger Quadros wrote:
> +	spin_lock_irqsave(&tll->lock, flags);
> +
> +	for (i = 0; i < tll->nch; i++) {
> +		char clkname[] = "usb_tll_hs_usb_chx_clk";
> +		struct clk *fck;
> +
> +		snprintf(clkname, sizeof(clkname),
> +					"usb_tll_hs_usb_ch%d_clk", i);
> +		fck = clk_get(dev, clkname);

NAK.  Why are you doing this under a spinlock?

clk_get() takes a mutex.  You must not be in an atomic region (iow, you
must not be holding a spinlock, and you must not have IRQs disabled)
when you call clk_get().
