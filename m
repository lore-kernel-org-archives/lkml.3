Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbaHZPa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:30:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40724 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaHZPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:30:53 -0400
Date: Tue, 26 Aug 2014 21:00:39 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fan.c: printk replacement
Message-ID: <20140826153039.GA2684@sudip-PC>
References: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com>
 <6969509.uGLFfCOQBb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6969509.uGLFfCOQBb@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 12:45:20AM +0200, Rafael J. Wysocki wrote:
> On Friday, August 22, 2014 05:33:21 PM Sudip Mukherjee wrote:
> > printk replaced with corresponding dev_err and dev_info
> > fixed one broken user-visible string
> > multiine comment edited for correct commenting style
> > asm/uaccess.h replaced with linux/uaccess.h
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/acpi/fan.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > index 8acf53e..7900d55 100644
> > --- a/drivers/acpi/fan.c
> > +++ b/drivers/acpi/fan.c
> > @@ -27,7 +27,7 @@
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/types.h>
> > -#include <asm/uaccess.h>
> > +#include <linux/uaccess.h>
> >  #include <linux/thermal.h>
> >  #include <linux/acpi.h>
> >  
> > @@ -127,8 +127,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
> >  };
> >  
> >  /* --------------------------------------------------------------------------
> > -                                 Driver Interface
> > -   -------------------------------------------------------------------------- */
> > + *                               Driver Interface
> > + * --------------------------------------------------------------------------
> > +*/
> >  
> >  static int acpi_fan_add(struct acpi_device *device)
> >  {
> > @@ -143,7 +144,7 @@ static int acpi_fan_add(struct acpi_device *device)
> >  
> >  	result = acpi_bus_update_power(device->handle, NULL);
> >  	if (result) {
> > -		printk(KERN_ERR PREFIX "Setting initial power state\n");
> > +		dev_err(&device->dev, PREFIX "Setting initial power state\n");
> 
> While at it, please define a proper pr_fmt() for this file and get rid of PREFIX
> too.
> 
> Otherwise I don't see a compelling reason to apply this.
> 

Hi,
Since in the patch I am not using any pr_* , so I am unable to understand why you are asking for a proper pr_fmt().
I can get rid of the PREFIX . Then should I use pr_* in the patch instead of dev_* ? 
My understanding was dev_* is more preffered than pr_*.
waiting for your suggestion on this.

thanks
sudip


> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
