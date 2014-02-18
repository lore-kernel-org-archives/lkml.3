Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaBRSwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:52:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaBRSwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:52:49 -0500
From: Thomas Renninger <trenn@suse.de>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [Devel] ACPI: Also allow ACPI table adding via initrd not only overriding
Date: Tue, 18 Feb 2014 19:52:46 +0100
Message-ID: <139301482.3RWgg14omZ@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D7846@ORSMSX103.amr.corp.intel.com>
References: <530265A3.3020302@zytor.com> <1392747763-3384-1-git-send-email-trenn@suse.de> <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D7846@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 06:38:45 PM Moore, Robert wrote:
> acpi_load_table won't work?

I guess not, there is:
        /* Must acquire the interpreter lock during this operation */
        status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);

So the interpreter must be running already?
That would mean the adding can only happen much later.
This probably would eleminate most use cases for adding arbitrary
ACPI tables. Most tables (beside DSDT and SSDT) are needed really
early, otherwise the info could have been added as AML as well.

    Thomas 
 
> > -----Original Message-----
> > From: Devel [mailto:devel-bounces@acpica.org] On Behalf Of Thomas
> > Renninger
> > Sent: Tuesday, February 18, 2014 10:23 AM
> > Cc: x86@kernel.org; ck@conrad-kostecki.de; linux-kernel@vger.kernel.org;
> > mingo@redhat.com; hpa@zytor.com; tglx@linutronix.de; devel@acpica.org
> > Subject: [Devel] ACPI: Also allow ACPI table adding via initrd not only
> > overriding
> > 
> > The ACPICA patches have to go into separate acpica repository first.
> > It should also be checked in acpica whether the table signature the OS
> > likes to add already exists (from BIOS). In this case the table must not
> > be added.
> > 
> > Worked here by trying to override a DSDT and addind a BGRT table.
> > 
> >      Thomas
> > 
> > _______________________________________________
> > Devel mailing list
> > Devel@acpica.org
> > https://lists.acpica.org/mailman/listinfo/devel

