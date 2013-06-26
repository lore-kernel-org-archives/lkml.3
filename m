Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3FZJJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:09:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40483 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3FZJI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:08:59 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Thread-Topic: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Thread-Index: AQHOXG1wggKnPGACD0+RUBnAlcCywJlHTrQAgACIfJD//38gAIAAiAmQ
Date: Wed, 26 Jun 2013 09:08:54 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EB18E34@DBDE04.ent.ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-3-git-send-email-ravibabu@ti.com>
 <20130626082620.GN12640@arwen.pp.htv.fi>
 <6C6B28D4DC342643927BEAFCE8707BF63EB18D85@DBDE04.ent.ti.com>
 <20130626085334.GP12640@arwen.pp.htv.fi>
In-Reply-To: <20130626085334.GP12640@arwen.pp.htv.fi>
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

Hi Felipe

> > > > @@ -213,6 +213,8 @@ struct musb_platform_ops {
> > > >  	int	(*adjust_channel_params)(struct dma_channel *channel,
> > > >  				u16 packet_sz, u8 *mode,
> > > >  				dma_addr_t *dma_addr, u32 *len);
> > > > +
> > > > +	void	(*babble_recovery)(struct musb *musb);
> > >
> > > I don't get why can't 'babble_recovery' be generic. Why do we need
> > > each glue layer to implement it ?
> > >
> >
> > Babble is generic, but recovery mechanism is nothing but "reset of
> > usbss" which is SoC dependent and followed by generic restart of the
> > musb controller.
> 
> and that's what I don't get. Why do you need to reset usbss ?

On babble condition, the session bit is removed by mentor, hence to make musb work
1) setting the session alone will not help.
2) restart the usbss and setting session also not helped.
3) musb works only after usbss reset followed by epfifo table init and re-enable all interrupts, then set the session. 

The mentor IP guys (synopsis) confirmed that during babble condition, controller is stopped. Only recover is to restart completely, usbss reset,  reinit epfifo table, & set the session. 

> 
> --
> balbi
