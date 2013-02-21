Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3BUWvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:51:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41053 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab3BUWvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 2][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Thu, 21 Feb 2013 23:57:50 +0100
Message-ID: <1783470.LRRhOYxTLi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361468380.12845.14.camel@misato.fc.hp.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <2482081.rPvizM7IsG@vostro.rjw.lan> <1361468380.12845.14.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2013 10:39:40 AM Toshi Kani wrote:
> On Thu, 2013-02-21 at 16:52 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>  :
> > 
> > This update fixes an issue pointed out by Toshi Kani (_OST shouldn't be
> > evaluated after successful _EJ0).
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/acpi/scan.c     |  272 ++++++++++++++++++++++++++++++++++++++----------
> >  include/acpi/acpi_bus.h |    7 +
> >  2 files changed, 226 insertions(+), 53 deletions(-)
>  :
> > +static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
> > +{
> > +	struct acpi_device *device = NULL;
> > +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> > +	int error;
> > +
> > +	mutex_lock(&acpi_scan_lock);
> > +
> > +	acpi_bus_get_device(handle, &device);
> > +	if (device) {
> > +		dev_warn(&device->dev, "Attempt to re-insert\n");
> > +		goto out;
> > +	}
> > +	acpi_evaluate_hotplug_ost(handle, ost_source,
> > +				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
> > +	ost_source = ACPI_OST_EC_OSPM_INSERTION;
> 
> Thanks for the update.  I confirmed that _OST was handled correctly for
> hot-delete.  However, I found there is an issue for hot-add too.
> ACPI_OST_EC_OSPM_INSERTION is used for _OST when the OS initiated a
> hot-add event (which may not happen today).  This case, however, is that
> hot-add is initiated by FW through an ACPI notification.  So, ost_source
> must have the ACPI notification event value.

OK

So I think acpi_bus_device_eject() should be changed analogously.

I'll send another update in a while. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
