Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaBUH2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:28:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:17454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbaBUH2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,517,1389772800"; 
   d="scan'208";a="485334874"
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
Thread-Index: AQHPLNl+pwKMYdvgHUOy81VxONa4eZq/UpBQ
Date: Fri, 21 Feb 2014 07:28:02 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024B23DE@SHSMSX101.ccr.corp.intel.com>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-2-git-send-email-trenn@suse.de>
 <7af8855f-8055-467c-89c0-bcab453f3969@email.android.com>
 <1568883.1dLS7uNIC1@skinner>
In-Reply-To: <1568883.1dLS7uNIC1@skinner>
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
> Sent: Wednesday, February 19, 2014 2:44 AM
> 
> On Tuesday, February 18, 2014 10:27:23 AM H. Peter Anvin wrote:
> > Why can't you add SSDTs? It would be particularly useful.
> 
> There are 2 ways how ACPI tables get added:
>    - Via pointer from a root table (XSDT or RSDT iirc)
>    - Via load statement inside of ACPI context when ACPI BIOS
>      code gets executed (iirc the physical address is passed).
> 
> The latter is only for SSDTs.
> The problem is that you if you add an SSDT early, it might
> have been intended for overriding when an SSDT gets dynamically
> loaded later when the system is up which is particular useful as
> well if you want to debug this specific BIOS table.
> 
> This could be workarounded via a boot param:
> acpi=allow_ssdt_adding
> But this is not nice. Maybe someone has a more elegant idea.
> Something could still be added if someone is really needing this.

I'm not sure if you are talking about the issue that:
If a system booted using customized DSDT embedded with SSDT, it also requires dynamic SSDT loading be prevented in ACPICA.

Thanks and best regards
-Lv


> 
>      Thomas
> _______________________________________________
> Devel mailing list
> Devel@acpica.org
> https://lists.acpica.org/mailman/listinfo/devel
