Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbaGPDB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:01:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:20823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557AbaGPDBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,669,1400050800"; 
   d="scan'208";a="570454631"
Message-ID: <53C5EB19.7060104@linux.intel.com>
Date: Wed, 16 Jul 2014 11:01:45 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86 platforms
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com> <20140714172642.GA12920@laptop.dumpdata.com> <20140714194133.GA22857@laptop.dumpdata.com> <53C54876.5090606@linux.intel.com> <20140715161035.GA8097@laptop.dumpdata.com>
In-Reply-To: <20140715161035.GA8097@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,
	We have found the root cause with your great support. If BIOS
assigns an IRQ number for a PCI device, acpi_pci_irq_enable() fails to
assign IOAPIC IRQ then due to the check:
        if (dev->irq > 0)
                return 0;
	For a quick workaround, just comment out above check. But we
need some time to figure out a clean fixup for it. We will send out new
version once it gets resolved.
	Thanks for your great help again.
Regards!
Gerry
On 2014/7/16 0:10, Konrad Rzeszutek Wilk wrote:
> already assigned IRQ
