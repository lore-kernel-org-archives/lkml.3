Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3FZIhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:37:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58936 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FZIho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:37:44 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Thread-Topic: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Thread-Index: AQHOXG1wggKnPGACD0+RUBnAlcCywJlHTrQAgACIfJA=
Date: Wed, 26 Jun 2013 08:37:39 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EB18D85@DBDE04.ent.ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-3-git-send-email-ravibabu@ti.com>
 <20130626082620.GN12640@arwen.pp.htv.fi>
In-Reply-To: <20130626082620.GN12640@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe

> 
> On Wed, May 29, 2013 at 06:37:03PM +0530, Ravi Babu wrote:
> > Adding babble_recovery operation as part of musb->ops, used to recover
> > from babble condition during babble interrupt.
> >
> > Signed-off-by: Ravi Babu <ravibabu@ti.com>
> > ---
> >  drivers/usb/musb/musb_core.c |    6 ++++++
> >  drivers/usb/musb/musb_core.h |    7 +++++++
> >  2 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/usb/musb/musb_core.c
> > b/drivers/usb/musb/musb_core.c index ab6fa39..411c29d 100644
> > --- a/drivers/usb/musb/musb_core.c
> > +++ b/drivers/usb/musb/musb_core.c
> > @@ -857,6 +857,12 @@ b_host:
> >  		}
> >  	}
> >
> > +	/* handle babble condition */
> > +	if (int_usb & MUSB_INTR_BABBLE) {
> > +		pr_info("babble: restarting the musb controller..");
> > +		musb_babble_recovery(musb);
> > +	}
> > +
> >  #if 0
> >  /* REVISIT ... this would be for multiplexing periodic endpoints, or
> >   * supporting transfer phasing to prevent exceeding ISO bandwidth
> > diff --git a/drivers/usb/musb/musb_core.h
> > b/drivers/usb/musb/musb_core.h index f96e899..bf37dc9 100644
> > --- a/drivers/usb/musb/musb_core.h
> > +++ b/drivers/usb/musb/musb_core.h
> > @@ -213,6 +213,8 @@ struct musb_platform_ops {
> >  	int	(*adjust_channel_params)(struct dma_channel *channel,
> >  				u16 packet_sz, u8 *mode,
> >  				dma_addr_t *dma_addr, u32 *len);
> > +
> > +	void	(*babble_recovery)(struct musb *musb);
> 
> I don't get why can't 'babble_recovery' be generic. Why do we need each glue
> layer to implement it ?
> 

Babble is generic, but recovery mechanism is nothing but "reset of usbss" which is SoC dependent and followed by generic restart of the musb controller. 
That is why musb_restart() API is exported used by all glue in babble recovery.

--
Ravi B
