Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaKDOrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:47:36 -0500
Received: from 8bytes.org ([81.169.241.247]:34331 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbaKDOrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:47:33 -0500
Date: Tue, 4 Nov 2014 15:47:30 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86
 platforms
Message-ID: <20141104144730.GE14512@8bytes.org>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On Tue, Nov 04, 2014 at 08:01:34PM +0800, Jiang Liu wrote:
> This is the second patch set to enable support of hierarchy irqdomain
> on x86 platforms. It depends on the first part at:
> https://lkml.org/lkml/2014/10/27/122
> And you may access it at:
> https://github.com/jiangliu/linux.git irqdomain/p2v4

I gave this some testing on a couple of machines. Unfortunatly it panics
on my AMD Kaveri system with IOMMU enabled in drivers/pci/msi.c:

static void msi_set_mask_bit(struct irq_data *data, u32 flag)
{
        struct msi_desc *desc = irq_data_get_msi(data);

        if (desc->msi_attrib.is_msix) {		<-- at this line something goes wrong
                msix_mask_irq(desc, flag);
                readl(desc->mask_base);         /* Flush write to device */
        } else {
                unsigned offset = data->irq - desc->irq;
                msi_mask_irq(desc, 1 << offset, flag << offset);
        }
}

I am further investigating to find out what went wrong, but maybe you
also have an idea?


	Joerg

