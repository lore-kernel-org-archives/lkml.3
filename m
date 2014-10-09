Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaJIISS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:18:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46536 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJIISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:18:10 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 9 Oct 2014 10:15:20 +0200
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Muthu Mani <muth@cypress.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, gregkh@linuxfoundation.org,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajaram Regupathy <rera@cypress.com>, Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141009081520.GJ1990@localhost>
References: <1412606587-3323-1-git-send-email-muth@cypress.com>
 <20141009074029.GL20647@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009074029.GL20647@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 08:40:29AM +0100, Lee Jones wrote:
> On Mon, 06 Oct 2014, Muthu Mani wrote:

> > +static int update_ep_details(struct usb_interface *interface,
> > +				struct cyusbs23x *cyusbs)
> > +{
> > +	struct usb_host_interface *iface_desc;
> > +	struct usb_endpoint_descriptor *ep;
> > +	int i;
> > +
> > +	iface_desc = interface->cur_altsetting;
> > +
> > +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> > +
> > +		ep = &iface_desc->endpoint[i].desc;
> > +
> > +		if (!cyusbs->bulk_in_ep_num && usb_endpoint_is_bulk_in(ep))
> > +			cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
> > +		if (!cyusbs->bulk_out_ep_num && usb_endpoint_is_bulk_out(ep))
> > +			cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
> > +		if (!cyusbs->intr_in_ep_num && usb_endpoint_is_int_in(ep))
> > +			cyusbs->intr_in_ep_num = ep->bEndpointAddress;
> > +	}
> 
> All of the USB specific code in this driver will require a USB Ack.

I'll review it once the incomplete gpio-driver issue has been resolved.

> > +	dev_dbg(&interface->dev, "%s intr_in=%d, bulk_in=%d, bulk_out=%d\n",
> > +		__func__, cyusbs->intr_in_ep_num ,
> > +		cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
> > +
> > +	if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
> > +		!cyusbs->intr_in_ep_num)
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}

[...]

> > diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h

> > +/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > +enum cy_scb_modes {
> > +	CY_USBS_SCB_DISABLED = 0,
> > +	CY_USBS_SCB_UART = 1,
> > +	CY_USBS_SCB_SPI = 2,
> > +	CY_USBS_SCB_I2C = 3
> 
> No need to number these.

As it's not an arbitrary enumeration, I think they should be initialised
explicitly. They could be defined in the mfd driver though, as they only
appear to be needed during probe.

Johan
