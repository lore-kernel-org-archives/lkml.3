Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3EIPPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:15:11 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:43148 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EIPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:15:09 -0400
Date: Thu, 9 May 2013 08:15:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Wang YanQing <udknight@gmail.com>, airlied@redhat.com,
        linux-kernel@vger.kernel.org, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [PATCH 3/9] vt: delete unneeded functions
 register_con_driver|take_over_console
Message-ID: <20130509151518.GC4120@kroah.com>
References: <20130508181359.GD12344@udknight>
 <518AAE01.2010005@hurleysoftware.com>
 <20130508201412.GA17401@kroah.com>
 <518AB77A.6090201@hurleysoftware.com>
 <20130508204500.GA16930@kroah.com>
 <518B8906.2040407@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518B8906.2040407@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 07:31:18AM -0400, Peter Hurley wrote:
> On 05/08/2013 04:45 PM, Greg KH wrote:
> >On Wed, May 08, 2013 at 04:37:14PM -0400, Peter Hurley wrote:
> >>On 05/08/2013 04:14 PM, Greg KH wrote:
> >>>On Wed, May 08, 2013 at 03:56:49PM -0400, Peter Hurley wrote:
> >>>>On 05/08/2013 02:13 PM, Wang YanQing wrote:
> >>>>>Now there is no place use register_con_driver|take_over_console,
> >>>>>and we can achieve their function with do_register_con_driver|
> >>>>>do_take_over_console easily, so just delete them to reduce code duplication.
> >>>>>
> >>>>>Signed-off-by: Wang YanQing <udknight@gmail.com>
> >>>>>---
> >>>>>  drivers/tty/vt/vt.c     | 45 ---------------------------------------------
> >>>>>  include/linux/console.h |  2 --
> >>>>>  2 files changed, 47 deletions(-)
> >>>>>
> >>>>>diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> >>>>>index fbd447b..852d470 100644
> >>>>>--- a/drivers/tty/vt/vt.c
> >>>>>+++ b/drivers/tty/vt/vt.c
> >>>>>@@ -3576,26 +3576,6 @@ err:
> >>>>>  	return retval;
> >>>>>  }
> >>>>>
> >>>>>-/**
> >>>>>- * register_con_driver - register console driver to console layer
> >>>>>- * @csw: console driver
> >>>>>- * @first: the first console to take over, minimum value is 0
> >>>>>- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
> >>>>>- *
> >>>>>- * DESCRIPTION: This function registers a console driver which can later
> >>>>>- * bind to a range of consoles specified by @first and @last. It will
> >>>>>- * also initialize the console driver by calling con_startup().
> >>>>>- */
> >>>>>-int register_con_driver(const struct consw *csw, int first, int last)
> >>>>>-{
> >>>>>-	int retval;
> >>>>>-
> >>>>>-	console_lock();
> >>>>>-	retval = do_register_con_driver(csw, first, last);
> >>>>>-	console_unlock();
> >>>>>-	return retval;
> >>>>>-}
> >>>>>-EXPORT_SYMBOL(register_con_driver);
> >>>>
> >>>>Maybe register_con_driver() should print a deprecated warning
> >>>>for a release or two before we remove it.
> >>>
> >>>If there are no in-kernel users, why do we need to keep it around?
> >>
> >>Well, it's not my position that we *need* to keep previously exported
> >>symbols around, but I do think a release or two is enough of a
> >>heads-up for out-of-tree drivers to transition.
> >
> >I don't care about out-of-tree drivers, as we have no insight into what
> >they do, but they can see everything we can do, it's up to them to keep
> >up with us.
> >
> >Or even better yet, get merged into the tree, and then these types of
> >things aren't even an issue.
> 
> So now that no in-tree driver declares TTY_HW_COOK_IN/OUT, you're ok
> with patches for their removal?

Sure, send them on.

thanks,

greg k-h
