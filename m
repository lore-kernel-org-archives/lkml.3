Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbAYWF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:05:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbAYWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:05:23 -0500
Date: Sun, 25 Jan 2015 14:05:18 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Holmberg <hans.holmberg@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.10 25/50] gpiolib: of: Correct error handling in
 of_get_named_gpiod_flags
Message-ID: <20150125220518.GA29924@kroah.com>
References: <20150125180702.521559311@linuxfoundation.org>
 <20150125180703.970882239@linuxfoundation.org>
 <20150125213149.GA3313@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125213149.GA3313@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 01:31:49PM -0800, Guenter Roeck wrote:
> On Sun, Jan 25, 2015 at 10:07:15AM -0800, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hans Holmberg <hans.holmberg@intel.com>
> > 
> > commit 7b8792bbdffdff3abda704f89c6a45ea97afdc62 upstream.
> > 
> > of_get_named_gpiod_flags fails with -EPROBE_DEFER in cases
> > where the gpio chip is available and the GPIO translation fails.
> > 
> > This causes drivers to be re-probed erroneusly, and hides the
> > real problem(i.e. the GPIO number being out of range).
> > 
> > Signed-off-by: Hans Holmberg <hans.holmberg@intel.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> 
> This patch is causing several build failures.
> 
> Error log:
> drivers/gpio/gpiolib-of.c: In function 'of_gpiochip_find_and_xlate':
> drivers/gpio/gpiolib-of.c:50:3: error: implicit declaration of function 'ERR_PTR'
> 
> since "#include <linux/err.h>" is missing in drivers/gpio/gpiolib-of.c
> in the 3.10 kernel.

Thanks for letting me know, I've pushed out a fix for this in the quilt
tree of patches.

greg k-h
