Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaDWIt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:49:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42139 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaDWIt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:49:26 -0400
Message-ID: <1398242909.4724.204.camel@iivanov-dev>
Subject: Re: [PATCH v6 01/19] usb: phy: msm: Make driver selectable on
 ARCH_QCOM
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 23 Apr 2014 11:48:29 +0300
In-Reply-To: <20140422152425.GL5524@saruman.home>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
	 <20140422145701.GI5524@saruman.home>
	 <1398179795.4724.170.camel@iivanov-dev>
	 <20140422152425.GL5524@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 10:24 -0500, Felipe Balbi wrote:
> On Tue, Apr 22, 2014 at 06:16:35PM +0300, Ivan T. Ivanov wrote:
> > 
> > Hi, 
> > 
> > On Tue, 2014-04-22 at 09:57 -0500, Felipe Balbi wrote:
> > > On Tue, Apr 22, 2014 at 12:20:20PM +0300, Ivan T. Ivanov wrote:
> > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > 
> > > > Controller could be found on APQ and MSM platforms,
> > > > make configuration description more generic.
> > > > 
> > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > ---
> > > >  drivers/usb/phy/Kconfig | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > > > index 416e0c8..0c668a3 100644
> > > > --- a/drivers/usb/phy/Kconfig
> > > > +++ b/drivers/usb/phy/Kconfig
> > > > @@ -171,11 +171,11 @@ config USB_ISP1301
> > > >  	  module will be called phy-isp1301.
> > > > 
> > > >  config USB_MSM_OTG
> > > > -	tristate "OTG support for Qualcomm on-chip USB controller"
> > > > -	depends on (USB || USB_GADGET) && ARCH_MSM
> > > > +	tristate "Qualcomm on-chip USB OTG controller support"
> > > > +	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
> > > 
> > > I would actually drop USB || USB_GADGET dependency here just make it
> > > easier to enable the driver on Kconfig, other you have to enable
> > > USB_SUPPORT, then enable USB, go back one menu level, go down to PHY
> > > menu, and choose this driver.
> > > 
> > 
> > Because phy directory already depends on USB_SUPPORT?
> 
> right

Build fails if USB and USB_GADGET are not selected. 
of_usb_get_dr_mode is part of USB_COMMON. 

...

if USB_SUPPORT

config USB_COMMON
	tristate
	default y
	depends on USB || USB_GADGET

...

of_usb_get_dr_mode() is no part of this patch, but should I remove
dependency here and add it several patches later?

Regards,
Ivan


