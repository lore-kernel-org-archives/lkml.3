Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3B1AjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:39:12 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40470 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3B1AjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:39:09 -0500
Date: Wed, 27 Feb 2013 16:39:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
Message-ID: <20130228003906.GA3754@kroah.com>
References: <20130226235523.930663721@linuxfoundation.org>
 <20130226235526.246172467@linuxfoundation.org>
 <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:05:59AM +0000, Ben Hutchings wrote:
> On Tue, 2013-02-26 at 15:54 -0800, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Michael Chan <mchan@broadcom.com>
> > 
> > commit 85f024401bf80746ae08b7fd5809a9b16accf0b1 upstream.
> > 
> > It was mistakenly defined to be 24 instead of the next higher number 25.
> > 
> > Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Stephen Hurd <shurd@broadcom.com>
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  include/uapi/linux/serial_core.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/include/uapi/linux/serial_core.h
> > +++ b/include/uapi/linux/serial_core.h
> > @@ -50,7 +50,7 @@
> >  #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
> >  #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
> >  #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
> > -#define PORT_BRCM_TRUMANAGE	24
> > +#define PORT_BRCM_TRUMANAGE	25
> >  #define PORT_MAX_8250	25	/* max port ID */
> >  
> >  /*
> 
> Hang on, this is a uapi header - are these numbers actually used by
> userland or are they really internal to the 8250 drivers?

Interesting, I think they are internal to the 8250 drivers, as I don't
see how the number can be exported to userspace.  So they should
probably be moved into 8250.c somewhere.

But I could be wrong, this code is so old it's scary, hopefully no one
really is using this number in userspace.

Only one way to find out, care to make up a patch for me to apply and
queue up for 3.10?

thanks,

greg k-h
