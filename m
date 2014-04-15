Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaDOWxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:53:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35736 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751733AbaDOWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:53:33 -0400
Date: Tue, 15 Apr 2014 23:52:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: mc13xxx-core: Initialize the lock prior to using
	it
Message-ID: <20140415225250.GB24070@n2100.arm.linux.org.uk>
References: <1397601790-27916-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397601790-27916-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 07:43:10PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> After request_threaded_irq() is called there is a chance that an interrupt
> may occur before the 'mc13xxx->lock' is initialized, which will trigger a kernel
> warning.

I'd suggest... "which will trigger a kernel oops" because that's what
you got - it killed the IRQ thread, which then caused a few other
problems along the way.

> In order to prevent that, move the initialization of 'mc13xxx->lock' prior to
> requesting the interrupts.
> 
> Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch looks good, and should fix the reported issue... so with the above
description fixed,

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
