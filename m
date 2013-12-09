Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678Ab3LIMdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:33:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:55498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab3LIMdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:33:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="421632673"
Date: Mon, 9 Dec 2013 14:40:18 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: return -ENOENT when no GPIO mapping exists
Message-ID: <20131209124018.GD2281@intel.com>
References: <1386295616-14192-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386295616-14192-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:06:56AM +0900, Alexandre Courbot wrote:
> Some devices drivers make use of optional GPIO parameters. For such
> drivers, it is important to discriminate between the case where no
> GPIO mapping has been defined for the function they are requesting, and
> the case where a mapping exists but an error occured while resolving it
> or when acquiring the GPIO.
> 
> This patch changes the family of gpiod_get() functions such that they
> will return -ENOENT if and only if no GPIO mapping is defined for the
> requested function. Other error codes are used when an actual error
> occured during the GPIO resolution.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> I think this change should be merged early as not having it may prevent
> some users to switch to gpiod. I stumbled upon this issue while
> considering porting a simple driver (pwm_bl) that has an optional GPIO
> parameter.
> 
> Mika, Andy: if Linus agrees with this change, could you take care of
> having -ENOENT returned as well for the ACPI and SFI GPIOs lookup?

Sure. I have a patch for this already so once this gets merged, I'll send
out the ACPI version.
