Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbbATJzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:55:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12292 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbbATJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:55:04 -0500
X-IronPort-AV: E=Sophos;i="5.09,433,1418083200"; 
   d="scan'208";a="219704233"
Message-ID: <54BE25F3.3030807@citrix.com>
Date: Tue, 20 Jan 2015 09:54:59 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Bugfix 1/3] xen/pci: Kill function xen_setup_acpi_sci()
References: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com> <1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 02:21, Jiang Liu wrote:
> Currently Xen Domain0 has special treatment for ACPI SCI interrupt,
> that is initialize irq for ACPI SCI at early stage in a special way as:
> xen_init_IRQ()
> 	->pci_xen_initial_domain()
> 		->xen_setup_acpi_sci()
> 			Allocate and initialize irq for ACPI SCI
> 
> Function xen_setup_acpi_sci() calls acpi_gsi_to_irq() to get an irq
> number for ACPI SCI. But unfortunately acpi_gsi_to_irq() depends on
> IOAPIC irqdomains through following path
> acpi_gsi_to_irq()
> 	->mp_map_gsi_to_irq()
> 		->mp_map_pin_to_irq()
> 			->check IOAPIC irqdomain

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David
