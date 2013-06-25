Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3FYRio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:38:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3FYRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:38:42 -0400
Date: Tue, 25 Jun 2013 10:38:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, shigekatsu.tateno@atmel.com,
        devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
Message-ID: <20130625173840.GA8930@kroah.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
 <20130625170205.GA21328@kroah.com>
 <1372181390.1245.68.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372181390.1245.68.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:29:50AM -0700, Joe Perches wrote:
> On Tue, 2013-06-25 at 10:02 -0700, Greg KH wrote:
> > On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
> > > convert all debug messages from printk to dev_dbg() & add kernel config to
> > > enable/disable these messages during compilation.
> 
> > No, just use the built-in dynamic debug code in the kernel, no need to
> > provide any new macros or functions or most importantly, no new Kconfig
> > options.
> 
> I think the Kconfig option is pretty poor too but a
> long needed extension to dev_dbg is to enable classes
> of messages by level or mask.
> 
> There are many existing macros like
> 
> #define module_dbg(level, fmt, ...)
> do {
> 	if (level >= some_module_var)
> 		debug_something(...);
> } while (0)
> 
> and
> 
> #define module_dbg(mask, fmt, ...)
> do {
> 	if (mask & some_module_var)
> 		debug_something(...)
> } while (0)
> 
> It'd be nice to consolidate those in dev_dbg

I'd almost recommend that all of them just be removed, because most of
them were only used for debugging the code the first time it was
developed, right?  Only for very limited usages would this type of thing
be needed.

thanks,

greg k-h
