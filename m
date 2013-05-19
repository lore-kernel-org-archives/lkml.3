Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3ESIxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 04:53:39 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49164 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171Ab3ESIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 04:53:38 -0400
Date: Sun, 19 May 2013 11:53:29 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers: net: usb: rtl8150: bug fixing and cleanup
In-Reply-To: <20130518211012.GC26590@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1305191149310.4537@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305181905100.7518@fry.nucleusys.com> <20130518211012.GC26590@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463786495-1647968027-1368953615=:4537"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463786495-1647968027-1368953615=:4537
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Sat, 18 May 2013, Francois Romieu wrote:

> Petko Manolov <petkan@nucleusys.com> :
> [...]
> >  static int set_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> >  {
> > -	return usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> > -			       RTL8150_REQ_SET_REGS, RTL8150_REQT_WRITE,
> > -			       indx, 0, data, size, 500);
> > +	int res;
> > +
> > +	res = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> > +			      RTL8150_REQ_SET_REGS, RTL8150_REQT_WRITE,
> > +			      indx, 0, data, size, 500);
> > +	if (res < 0)
> > +		dev_dbg(&dev->udev->dev, "%s returned %d\n", __func__, res);
> > +	return res;
> 
> You may move it into a separate patch. It is completely unrelated to the
> ctrl_urb changes.

The change is so trivial i thought i can smuggle it unnoticed. :-)

> [...]
> > +static int async_set_registers(rtl8150_t *dev, u16 indx, u16 size, u16 reg)
> >  {
> 
> [...]
> > +	usb_fill_control_urb(async_urb, dev->udev,
> > +	                     usb_sndctrlpipe(dev->udev, 0), (void *) &req->dr,
> 
> Useless void * cast.

Wrong.  The compiler actually moans quite a lot:

/usr/src/git/rtl8150/rtl8150.c: In function ¡async_set_registers¢:
/usr/src/git/rtl8150/rtl8150.c:92:9: warning: passing argument 4 of ¡usb_fill_control_urb¢ from incompatible pointer type [enabled by default]
In file included from /usr/src/git/rtl8150/rtl8150.c:17:0:
include/linux/usb.h:1440:20: note: expected ¡unsigned char *¢ but argument is of type ¡struct usb_ctrlrequest *¢
---1463786495-1647968027-1368953615=:4537--
