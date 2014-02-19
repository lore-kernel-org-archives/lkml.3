Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaBSNC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:02:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:50779 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaBSNC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:02:58 -0500
Date: Wed, 19 Feb 2014 14:03:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Renninger <trenn@suse.de>
cc: "Moore, Robert" <robert.moore@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [Devel] ACPI: Also allow ACPI table adding via initrd not only
 overriding
In-Reply-To: <2779111.V9OOdv2fEJ@skinner>
Message-ID: <alpine.DEB.2.02.1402191356320.4468@ionos.tec.linutronix.de>
References: <530265A3.3020302@zytor.com> <139301482.3RWgg14omZ@skinner> <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D78A7@ORSMSX103.amr.corp.intel.com> <2779111.V9OOdv2fEJ@skinner>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Thomas Renninger wrote:

> On Tuesday, February 18, 2014 07:59:17 PM Moore, Robert wrote:
> > Maybe not exactly "running", but at the very least, ACPICA must be
> > initialized.
> > 
> > All of this of course depends on how early the table needs to be loaded.
> 
> I'd say as early as possible.
> Not sure about Thomas' use case.

The case is a BIOS with complete lack of ACPI tables. So we have no
data about IOAPIC, HPET and other stuff.

The current acpi_initrd_override() call is sufficient, because its
called before acpi_boot_table_init(), which is the first function
accessing any of the tables.

Thanks,

	tglx

