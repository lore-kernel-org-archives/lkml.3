Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaBUHYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:24:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:25662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaBUHYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:24:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,517,1389772800"; 
   d="scan'208";a="485332904"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Thomas Renninger <trenn@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [Devel] [PATCH 1/4] ACPI: Provide support for ACPI table adding
	via OS
Thread-Topic: [Devel] [PATCH 1/4] ACPI: Provide support for ACPI table
 adding	via OS
Thread-Index: AQHPLWT3pwKMYdvgHUOy81VxONa4eZq/Ttkw
Date: Fri, 21 Feb 2014 07:24:20 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024B23BD@SHSMSX101.ccr.corp.intel.com>
References: <530265A3.3020302@zytor.com> <1568883.1dLS7uNIC1@skinner>
 <5303C7BB.4020803@zytor.com> <3327021.IBYDWO02Gb@skinner>
In-Reply-To: <3327021.IBYDWO02Gb@skinner>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

> From: Devel [mailto:devel-bounces@acpica.org] On Behalf Of Thomas Renninger
> Sent: Wednesday, February 19, 2014 7:23 PM
> 
> On Tuesday, February 18, 2014 12:51:07 PM H. Peter Anvin wrote:
> > On 02/18/2014 10:44 AM, Thomas Renninger wrote:
> > > On Tuesday, February 18, 2014 10:27:23 AM H. Peter Anvin wrote:
> > >> Why can't you add SSDTs? It would be particularly useful.
> > >
> > > There are 2 ways how ACPI tables get added:
> > >    - Via pointer from a root table (XSDT or RSDT iirc)
> > >    - Via load statement inside of ACPI context when ACPI BIOS
> > >
> > >      code gets executed (iirc the physical address is passed).
> > >
> > > The latter is only for SSDTs.
> > > The problem is that you if you add an SSDT early, it might
> > > have been intended for overriding when an SSDT gets dynamically
> > > loaded later when the system is up which is particular useful as
> > > well if you want to debug this specific BIOS table.
> > >
> > > This could be workarounded via a boot param:
> > > acpi=allow_ssdt_adding
> > > But this is not nice. Maybe someone has a more elegant idea.
> > > Something could still be added if someone is really needing this.
> >
> > Since adding SSDTs is one of the things I really can imagine one would
> > do, I think we need to figure out how to do that.  I would think that
> > overriding would be the exception case.
> 
> You can always paste new code into the DSDT. It is effectively the same
> than adding a new SSDT table.
> The other way around, modifying or deleting broken code in a BIOS
> provided SSDT needs overriding.
> 
> So in fact adding SSDTs is not necessary at all.
> It would be a nice add-on, but it's not even worth introducing
> an extra boot param or whatever confusion.
> A hint in Documentation that adding additional ASL (ACPI Source Language)
> code to the DSDT would be the same than creating and adding a new
> SSDT table which is not possible should be enough.

IMO, we need to load tables from RSDT/XSDT, they look like "static tables".
Given that we can live in the environment where table reloading is properly implemented by ACPICA, we won't face issues.
And the reloading feature is also required by ACPI specification.
If a table contains same "signature, oem_id, oem_table_id", it could be able to replace the old loaded one if the revision field is greater than the old one.

Actually I'm currently working on the parallel reloading support and all functionalities have been done.
This report is a bit hurry than I expected.
I'll try to prepare fixes (which seems to be dozens of patches) for the testers to validate.

Fortunately, specific to this bug, I don't think the reload requirement must be implemented as the new one doesn't contain a greater revision number.
So there might just be dead lock issues for this bug.

Thanks and best regards
-Lv

> 
> The whole thing will always taint the kernel and is meant for
> debugging only anyway.
> 
>    Thomas
> _______________________________________________
> Devel mailing list
> Devel@acpica.org
> https://lists.acpica.org/mailman/listinfo/devel
