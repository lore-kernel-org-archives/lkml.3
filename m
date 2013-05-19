Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3ESTBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 15:01:34 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:43096 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3ESTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 15:01:32 -0400
Date: Sun, 19 May 2013 21:01:27 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Petko Manolov <petkan@nucleusys.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers: net: usb: rtl8150: bug fixing and cleanup
Message-ID: <20130519190127.GB4019@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1305181905100.7518@fry.nucleusys.com>
 <20130518211012.GC26590@electric-eye.fr.zoreil.com>
 <alpine.DEB.2.02.1305191149310.4537@fry.nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305191149310.4537@fry.nucleusys.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petko Manolov <petkan@nucleusys.com> :
[...]
> > > +	usb_fill_control_urb(async_urb, dev->udev,
> > > +	                     usb_sndctrlpipe(dev->udev, 0), (void *) &req->dr,
> > 
> > Useless void * cast.
> 
> Wrong.  The compiler actually moans quite a lot:
> 
> /usr/src/git/rtl8150/rtl8150.c: In function ?async_set_registers?:
> /usr/src/git/rtl8150/rtl8150.c:92:9: warning: passing argument 4 of ?usb_fill_control_urb? from incompatible pointer type [enabled by default]
> In file included from /usr/src/git/rtl8150/rtl8150.c:17:0:
> include/linux/usb.h:1440:20: note: expected ?unsigned char *? but argument is of type ?struct usb_ctrlrequest *?

Sorry, I confused it with transfer_buffer. Some drivers go through unsigned
char *, some widen it to void *.

-- 
Ueimor
