Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CACE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:04:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48296 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3CACE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:04:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>, Sander Eikelenboom <linux@eikelenboom.it>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: libata-acpi.c ata_acpi_register_power_resource copy and paste mistake ?
Date: Fri, 01 Mar 2013 03:11:43 +0100
Message-ID: <2508494.4AbRYXD1du@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51300B8D.8030600@intel.com>
References: <928867757.20130228174510@eikelenboom.it> <51300B8D.8030600@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 01, 2013 09:59:41 AM Aaron Lu wrote:
> +Rafael
> 
> commit bc9b6407bd6df3ab7189e5622816bbc11ae9d2d8
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Jan 17 14:11:05 2013 +0100
> 
>     ACPI / PM: Rework the handling of devices depending on power resources
> 
> -Aaron

Thanks Aaron!

> On 03/01/2013 12:45 AM, Sander Eikelenboom wrote:
> > Hi Jeff,
> > 
> > During the last merge of ahci code (d9978ec5680059d727b39d6c706777c6973587f2), i saw this coming by:
> > 
> > 
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -1024,30 +1024,20 @@ static void ata_acpi_register_power_resource(struct ata_device *dev)
> >  {
> >         struct scsi_device *sdev = dev->sdev;
> >         acpi_handle handle;
> > -       struct device *device;
> >  
> >         handle = ata_dev_acpi_handle(dev);
> > -       if (!handle)
> > -               return;
> > -
> > -       device = &sdev->sdev_gendev;
> > -
> > -       acpi_power_resource_register_device(device, handle);
> > +       if (handle)
> > +               acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
> >  }
> > 
> > shouldn't:
> > 
> > acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
> > 
> > be
> > 
> > acpi_dev_pm_add_dependent(handle, &sdev->sdev_gendev);
> > 
> > in the ata_acpi_register_power_resource function ?
> > 
> > (seems like a copy and paste mistake from the unregister function)

Yes.  Sorry, my bad.

If you can prepare a patch fixing this, please do that, or I'll do it tomorrow.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
