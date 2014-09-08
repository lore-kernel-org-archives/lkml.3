Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaIHWcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:32:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaIHWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:32:32 -0400
Date: Mon, 8 Sep 2014 15:32:27 -0700
From: Darren Hart <dvhart@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device
 objects
Message-ID: <20140908223226.GA5645@vmdeb7>
References: <5487060.QsgluucUH4@vostro.rjw.lan>
 <3770704.uNPCcL4EDK@vostro.rjw.lan>
 <1408807277.3315.43.camel@rzhang1-toshiba>
 <1786905.chzpd7cfQ3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786905.chzpd7cfQ3@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:14:04AM +0200, Rafael J. Wysocki wrote:
> On Saturday, August 23, 2014 11:21:17 PM Zhang Rui wrote:
> 
> [cut]
> 
> Darren, would there be any problems if I took the patch below from Rui for 3.18?
> 

No objection.

Acked-by: Darren Hart <dvhart@linux.intel.com>

> > 
> > So I guess the following patch can be upstream candidate, right?
> > 
> > From e32c2de37750d622dae6ef9d2f5c448a528a7edb Mon Sep 17 00:00:00 2001
> > From: Zhang Rui <rui.zhang@intel.com>
> > Date: Fri, 22 Aug 2014 09:06:10 +0800
> > Subject: [PATCH] ACPI: remove Fujitsu backlight and hotkey device ID from ACPI
> >  PNP id list
> > 
> > Fujitsu backlight and hotkey devices have ACPI drivers.
> > The PNP MODULE_DEVICE_TABLE in fujitsu-laptop driver is just used as an
> > indicator for module autoloading. But this is wrong because what we need is
> > ACPI module device table instead because the driver is probing ACPI devices.
> > 
> > Thus remove those ids from ACPI PNP scan handler list as we don't
> > have PNP driver for them, and convert the fujitsu-laptop PNP
> > MODULE_DEVICE_TABLE to ACPI MODULE_DEVICE_TABLE.
> > 
> > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=81971
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > Tested-by: Dirk Griesbach <spamthis@freenet.de>
> > ---
> >  drivers/acpi/acpi_pnp.c               |  4 ----
> >  drivers/platform/x86/fujitsu-laptop.c | 16 +++++++---------
> >  2 files changed, 7 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> > index 1f8b204..b193f84 100644
> > --- a/drivers/acpi/acpi_pnp.c
> > +++ b/drivers/acpi/acpi_pnp.c
> > @@ -130,10 +130,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
> >  	{"PNP0401"},		/* ECP Printer Port */
> >  	/* apple-gmux */
> >  	{"APP000B"},
> > -	/* fujitsu-laptop.c */
> > -	{"FUJ02bf"},
> > -	{"FUJ02B1"},
> > -	{"FUJ02E3"},
> >  	/* system */
> >  	{"PNP0c02"},		/* General ID for reserving resources */
> >  	{"PNP0c01"},		/* memory controller */
> > diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> > index 87aa28c..2655d4a 100644
> > --- a/drivers/platform/x86/fujitsu-laptop.c
> > +++ b/drivers/platform/x86/fujitsu-laptop.c
> > @@ -1050,6 +1050,13 @@ static struct acpi_driver acpi_fujitsu_hotkey_driver = {
> >  		},
> >  };
> >  
> > +static const struct acpi_device_id fujitsu_ids[] __used = {
> > +	{ACPI_FUJITSU_HID, 0},
> > +	{ACPI_FUJITSU_HOTKEY_HID, 0},
> > +	{"", 0}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, fujitsu_ids);
> > +
> >  static int __init fujitsu_init(void)
> >  {
> >  	int ret, result, max_brightness;
> > @@ -1208,12 +1215,3 @@ MODULE_LICENSE("GPL");
> >  MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
> >  MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
> >  MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
> > -
> > -static struct pnp_device_id pnp_ids[] __used = {
> > -	{.id = "FUJ02bf"},
> > -	{.id = "FUJ02B1"},
> > -	{.id = "FUJ02E3"},
> > -	{.id = ""}
> > -};
> > -
> > -MODULE_DEVICE_TABLE(pnp, pnp_ids);
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Darren Hart
Intel Open Source Technology Center
