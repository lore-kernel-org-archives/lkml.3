Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3FATJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:09:51 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38822 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3FATJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:09:44 -0400
Date: Sat, 1 Jun 2013 21:09:26 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for
 dma_addr_t
Message-ID: <20130601190926.GA5541@debian>
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
 <1370111350.2098.1.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370111350.2098.1.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see, will send a second version.

Thank's

Emil


On Sat, Jun 01, 2013 at 11:29:10AM -0700, Joe Perches wrote:
> On Sat, 2013-06-01 at 20:02 +0200, Emil Goode wrote:
> > This patch makes use of the new format specifier %pa that was introduced
> > by the following commit.
> > 
> > 7d7992108d02aa92ad4c77e5d9ce14088c942e75
> > ("lib/vsprintf.c: add %pa format specifier for phys_addr_t types")
> []
> > diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> []
> > @@ -1756,12 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
> []
> > -			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
> > +			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%pa len %d/%d\n",
> 
> This would emit 0x0x<addr>
> 
> When you use %pa, don't add 0x
> 
> 
