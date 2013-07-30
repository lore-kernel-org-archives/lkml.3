Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3G3Nsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:48:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3G3Nsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:48:33 -0400
Date: Tue, 30 Jul 2013 06:49:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20130730134950.GA27962@kroah.com>
References: <20130727214911.GK1754@pengutronix.de>
 <1374962978-1860-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20130729200914.GA6146@kroah.com>
 <20130730075239.GN1754@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130730075239.GN1754@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:52:39AM +0200, Uwe Kleine-König wrote:
> [expanding Cc: to also include akpm and linux-mm]
> 
> Hello,
> 
> On Mon, Jul 29, 2013 at 01:09:14PM -0700, Greg Kroah-Hartman wrote:
> > On Sun, Jul 28, 2013 at 12:09:37AM +0200, Uwe Kleine-König wrote:
> > > This makes it possible to let gdb access mappings of the process that is
> > > being debugged.
> > > 
> > > uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> > > and differentiate to new stuff.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Changes since v1:
> > >     - only use generic_access_phys ifdef CONFIG_HAVE_IOREMAP_PROT
> > >     - fix all users of renamed struct
> > 
> > I still get a build error with this patch:
> > 
> >   MODPOST 384 modules
> > ERROR: "generic_access_phys" [drivers/uio/uio.ko] undefined!
> > 
> > So something isn't quite right.
> Ah, you built as a module and generic_access_phys isn't exported. The
> other users of generic_access_phys (arch/x86/pci/i386.c and
> drivers/char/mem.c) can only be builtin.
> 
> So the IMHO best option is to add an EXPORT_SYMBOL(generic_access_phys)
> to mm/memory.c.

EXPORT_SYMBOL_GPL() perhaps?

And why all of a sudden does the uio driver need this change?  It is
working just fine right now without it, right?

thanks,

greg k-h
