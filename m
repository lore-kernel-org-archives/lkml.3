Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3CRPRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:17:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59548 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3CRPRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:17:42 -0400
Date: Mon, 18 Mar 2013 08:18:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: oskar.andero@sonymobile.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "Bengtsson, Truls" <Truls.Bengtsson@sonymobile.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>
Subject: Re: [RFC PATCH 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev
 can be null
Message-ID: <20130318151857.GB3249@kroah.com>
References: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com>
 <1362747220-2204-2-git-send-email-oskar.andero@sonymobile.com>
 <513A426A.9060903@cogentembedded.com>
 <20130308201639.GB14787@kroah.com>
 <20130318082807.GA22001@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318082807.GA22001@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:28:07AM +0100, oskar.andero@sonymobile.com wrote:
> On 21:16 Fri 08 Mar     , Greg Kroah-Hartman wrote:
> > On Fri, Mar 08, 2013 at 11:56:26PM +0400, Sergei Shtylyov wrote:
> > > Hello.
> > > 
> > > On 08-03-2013 16:53, oskar.andero@sonymobile.com wrote:
> > > 
> > > >From: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> > > 
> > > >The udc_irq service runs the isr_tr_complete_handler which in turn
> > > >"nukes" the endpoints, including a call to rndis_response_complete,
> > > >if appropriate. If the rndis_msg_parser fails here, an error will
> > > >be printed using a dev_err call (through the ERROR() macro).
> > > 
> > > >However, if the usb cable was just disconnected the device (cdev)
> > > >might not be available and will be null. Since the dev_err macro will
> > > >dereference the cdev pointer we get a null pointer exception.
> > > 
> > > >Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > > >Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> > > >Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> > > >---
> > > >  drivers/usb/gadget/f_rndis.c |    4 ++--
> > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > >diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
> > > >index 71beeb8..41b5ebd 100644
> > > >--- a/drivers/usb/gadget/f_rndis.c
> > > >+++ b/drivers/usb/gadget/f_rndis.c
> > > >@@ -6,6 +6,7 @@
> > > >   * Copyright (C) 2008 Nokia Corporation
> > > >   * Copyright (C) 2009 Samsung Electronics
> > > >   *                    Author: Michal Nazarewicz (mina86@mina86.com)
> > > >+ * Copyright (C) 2013 Sony Mobile Communications AB.
> > > 
> > >    Your change seems too insignificant to add a copyright.
> > 
> > You are right, it legally is.  Truls, please consult your company's
> > lawyers if you have questions about this, you can not assert copyright
> > over a file for a 2 line change, that's not allowed at all in any
> > jurisdiction I know of.
> > 
> > Because of that, I can not accept this change, sorry.
> 
> Thanks for your input guys and I totally agree with you! However, I was
> expecting more comments on the cover-letter, or should I take it that this
> solution is acceptable?

I don't remember, please resend the series after fixing the issues
pointed out.

greg k-h
