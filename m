Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3BUPhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:37:39 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40841 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab3BUPhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:37:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Thu, 21 Feb 2013 16:44:16 +0100
Message-ID: <3641033.GDD5TPDrZi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361409468.12845.7.camel@misato.fc.hp.com>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <1765527.DdJ8fCt5cH@vostro.rjw.lan> <1361409468.12845.7.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 06:17:48 PM Toshi Kani wrote:
> On Wed, 2013-02-20 at 23:49 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>  :
> > +
> > +/**
> > + * acpi_bus_hot_remove_device: hot-remove a device and its children
> > + * @context: struct acpi_eject_event pointer (freed in this func)
> > + *
> > + * Hot-remove a device and its children. This function frees up the
> > + * memory space passed by arg context, so that the caller may call
> > + * this function asynchronously through acpi_os_hotplug_execute().
> > + */
> > +void acpi_bus_hot_remove_device(void *context)
> > +{
> > +	struct acpi_eject_event *ej_event = context;
> > +	struct acpi_device *device = ej_event->device;
> > +	acpi_handle handle = device->handle;
> > +	u32 ost_code = ACPI_OST_SC_SUCCESS;
> > +	int error;
> > +
> > +	mutex_lock(&acpi_scan_lock);
> > +
> > +	error = acpi_scan_hot_remove(device);
> > +	if (error)
> > +		ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> > +
> > +	acpi_evaluate_hotplug_ost(handle, ej_event->event, ost_code, NULL);
> 
> Thanks for the quick update.  It fixed the deadlock issue. :-)  As it
> now completes an eject operation, I found a new issue.  When the OS
> called _EJ0, it is not supposed to call _OST since FW has already
> received the completion status from _EJ0.  That is, the OS calls either
> _EJ0 (success case) or _OST (failure case) for hot-delete. 

In fact, I wasn't quite sure about that, so thanks a lot for the clarification.

That makes life a bit easier, actually. :-)

I'll send a second update in a little while.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
