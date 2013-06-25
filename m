Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3FYR5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:57:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3FYR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:57:18 -0400
Date: Tue, 25 Jun 2013 10:57:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, shigekatsu.tateno@atmel.com
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
Message-ID: <20130625175717.GA26914@kroah.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
 <20130625170205.GA21328@kroah.com>
 <51C9D818.1090702@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C9D818.1090702@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 06:49:12PM +0100, Rupesh Gujare wrote:
> On 25/06/13 18:02, Greg KH wrote:
> >On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
> >>convert all debug messages from printk to dev_dbg() & add kernel config to
> >>enable/disable these messages during compilation.
> >No, just use the built-in dynamic debug code in the kernel, no need to
> >provide any new macros or functions or most importantly, no new Kconfig
> >options.
> >
> 
> New macro (oz_trace) is being used as pointer to "struct device *"
> is not available in all functions for dev_dbg() function.
> Please let me know if there is better way to handle this, I will be
> happy to rework on this.

Then use pr_debug() for the places you don't have a struct device *,
everywhere else should use dev_dbg().

> As well new Kconfig option was added to pass CFLAGS to compiler, so
> that dev_dbg will get compiled on system where DYNAMIC_DEBUG is not
> defined.

No, just rely on the overall config option, do you really think the
kernel should have an individual Kconfig debug option for every
individual driver?  We have been removing these for years, don't move
backwards in this area please.

> I was assuming that it is a standard practice, as I can find similar
> Kconfig option for other drivers. Or am I wrong in my understanding
> ?

Those options for those drivers should be removed, they were added
before we had the dynamic debug option.  New drivers shouldn't have this
at all.

> Main idea here is to replace printk with dev_dbg(), which gives us
> option to enable individual log during runtime if DYNAMIC_DEBUG is
> enabled & provide mechanism to compile this when DYNAMIC_DEBUG is
> not enabled.
> 
> Again many of these logs will be removed in future, as currently
> there are too many logs which are not required, hence idea is to
> only change macro & then remove remaining logs in future.

No, remove the unneeded calls now, why wait?

thanks,

greg k-h
