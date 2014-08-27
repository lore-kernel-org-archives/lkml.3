Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaH0E6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:58:04 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58032 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaH0E6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:58:01 -0400
Date: Wed, 27 Aug 2014 10:27:47 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fan.c: printk replacement
Message-ID: <20140827045747.GA3309@sudip-PC>
References: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com>
 <8052272.VnRivAuOcQ@vostro.rjw.lan>
 <1409086742.20683.75.camel@joe-AO725>
 <4713016.Cq5xvW8zIj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713016.Cq5xvW8zIj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:22:12PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 26, 2014 01:59:02 PM Joe Perches wrote:
> > On Tue, 2014-08-26 at 23:02 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, August 26, 2014 09:00:39 PM Sudip Mukherjee wrote:
> > > > On Tue, Aug 26, 2014 at 12:45:20AM +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, August 22, 2014 05:33:21 PM Sudip Mukherjee wrote:
> > > > > > printk replaced with corresponding dev_err and dev_info
> > > > > > fixed one broken user-visible string
> > > > > > multiine comment edited for correct commenting style
> > > > > > asm/uaccess.h replaced with linux/uaccess.h
> > > > > > 
> > > > > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > > > > ---
> > > > > >  drivers/acpi/fan.c | 18 +++++++++---------
> > > > > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > > > > > index 8acf53e..7900d55 100644
> > > > > > --- a/drivers/acpi/fan.c
> > > > > > +++ b/drivers/acpi/fan.c
> > > > > > @@ -27,7 +27,7 @@
> > > > > >  #include <linux/module.h>
> > > > > >  #include <linux/init.h>
> > > > > >  #include <linux/types.h>
> > > > > > -#include <asm/uaccess.h>
> > > > > > +#include <linux/uaccess.h>
> > > > > >  #include <linux/thermal.h>
> > > > > >  #include <linux/acpi.h>
> > > > > >  
> > > > > > @@ -127,8 +127,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
> > > > > >  };
> > > > > >  
> > > > > >  /* --------------------------------------------------------------------------
> > > > > > -                                 Driver Interface
> > > > > > -   -------------------------------------------------------------------------- */
> > > > > > + *                               Driver Interface
> > > > > > + * --------------------------------------------------------------------------
> > > > > > +*/
> > > > > >  
> > > > > >  static int acpi_fan_add(struct acpi_device *device)
> > > > > >  {
> > > > > > @@ -143,7 +144,7 @@ static int acpi_fan_add(struct acpi_device *device)
> > > > > >  
> > > > > >  	result = acpi_bus_update_power(device->handle, NULL);
> > > > > >  	if (result) {
> > > > > > -		printk(KERN_ERR PREFIX "Setting initial power state\n");
> > > > > > +		dev_err(&device->dev, PREFIX "Setting initial power state\n");
> > > > > 
> > > > > While at it, please define a proper pr_fmt() for this file and get rid of PREFIX
> > > > > too.
> > > > > 
> > > > > Otherwise I don't see a compelling reason to apply this.
> > > > > 
> > > > 
> > > > Hi,
> > > > Since in the patch I am not using any pr_* , so I am unable to understand why
> > > > you are asking for a proper pr_fmt().
> > > 
> > > Never mind, I was confused somehow, not exactly sure why.  Sorry about that.
> > > 
> > > > I can get rid of the PREFIX . Then should I use pr_* in the patch instead of dev_* ? 
> > > > My understanding was dev_* is more preffered than pr_*.
> > > > waiting for your suggestion on this.
> > > 
> > > Well, that really depends on the particular case.  It really is better to use
> > > dev_err() here, but then PREFIX with it is not really useful, so please just
> > > drop PREFIX from the new messages.
> > 
> > PREFIX is "ACPI: " so I think the idea is
> > to be able to grep for that.
> 
> I'm not sure how useful that is in this particular case.  You can grep for "power
> state" istead just fine ...
> 
> Rafael
> 

Then there is one more printk which prints fan state is on or off :

>dev_info(&device->dev, PREFIX "%s [%s] (%s)\n",
>	  acpi_device_name(device), acpi_device_bid(device),
>              !device->power.state ? "on" : "off");

So if we drop the PREFIX and if some one wants to grep for this fan on/off , then how to do that ..
after removing PREFIX , in dmesg I am getting it as :
[    2.056204] fan PNP0C0B:00: Fan [FAN0] (off)
[    2.056225] fan PNP0C0B:01: Fan [FAN1] (off)
[    2.056245] fan PNP0C0B:02: Fan [FAN2] (off)
[    2.056263] fan PNP0C0B:03: Fan [FAN3] (off)
[    2.056283] fan PNP0C0B:04: Fan [FAN4] (off)


thanks
sudip

