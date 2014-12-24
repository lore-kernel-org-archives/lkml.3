Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaLXWpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:45:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:45366 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaLXWpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,639,1413270000"; 
   d="scan'208";a="628850864"
Date: Wed, 24 Dec 2014 14:46:31 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
Message-ID: <20141224224631.GB3175@psi-dev26.jf.intel.com>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141223012517.GC11551@shlinux2>
 <20141223194022.GA13792@psi-dev26.jf.intel.com>
 <20141224030835.GA31424@shlinux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141224030835.GA31424@shlinux2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 11:08:52AM +0800, Peter Chen wrote:
> On Tue, Dec 23, 2014 at 11:40:23AM -0800, David Cohen wrote:
> > Hi Peter,
> > 
> > Thanks for the review.
> > 
> > On Tue, Dec 23, 2014 at 09:25:18AM +0800, Peter Chen wrote:
> > > On Mon, Dec 22, 2014 at 02:43:37PM -0800, David Cohen wrote:
> > > > Some platforms have an USB OTG port fully (or partially) controlled by
> > > > GPIOs:
> > > > 
> > > > (1) USB ID is connected directly to GPIO
> > > > 
> > > > Optionally:
> > > > (2) VBUS is enabled by a GPIO (when ID is grounded)
> > > > (3) Platform has 2 USB controllers connected to same port: one for
> > > >     device and one for host role. D+/- are switched between phys
> > > >     by GPIO.
> > > 
> > > Would you explain how it works? Choosing controller runtime?
> > 
> > Both controllers are (indirectly) connected to the same micro B port.
> > The D+/- goes from the port to a switch operated by a GPIO. From the
> > switch, D+/- may go to Host controller's phy or Device controller's phy.
> > Depends on the GPIO level.
> > 
> 
> Get it, why the design like that? If your controller supports both
> roles, the software can do role switch by ID pin (through gpio in your
> case).

It's really 2 controllers: 1 for each role. And the ID pin from port is
connected to GPIO only.

> 
> > > 
> > > > 
> > > > As per initial version, this driver has the duty to control whether
> > > > USB-Host cable is plugged in or not:
> > > 
> > > You mean Micro-AB cable, right?
> > 
> > > > +
> > > > +	vup->gpio_usb_mux = devm_gpiod_get_index(dev, "usb mux",
> > > > +						 VUPORT_GPIO_USB_MUX);
> > > > +	if (IS_ERR(vup->gpio_usb_mux))
> > > > +		dev_info(dev, "cannot request USB USB MUX, skipping it.\n");
> > > 
> > > Using dev_err
> > 
> > That's not really an error, although the IS_ERR() suggests otherwise.
> > The driver works well if a board doesn't need this mux (I'll add a
> > comment to state that clear). IMHO either keep dev_info or use dev_dgb
> > instead?
> > 
> 
> If that, dev_dbg may be suitable.

Ack.

Br, David

> 
> 
> -- 
> 
> Best Regards,
> Peter Chen
