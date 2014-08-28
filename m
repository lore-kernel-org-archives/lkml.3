Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbaH1Nhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:37:46 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59496 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaH1Nhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:37:45 -0400
Date: Thu, 28 Aug 2014 19:07:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] acpi: fan.c: printk replacement
Message-ID: <20140828133725.GA18217@sudip-PC>
References: <CAC-25o8XLy1S1g2KUk3E59m=Az6eVfOONgkMQmkkeikkneS4bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC-25o8XLy1S1g2KUk3E59m=Az6eVfOONgkMQmkkeikkneS4bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 08:53:45AM -0400, edubezval@gmail.com wrote:
> Hello Sudip,
> 
> On Thu, Aug 28, 2014 at 7:33 AM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> > printk replaced with corresponding dev_err and dev_info
> > fixed one broken user-visible string
> > multiine comment edited for correct commenting style
> > asm/uaccess.h replaced with linux/uaccess.h
> > PREFIX removed
> >
> 
> Just a minor tip. When sending a new version of your patches do not
> use the RESEND prefix in you subject line. RESEND means you did not
> make changes on your patches and you are just resending it because,
> for instance, people did not answer it. When you modify your changes
> after, say updating it due to review comments, it is a good practice
> to use 'vX' prefix, so those who are following the patch will
> understand that this patch has something new from previous version. In
> this case, I suppose the current patch should be '[PATCH v2]' instead
> of [PATCH][RESEND].
> 
> BR,

Hi,
Thanks for the information. I will say it a major tip for me now. And infact now I understand why i didn't get a reply for another patch i posted around 8 - 10 days back.

thanks again
sudip



> 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >
> > modified with reference to the discussion at https://lkml.org/lkml/2014/8/22/176
> >
> >  drivers/acpi/fan.c | 18 ++++++++----------
> >  1 file changed, 8 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > index 8acf53e..5328b10 100644
> > --- a/drivers/acpi/fan.c
> > +++ b/drivers/acpi/fan.c
> > @@ -27,12 +27,10 @@
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/types.h>
> > -#include <asm/uaccess.h>
> > +#include <linux/uaccess.h>
> >  #include <linux/thermal.h>
> >  #include <linux/acpi.h>
> >
> > -#define PREFIX "ACPI: "
> > -
> >  #define ACPI_FAN_CLASS                 "fan"
> >  #define ACPI_FAN_FILE_STATE            "state"
> >
> > @@ -127,8 +125,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
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
> > @@ -143,7 +142,7 @@ static int acpi_fan_add(struct acpi_device *device)
> >
> >         result = acpi_bus_update_power(device->handle, NULL);
> >         if (result) {
> > -               printk(KERN_ERR PREFIX "Setting initial power state\n");
> > +               dev_err(&device->dev, "Setting initial power state\n");
> >                 goto end;
> >         }
> >
> > @@ -168,10 +167,9 @@ static int acpi_fan_add(struct acpi_device *device)
> >                                    &device->dev.kobj,
> >                                    "device");
> >         if (result)
> > -               dev_err(&device->dev, "Failed to create sysfs link "
> > -                       "'device'\n");
> > +               dev_err(&device->dev, "Failed to create sysfs link 'device'\n");
> >
> > -       printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
> > +       dev_info(&device->dev, "ACPI: %s [%s] (%s)\n",
> >                acpi_device_name(device), acpi_device_bid(device),
> >                !device->power.state ? "on" : "off");
> >
> > @@ -217,7 +215,7 @@ static int acpi_fan_resume(struct device *dev)
> >
> >         result = acpi_bus_update_power(to_acpi_device(dev)->handle, NULL);
> >         if (result)
> > -               printk(KERN_ERR PREFIX "Error updating fan power state\n");
> > +               dev_err(dev, "Error updating fan power state\n");
> >
> >         return result;
> >  }
> > --
> > 1.8.1.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> Eduardo Bezerra Valentin
