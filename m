Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaGJUeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:34:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaGJUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:33:59 -0400
Date: Thu, 10 Jul 2014 13:38:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] staging: r8821ae: avoid leaking format string
Message-ID: <20140710203825.GA31985@kroah.com>
References: <20140710201611.GA31972@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710201611.GA31972@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 01:16:11PM -0700, Kees Cook wrote:
> This make sure a format string cannot leak into the work queue name nor
> the printk buffer.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is the third time this set of macros has entered the kernel:
> 
> drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
> drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
> drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
> 
> Can we extract these macros to some common place and keep them from returning?

I wish.  These are all from the same company.  Each new version of their
hardware consists of a whole dump of a wireless stack.  People are
working on addressing this issue, by writing "real" drivers for the
hardware, and working with the company to not keep doing this.  But odds
are, I'll get a new driver for the next chip from them that does the
same thing :(

thanks for the patch, I'll queue it up.

greg k-h
