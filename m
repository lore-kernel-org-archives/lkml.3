Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3AOQHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:07:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39237 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3AOQHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:07:12 -0500
From: "B, Ravi" <ravibabu@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>, "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [RFC PATCH 0/7] usb: musb: add driver for control module
Thread-Topic: [RFC PATCH 0/7] usb: musb: add driver for control module
Thread-Index: AQHN8zGiQgWIUwHMKUadb+uNVk2+z5hKhdQg
Date: Tue, 15 Jan 2013 16:06:44 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EA5ACAB@DBDE01.ent.ti.com>
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
 <201301151341.08297.arnd@arndb.de> <50F56A1A.3040504@ti.com>
 <20130115150432.GB26272@arwen.pp.htv.fi>
In-Reply-To: <20130115150432.GB26272@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.81.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Tue, Jan 15, 2013 at 08:09:22PM +0530, kishon wrote:
> > Hi Arnd,
> > 
> > On Tuesday 15 January 2013 07:11 PM, Arnd Bergmann wrote:
> > >On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
> > >>Added a new driver for the usb part of control module. 
> This has an 
> > >>API to power on the USB2 phy and an API to write to the mailbox 
> > >>depending on whether MUSB has to act in host mode or in 
> device mode.
> > >>
> > >>Writing to control module registers for doing the above 
> task which 
> > >>was previously done in omap glue and in omap-usb2 phy is removed.
> > >>
> > >>Also added the dt data to get MUSB working in OMAP platforms.
> > >>This series has patches for both drivers and ARCH 
> folders, so If it 
> > >>has to be split I'll do it.
> > >>
> > >
> > >The series looks good to me, I just had a minor comment on 
> one patch.
> > >
> > >One a somewhat related topic, I wonder whether there are 
> any plans on 
> > >your side to change this driver to support multiple bus 
> glues to be 
> > >built for one kernel image. With a multiplatform kernel, 
> we may need 
> > >all of TUSB6010/OMAP2PLUS/DSPS/UX500 for instance.
> > 
> > We don't have plans as of now. I actually don't expect any 
> changes in 
> > the driver other than the Kconfig changes. Anyways the 
> probe of glue's 
> > other than the platform it's running won't get called. right Felipe?

If understand correctly the control module driver used to configure the respective usb phy of SoC to respective usb modes using the common set of control module APIs. What if, if control module interface (register defintions) varies b/w different revision or spin of same type of SoCs, if usbphy type is changed. In this case whether the single instance of control module driver is good enough to cater of all cpu types of same SoC series ? 
Whether cpu_is_xxx() can be used to differentiate b/w different cpu types in CM driver?

> 
> AFAICT there's nothing preventing those from being built 
> together as long as you don't use DMA (yeah, that's a touchy 
> subject still with MUSB).
> 
> If there are any build breaks, please report them so bus glue 
> owners can fix. I see that at least the davinci folks need to 
> work a bit
> 
> $ git grep -e "mach\/" drivers/usb/musb/ 
> drivers/usb/musb/da8xx.c:#include <mach/da8xx.h> 
> drivers/usb/musb/davinci.c:#include <mach/cputype.h> 
> drivers/usb/musb/davinci.c:#include <mach/hardware.h>
> 
> I'm adding Ravi B to the loop here for those.
> 
> --
> balbi
> 