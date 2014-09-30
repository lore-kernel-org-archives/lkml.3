Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaI3Tce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:32:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58239 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752239AbaI3Tcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:32:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 4/5] ACPICA: Introduce acpi_enable_all_wakeup_gpes()
Date: Tue, 30 Sep 2014 21:52:28 +0200
Message-ID: <3883340.iE5nWN8xny@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37D20AA35@ORSMSX112.amr.corp.intel.com>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan> <4021848.ZWdxDcq97A@vostro.rjw.lan> <94F2FBAB4432B54E8AACC7DFDE6C92E37D20AA35@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 30, 2014 03:52:16 PM Moore, Robert wrote:
> If you need it, sure.

Thanks!

I hope this applies to https://patchwork.kernel.org/patch/4999321/ too?

> Let me know when there is an ACPICA version

OK


> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Monday, September 29, 2014 5:26 PM
> > To: ACPI Devel Maling List; Moore, Robert
> > Cc: Linux Kernel Mailing List; Zhang, Rui; Linux PM list
> > Subject: [PATCH 4/5] ACPICA: Introduce acpi_enable_all_wakeup_gpes()
> > 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Add a routine for host OSes to enable all wakeup GPEs and disable all of
> > the non-wakeup ones at the same time.
> > 
> > It will be used for the handling of GPE wakeup from suspend-to-idle in
> > Linux.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > Bob, please let me know if I can fast-track this one.
> > 
> > ---
> >  drivers/acpi/acpica/evxfgpe.c |   32 ++++++++++++++++++++++++++++++++
> >  include/acpi/acpixf.h         |    1 +
> >  2 files changed, 33 insertions(+)
> > 
> > Index: linux-pm/drivers/acpi/acpica/evxfgpe.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/acpica/evxfgpe.c
> > +++ linux-pm/drivers/acpi/acpica/evxfgpe.c
> > @@ -596,6 +596,38 @@ acpi_status acpi_enable_all_runtime_gpes
> > 
> >  ACPI_EXPORT_SYMBOL(acpi_enable_all_runtime_gpes)
> > 
> > +/**********************************************************************
> > +********
> > + *
> > + * FUNCTION:    acpi_enable_all_wakeup_gpes
> > + *
> > + * PARAMETERS:  None
> > + *
> > + * RETURN:      Status
> > + *
> > + * DESCRIPTION: Enable all "wakeup" GPEs and disable all of the other
> > GPEs, in
> > + *              all GPE blocks.
> > + *
> > +
> > +***********************************************************************
> > +*******/
> > +
> > +acpi_status acpi_enable_all_wakeup_gpes(void) {
> > +	acpi_status status;
> > +
> > +	ACPI_FUNCTION_TRACE(acpi_enable_all_wakeup_gpes);
> > +
> > +	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
> > +	if (ACPI_FAILURE(status)) {
> > +		return_ACPI_STATUS(status);
> > +	}
> > +
> > +	status = acpi_hw_enable_all_wakeup_gpes();
> > +	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
> > +
> > +	return_ACPI_STATUS(status);
> > +}
> > +
> > +ACPI_EXPORT_SYMBOL(acpi_enable_all_wakeup_gpes)
> > +
> > 
> > /*************************************************************************
> > ******
> >   *
> >   * FUNCTION:    acpi_install_gpe_block
> > Index: linux-pm/include/acpi/acpixf.h
> > ===================================================================
> > --- linux-pm.orig/include/acpi/acpixf.h
> > +++ linux-pm/include/acpi/acpixf.h
> > @@ -692,6 +692,7 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_sta
> >  						     *event_status))
> >  ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
> > ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
> > acpi_enable_all_runtime_gpes(void))
> > +ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
> > +acpi_enable_all_wakeup_gpes(void))
> > 
> >  ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
> >  				acpi_get_gpe_device(u32 gpe_index,
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
