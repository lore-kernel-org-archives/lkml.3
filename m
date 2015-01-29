Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbbA2OUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:20:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:64492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbbA2OUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:20:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="677997575"
Date: Thu, 29 Jan 2015 16:18:25 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] usb: add bus type for USB ULPI
Message-ID: <20150129141825.GB2570@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-2-git-send-email-heikki.krogerus@linux.intel.com>
 <20150129050237.GA9098@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150129050237.GA9098@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:02:37PM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Jan 23, 2015 at 05:12:51PM +0200, Heikki Krogerus wrote:
> > @@ -6,4 +6,5 @@ obj-$(CONFIG_USB_COMMON)	  += usb-common.o
> >  usb-common-y			  += common.o
> >  usb-common-$(CONFIG_USB_LED_TRIG) += led.o
> >  
> > -obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
> > +obj-$(CONFIG_USB_OTG_FSM)	+= usb-otg-fsm.o
> 
> a bit of unrelated change here.

OK

> > diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> > index cc0ced0..c0fc3b5 100644
> > --- a/drivers/usb/core/Kconfig
> > +++ b/drivers/usb/core/Kconfig
> > @@ -84,3 +84,11 @@ config USB_OTG_FSM
> >  	  Implements OTG Finite State Machine as specified in On-The-Go
> >  	  and Embedded Host Supplement to the USB Revision 2.0 Specification.
> >  
> > +config USB_ULPI_BUS
> > +	bool "USB ULPI PHY interface support"
> > +	depends on USB || USB_GADGET
> 
> depends on USB_SUPPORT ?

sure

> > +int ulpi_register_driver(struct ulpi_driver *drv);
> > +void ulpi_unregister_driver(struct ulpi_driver *drv);
> > +
> > +#define module_ulpi_driver(__ulpi_driver) \
> > +	module_driver(__ulpi_driver, ulpi_register_driver, \
> > +		      ulpi_unregister_driver)
> > +
> > +int ulpi_read(struct ulpi *ulpi, u8 addr);
> > +int ulpi_write(struct ulpi *ulpi, u8 addr, u8 val);
> 
> no stubs ?

Is there really need for them? Well, I'll add them.


Thanks,

-- 
heikki
