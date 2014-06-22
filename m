Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaFVOmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 10:42:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:26355 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaFVOmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 10:42:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,524,1400050800"; 
   d="scan'208";a="448522744"
Date: Sun, 22 Jun 2014 22:39:46 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        alek.du@intel.com, mark.gross@intel.com
Subject: Re: [Patch V4 00/42] use irqdomain to dynamically allocate IRQ for
 IOAPIC
Message-ID: <20140622143946.GA20551@feng-snb>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
 <20140622084227.GA13974@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140622084227.GA13974@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 22, 2014 at 04:42:27PM +0800, Ingo Molnar wrote:
> 
> JFYI, with these patches applied x86 allyes32config fails with:
> 
>   arch/x86/platform/intel-mid/device_libs/platform_wdt.c:45:3: error: implicit declaration of function ‘io_apic_set_pci_routing’ 

In some intel-mid platforms (Medfield/Merrifield etc), the IOAPIC
may have more than 80 pins, and some devices like a i2c based touch
screen has its interrupt line directly connected to IOAPIC (this
platform_wdt.c here should be the same case).

Since these devices are not PCI device or ACPI device, they can't
use the general PCI/ACPI xxx_enable_dev APIs which implicitly set
up the ioapic entry, but use this "io_apic_set_pci_routing"
directly.

Thanks,
Feng

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
