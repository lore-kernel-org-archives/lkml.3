Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228AbaH0XHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:07:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59001 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964814AbaH0XHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:07:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fan.c: printk replacement
Date: Thu, 28 Aug 2014 01:26:58 +0200
Message-ID: <2510233.V8A8GLG6Qe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140827045747.GA3309@sudip-PC>
References: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com> <4713016.Cq5xvW8zIj@vostro.rjw.lan> <20140827045747.GA3309@sudip-PC>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 10:27:47 AM Sudip Mukherjee wrote:
> On Tue, Aug 26, 2014 at 11:22:12PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, August 26, 2014 01:59:02 PM Joe Perches wrote:
> > > On Tue, 2014-08-26 at 23:02 +0200, Rafael J. Wysocki wrote:
> > > > On Tuesday, August 26, 2014 09:00:39 PM Sudip Mukherjee wrote:
> > > > > On Tue, Aug 26, 2014 at 12:45:20AM +0200, Rafael J. Wysocki wrote:
> > > > > > On Friday, August 22, 2014 05:33:21 PM Sudip Mukherjee wrote:
> > > > > > > printk replaced with corresponding dev_err and dev_info
> > > > > > > fixed one broken user-visible string
> > > > > > > multiine comment edited for correct commenting style
> > > > > > > asm/uaccess.h replaced with linux/uaccess.h
> > > > > > > 
> > > > > > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > > > > > ---
> > > > > > >  drivers/acpi/fan.c | 18 +++++++++---------
> > > > > > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > > > > > > index 8acf53e..7900d55 100644
> > > > > > > --- a/drivers/acpi/fan.c
> > > > > > > +++ b/drivers/acpi/fan.c
> > > > > > > @@ -27,7 +27,7 @@
> > > > > > >  #include <linux/module.h>
> > > > > > >  #include <linux/init.h>
> > > > > > >  #include <linux/types.h>
> > > > > > > -#include <asm/uaccess.h>
> > > > > > > +#include <linux/uaccess.h>
> > > > > > >  #include <linux/thermal.h>
> > > > > > >  #include <linux/acpi.h>
> > > > > > >  
> > > > > > > @@ -127,8 +127,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
> > > > > > >  };
> > > > > > >  
> > > > > > >  /* --------------------------------------------------------------------------
> > > > > > > -                                 Driver Interface
> > > > > > > -   -------------------------------------------------------------------------- */
> > > > > > > + *                               Driver Interface
> > > > > > > + * --------------------------------------------------------------------------
> > > > > > > +*/
> > > > > > >  
> > > > > > >  static int acpi_fan_add(struct acpi_device *device)
> > > > > > >  {
> > > > > > > @@ -143,7 +144,7 @@ static int acpi_fan_add(struct acpi_device *device)
> > > > > > >  
> > > > > > >  	result = acpi_bus_update_power(device->handle, NULL);
> > > > > > >  	if (result) {
> > > > > > > -		printk(KERN_ERR PREFIX "Setting initial power state\n");
> > > > > > > +		dev_err(&device->dev, PREFIX "Setting initial power state\n");
> > > > > > 
> > > > > > While at it, please define a proper pr_fmt() for this file and get rid of PREFIX
> > > > > > too.
> > > > > > 
> > > > > > Otherwise I don't see a compelling reason to apply this.
> > > > > > 
> > > > > 
> > > > > Hi,
> > > > > Since in the patch I am not using any pr_* , so I am unable to understand why
> > > > > you are asking for a proper pr_fmt().
> > > > 
> > > > Never mind, I was confused somehow, not exactly sure why.  Sorry about that.
> > > > 
> > > > > I can get rid of the PREFIX . Then should I use pr_* in the patch instead of dev_* ? 
> > > > > My understanding was dev_* is more preffered than pr_*.
> > > > > waiting for your suggestion on this.
> > > > 
> > > > Well, that really depends on the particular case.  It really is better to use
> > > > dev_err() here, but then PREFIX with it is not really useful, so please just
> > > > drop PREFIX from the new messages.
> > > 
> > > PREFIX is "ACPI: " so I think the idea is
> > > to be able to grep for that.
> > 
> > I'm not sure how useful that is in this particular case.  You can grep for "power
> > state" istead just fine ...
> > 
> > Rafael
> > 
> 
> Then there is one more printk which prints fan state is on or off :
> 
> >dev_info(&device->dev, PREFIX "%s [%s] (%s)\n",
> >	  acpi_device_name(device), acpi_device_bid(device),
> >              !device->power.state ? "on" : "off");
> 
> So if we drop the PREFIX and if some one wants to grep for this fan on/off , then how to do that ..
> after removing PREFIX , in dmesg I am getting it as :
> [    2.056204] fan PNP0C0B:00: Fan [FAN0] (off)
> [    2.056225] fan PNP0C0B:01: Fan [FAN1] (off)
> [    2.056245] fan PNP0C0B:02: Fan [FAN2] (off)
> [    2.056263] fan PNP0C0B:03: Fan [FAN3] (off)
> [    2.056283] fan PNP0C0B:04: Fan [FAN4] (off)

$ dmesg | grep fan

?

You can simply say "ACPI fan [%s] (%s)\n", acpi_device_bid(device) " in that
dev_info too.

Rafael

