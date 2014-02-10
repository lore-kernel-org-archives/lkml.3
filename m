Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaBJJ7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:59:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:41234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJJ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:58:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="478909612"
Date: Mon, 10 Feb 2014 12:05:44 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpiolib: add gpiochip_get_desc() driver function
Message-ID: <20140210100544.GU18029@intel.com>
References: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 05:43:54PM +0900, Alexandre Courbot wrote:
> Some drivers dealing with a gpio_chip might need to act on its
> descriptors directly; one example is pinctrl drivers that need to lock a
> GPIO for being used as IRQ using gpiod_lock_as_irq().
> 
> This patch exports a gpiochip_get_desc() function that returns the
> GPIO descriptor at the requested index. It also sweeps the
> gpio_to_chip() function out of the consumer interface since any holder
> of a gpio_chip reference can manipulate its GPIOs way beyond what a
> consumer should be allowed to do.
> 
> As a result, gpio_chip is not visible anymore to simple GPIO consumers.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Jean-Jacques, I think you will want to use this function for locking GPIOs
> in the AT91 pinctrl driver. Mika, we talked about this a while ago already,
> but here it is finally. Next patch uses it in the GPIO ACPI driver.

This seems to be useful for ACPI GPIO operation region implementation as
well.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
