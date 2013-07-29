Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3G2MBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:01:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45917 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3G2MA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:00:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power() print device names
Date: Mon, 29 Jul 2013 14:11:04 +0200
Message-ID: <57324148.csaJoe9IZd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOLK0pyBsD8vR0a2mcSucnD8zFTz8ZB72OPE0R9Z67SxH9VHRw@mail.gmail.com>
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1895563.95T8SxMegu@vostro.rjw.lan> <CAOLK0pyBsD8vR0a2mcSucnD8zFTz8ZB72OPE0R9Z67SxH9VHRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 11:06:36 AM Lan Tianyu wrote:
> 2013/7/27 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Modify acpi_device_set_power() so that diagnostic messages printed by
> > it to the kernel log always contain the name of the device concerned
> > to make it possible to identify the device that triggered the message
> > if need be.
> >
> > Also replace printk(KERN_WARNING ) with dev_warn() everywhere in that
> > function.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/device_pm.c |   22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/device_pm.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/device_pm.c
> > +++ linux-pm/drivers/acpi/device_pm.c
> > @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
> >         /* Make sure this is a valid target state */
> >
> >         if (state == device->power.state) {
> > -               ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
> > +               ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] already in %s\n",
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
> Missing "is" or it should be omitted?

The "is" is not necessary here (in my opinion).

Kind of in analogy with "This has been done already" and "Already done".

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
