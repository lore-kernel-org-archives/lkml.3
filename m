Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaBSLOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:14:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaBSLOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:14:42 -0500
From: Thomas Renninger <trenn@suse.de>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [Devel] ACPI: Also allow ACPI table adding via initrd not only overriding
Date: Wed, 19 Feb 2014 12:14:38 +0100
Message-ID: <2779111.V9OOdv2fEJ@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D78A7@ORSMSX103.amr.corp.intel.com>
References: <530265A3.3020302@zytor.com> <139301482.3RWgg14omZ@skinner> <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D78A7@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 07:59:17 PM Moore, Robert wrote:
> Maybe not exactly "running", but at the very least, ACPICA must be
> initialized.
> 
> All of this of course depends on how early the table needs to be loaded.

I'd say as early as possible.
Not sure about Thomas' use case.
I expect most of the extra tables are needed before ACPICA gets
initialized otherwise it could have been specified to put the info
into DSDT/SSDT via ASL.
Sooner or later people will hit the "I need it earlier" limit and
patch:
ACPICA: Introduce new acpi_os_physical_table_add OS callback
shows that it can be done early and that it integrates nicely
with only some additional lines.

   Thomas
