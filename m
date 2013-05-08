Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3EHUOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:14:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3EHUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:14:14 -0400
Date: Wed, 8 May 2013 13:14:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Wang YanQing <udknight@gmail.com>, airlied@redhat.com,
        linux-kernel@vger.kernel.org, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [PATCH 3/9] vt: delete unneeded functions
 register_con_driver|take_over_console
Message-ID: <20130508201412.GA17401@kroah.com>
References: <20130508181359.GD12344@udknight>
 <518AAE01.2010005@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518AAE01.2010005@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 03:56:49PM -0400, Peter Hurley wrote:
> On 05/08/2013 02:13 PM, Wang YanQing wrote:
> >Now there is no place use register_con_driver|take_over_console,
> >and we can achieve their function with do_register_con_driver|
> >do_take_over_console easily, so just delete them to reduce code duplication.
> >
> >Signed-off-by: Wang YanQing <udknight@gmail.com>
> >---
> >  drivers/tty/vt/vt.c     | 45 ---------------------------------------------
> >  include/linux/console.h |  2 --
> >  2 files changed, 47 deletions(-)
> >
> >diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> >index fbd447b..852d470 100644
> >--- a/drivers/tty/vt/vt.c
> >+++ b/drivers/tty/vt/vt.c
> >@@ -3576,26 +3576,6 @@ err:
> >  	return retval;
> >  }
> >
> >-/**
> >- * register_con_driver - register console driver to console layer
> >- * @csw: console driver
> >- * @first: the first console to take over, minimum value is 0
> >- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
> >- *
> >- * DESCRIPTION: This function registers a console driver which can later
> >- * bind to a range of consoles specified by @first and @last. It will
> >- * also initialize the console driver by calling con_startup().
> >- */
> >-int register_con_driver(const struct consw *csw, int first, int last)
> >-{
> >-	int retval;
> >-
> >-	console_lock();
> >-	retval = do_register_con_driver(csw, first, last);
> >-	console_unlock();
> >-	return retval;
> >-}
> >-EXPORT_SYMBOL(register_con_driver);
> 
> Maybe register_con_driver() should print a deprecated warning
> for a release or two before we remove it.

If there are no in-kernel users, why do we need to keep it around?

thanks,

greg k-h
