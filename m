Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaBRT7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:59:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:34737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaBRT7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="485384471"
From: "Moore, Robert" <robert.moore@intel.com>
To: Thomas Renninger <trenn@suse.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [Devel] ACPI: Also allow ACPI table adding via initrd not only
 overriding
Thread-Topic: [Devel] ACPI: Also allow ACPI table adding via initrd not only
 overriding
Thread-Index: AQHPLNqs7355MnvWjUS4kyQ/c/bl+5q7bdcQ
Date: Tue, 18 Feb 2014 19:59:17 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D78A7@ORSMSX103.amr.corp.intel.com>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-1-git-send-email-trenn@suse.de>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D7846@ORSMSX103.amr.corp.intel.com>
 <139301482.3RWgg14omZ@skinner>
In-Reply-To: <139301482.3RWgg14omZ@skinner>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe not exactly "running", but at the very least, ACPICA must be initialized.

All of this of course depends on how early the table needs to be loaded.


> -----Original Message-----
> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Tuesday, February 18, 2014 10:53 AM
> To: Moore, Robert
> Cc: x86@kernel.org; ck@conrad-kostecki.de; linux-kernel@vger.kernel.org;
> mingo@redhat.com; hpa@zytor.com; tglx@linutronix.de; devel@acpica.org
> Subject: Re: [Devel] ACPI: Also allow ACPI table adding via initrd not
> only overriding
> 
> On Tuesday, February 18, 2014 06:38:45 PM Moore, Robert wrote:
> > acpi_load_table won't work?
> 
> I guess not, there is:
>         /* Must acquire the interpreter lock during this operation */
>         status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
> 
> So the interpreter must be running already?
> That would mean the adding can only happen much later.
> This probably would eleminate most use cases for adding arbitrary ACPI
> tables. Most tables (beside DSDT and SSDT) are needed really early,
> otherwise the info could have been added as AML as well.
> 
>     Thomas
> 
> > > -----Original Message-----
> > > From: Devel [mailto:devel-bounces@acpica.org] On Behalf Of Thomas
> > > Renninger
> > > Sent: Tuesday, February 18, 2014 10:23 AM
> > > Cc: x86@kernel.org; ck@conrad-kostecki.de;
> > > linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com;
> > > tglx@linutronix.de; devel@acpica.org
> > > Subject: [Devel] ACPI: Also allow ACPI table adding via initrd not
> > > only overriding
> > >
> > > The ACPICA patches have to go into separate acpica repository first.
> > > It should also be checked in acpica whether the table signature the
> > > OS likes to add already exists (from BIOS). In this case the table
> > > must not be added.
> > >
> > > Worked here by trying to override a DSDT and addind a BGRT table.
> > >
> > >      Thomas
> > >
> > > _______________________________________________
> > > Devel mailing list
> > > Devel@acpica.org
> > > https://lists.acpica.org/mailman/listinfo/devel

