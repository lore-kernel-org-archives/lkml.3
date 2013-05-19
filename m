Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3ESIsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 04:48:22 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49161 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659Ab3ESIsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 04:48:21 -0400
Date: Sun, 19 May 2013 11:48:13 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers: net: usb: rtl8150: bug fixing and cleanup
In-Reply-To: <20130518210958.GB26590@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1305191146130.4537@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305181904110.7518@fry.nucleusys.com> <20130518210958.GB26590@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 May 2013, Francois Romieu wrote:

> Petko Manolov <petkan@nucleusys.com> :
> [...]
> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> > index 7d1897b..fd4bc2a 100644
> > --- a/drivers/net/usb/rtl8150.c
> > +++ b/drivers/net/usb/rtl8150.c
> [...]
> >  static void rx_fixup(unsigned long data)
> >  {
> >  	struct rtl8150 *dev = (struct rtl8150 *)data;
> >  	struct sk_buff *skb;
> >  	int status;
> >  
> > -	spin_lock_irq(&dev->rx_pool_lock);
> > -	fill_skb_pool(dev);
> > -	spin_unlock_irq(&dev->rx_pool_lock);
> >  	if (test_bit(RX_URB_FAIL, &dev->flags))
> >  		if (dev->rx_skb)
> >  			goto try_again;
> > -	spin_lock_irq(&dev->rx_pool_lock);
> > -	skb = pull_skb(dev);
> > -	spin_unlock_irq(&dev->rx_pool_lock);
> > +	skb = __netdev_alloc_skb_ip_align(dev->netdev, RTL8150_MTU, GFP_ATOMIC);
> 
> You can use plain netdev_alloc_skb_ip_align.

Yep, except for the call in rtl8150_open() (where GFP_KERNEL is more 
appropriate) i should have used the plain version.
