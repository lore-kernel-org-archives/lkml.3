Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3CHUQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:16:05 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:48534 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3CHUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:16:03 -0500
Date: Fri, 8 Mar 2013 12:16:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        oskar.andero@sonymobile.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Subject: Re: [RFC PATCH 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev
 can be null
Message-ID: <20130308201639.GB14787@kroah.com>
References: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com>
 <1362747220-2204-2-git-send-email-oskar.andero@sonymobile.com>
 <513A426A.9060903@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A426A.9060903@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:56:26PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 08-03-2013 16:53, oskar.andero@sonymobile.com wrote:
> 
> >From: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> 
> >The udc_irq service runs the isr_tr_complete_handler which in turn
> >"nukes" the endpoints, including a call to rndis_response_complete,
> >if appropriate. If the rndis_msg_parser fails here, an error will
> >be printed using a dev_err call (through the ERROR() macro).
> 
> >However, if the usb cable was just disconnected the device (cdev)
> >might not be available and will be null. Since the dev_err macro will
> >dereference the cdev pointer we get a null pointer exception.
> 
> >Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> >Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> >Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> >---
> >  drivers/usb/gadget/f_rndis.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> >diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
> >index 71beeb8..41b5ebd 100644
> >--- a/drivers/usb/gadget/f_rndis.c
> >+++ b/drivers/usb/gadget/f_rndis.c
> >@@ -6,6 +6,7 @@
> >   * Copyright (C) 2008 Nokia Corporation
> >   * Copyright (C) 2009 Samsung Electronics
> >   *                    Author: Michal Nazarewicz (mina86@mina86.com)
> >+ * Copyright (C) 2013 Sony Mobile Communications AB.
> 
>    Your change seems too insignificant to add a copyright.

You are right, it legally is.  Truls, please consult your company's
lawyers if you have questions about this, you can not assert copyright
over a file for a 2 line change, that's not allowed at all in any
jurisdiction I know of.

Because of that, I can not accept this change, sorry.

greg k-h
