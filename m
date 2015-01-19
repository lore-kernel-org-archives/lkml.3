Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbbASEjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:39:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:62171 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbbASEjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,424,1418112000"; 
   d="scan'208";a="514124897"
Message-ID: <54BC8A7F.5070502@linux.intel.com>
Date: Mon, 19 Jan 2015 12:39:27 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-pci@vger.kernel.org
Subject: Re: [Bugfix v4 1/2] xen/pci: Fix xen IRQ allocation failure caused
 by commit b81975eade8c
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com> <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com> <1421327077-19894-2-git-send-email-jiang.liu@linux.intel.com> <20150116181318.GA22690@l.oracle.com>
In-Reply-To: <20150116181318.GA22690@l.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2015/1/17 2:13, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 15, 2015 at 09:04:35PM +0800, Jiang Liu wrote:
<snit>
>>
>> Note: we need to test this patch on those special AMD systems which
>> override normal SCI GSI (9) with strange GSI (20).
> 
> [    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 2.1c       10/28/2011
> ..
>      0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> ..
>     6.358737] xen: registering gsi 20 triggering 0 polarity 1
> [    6.358756] xen: --> pirq=20 -> irq=20 (gsi=20)
> ...
> -bash-4.1# cat /proc/interrupts |grep acpi
>  20:          0          0          0  xen-pirq-ioapic-level  acpi
> 
Thanks Konrad, it works as expected. Previously IRQ9 was assigned
to ACPI SCI GSI 20, now it assigns IRQ20. But that's OK, ACPI has
no special requirement about the assigned IRQ number, we could
assign any valid IRQ number for ACPI SCI GSI.
Thanks!
Gerry

