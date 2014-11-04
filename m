Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaKDPNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:13:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:23124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbaKDPN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:13:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="602023706"
Message-ID: <5458ECF3.4040308@linux.intel.com>
Date: Tue, 04 Nov 2014 23:12:51 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86 platforms
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <20141104144730.GE14512@8bytes.org>
In-Reply-To: <20141104144730.GE14512@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/4 22:47, Joerg Roedel wrote:
> Hi Jiang,
> 
> On Tue, Nov 04, 2014 at 08:01:34PM +0800, Jiang Liu wrote:
>> This is the second patch set to enable support of hierarchy irqdomain
>> on x86 platforms. It depends on the first part at:
>> https://lkml.org/lkml/2014/10/27/122
>> And you may access it at:
>> https://github.com/jiangliu/linux.git irqdomain/p2v4
> 
> I gave this some testing on a couple of machines. Unfortunatly it panics
> on my AMD Kaveri system with IOMMU enabled in drivers/pci/msi.c:
> 
> static void msi_set_mask_bit(struct irq_data *data, u32 flag)
> {
>         struct msi_desc *desc = irq_data_get_msi(data);
> 
>         if (desc->msi_attrib.is_msix) {		<-- at this line something goes wrong
>                 msix_mask_irq(desc, flag);
>                 readl(desc->mask_base);         /* Flush write to device */
>         } else {
>                 unsigned offset = data->irq - desc->irq;
>                 msi_mask_irq(desc, 1 << offset, flag << offset);
>         }
> }
> 
> I am further investigating to find out what went wrong, but maybe you
> also have an idea?
Hi Joerg,
	Thanks for testing:)
	Do you have the call stack? I have changed the way to call
irq_set_msi_desc_off() for MSI/MSIx interrupts, which may cause the
panic. Patch 19-21 changes the PCI MSI code.
Regards!
Gerry

> 
> 
> 	Joerg
> 
