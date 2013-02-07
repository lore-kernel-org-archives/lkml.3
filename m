Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422722Ab3BGWXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:23:04 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:17218 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664Ab3BGWXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:23:01 -0500
Message-ID: <1360275146.3869.0.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Unbind ACPI drv when probe failed
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
Date: Thu, 07 Feb 2013 15:12:26 -0700
In-Reply-To: <1992165.bgMBd9nLM4@vostro.rjw.lan>
References: <1360271953-15643-1-git-send-email-toshi.kani@hp.com>
	 <1992165.bgMBd9nLM4@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:18 +0100, Rafael J. Wysocki wrote:
> On Thursday, February 07, 2013 02:19:13 PM Toshi Kani wrote:
> > When acpi_device_install_notify_handler() failed in acpi_device_probe(),
> > it calls acpi_drv->ops.remove() and fails the probe.  However, the ACPI
> > driver is left bound to the acpi_device.  Fix it by clearing the driver
> > and driver_data fields.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> > This patch is based on linux-pm.git/bleeding-edge.
> 
> Good catch, thanks.  I'm going to apply it.

Great!  Thanks,
-Toshi


> 
> Rafael
> 
> 
> > ---
> >  drivers/acpi/scan.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index d6caf1d..39659bb 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -627,6 +627,8 @@ static int acpi_device_probe(struct device * dev)
> >  			if (ret) {
> >  				if (acpi_drv->ops.remove)
> >  					acpi_drv->ops.remove(acpi_dev);
> > +				acpi_dev->driver = NULL;
> > +				acpi_dev->driver_data = NULL;
> >  				return ret;
> >  			}
> >  		}


