Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaJILAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:00:08 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:63911 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaJIK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:59:58 -0400
Date: Thu, 9 Oct 2014 11:59:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Muthu Mani <muth@cypress.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, gregkh@linuxfoundation.org,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141009105950.GP20647@lee--X1>
References: <1412606587-3323-1-git-send-email-muth@cypress.com>
 <20141009074029.GL20647@lee--X1>
 <20141009081520.GJ1990@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141009081520.GJ1990@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2014, Johan Hovold wrote:

> On Thu, Oct 09, 2014 at 08:40:29AM +0100, Lee Jones wrote:
> > On Mon, 06 Oct 2014, Muthu Mani wrote:
> 
> > > +static int update_ep_details(struct usb_interface *interface,
> > > +				struct cyusbs23x *cyusbs)
> > > +{
> > > +	struct usb_host_interface *iface_desc;
> > > +	struct usb_endpoint_descriptor *ep;
> > > +	int i;
> > > +
> > > +	iface_desc = interface->cur_altsetting;
> > > +
> > > +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> > > +
> > > +		ep = &iface_desc->endpoint[i].desc;
> > > +
> > > +		if (!cyusbs->bulk_in_ep_num && usb_endpoint_is_bulk_in(ep))
> > > +			cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
> > > +		if (!cyusbs->bulk_out_ep_num && usb_endpoint_is_bulk_out(ep))
> > > +			cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
> > > +		if (!cyusbs->intr_in_ep_num && usb_endpoint_is_int_in(ep))
> > > +			cyusbs->intr_in_ep_num = ep->bEndpointAddress;
> > > +	}
> > 
> > All of the USB specific code in this driver will require a USB Ack.
> 
> I'll review it once the incomplete gpio-driver issue has been resolved.

Okay, great.

> > > +	dev_dbg(&interface->dev, "%s intr_in=%d, bulk_in=%d, bulk_out=%d\n",
> > > +		__func__, cyusbs->intr_in_ep_num ,
> > > +		cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
> > > +
> > > +	if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
> > > +		!cyusbs->intr_in_ep_num)
> > > +		return -ENODEV;
> > > +
> > > +	return 0;
> > > +}
> 
> [...]
> 
> > > diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
> 
> > > +/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > > +enum cy_scb_modes {
> > > +	CY_USBS_SCB_DISABLED = 0,
> > > +	CY_USBS_SCB_UART = 1,
> > > +	CY_USBS_SCB_SPI = 2,
> > > +	CY_USBS_SCB_I2C = 3
> > 
> > No need to number these.
> 
> As it's not an arbitrary enumeration, I think they should be initialised
> explicitly.

No need.  You are protected by the C Standard:

6.7.2.2 Enumeration specifiers

"If the first enumerator has no =, the value of its enumeration
constant is 0. Each subsequent enumerator with no = defines its
enumeration constant as the value of the constant expression obtained
by adding 1 to the value of the previous enumeration constant."

There's nothing arbitrary about that.

> They could be defined in the mfd driver though, as they only
> appear to be needed during probe.


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
