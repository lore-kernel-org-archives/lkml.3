Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKFEEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:04:48 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:42283 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKFEEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:04:44 -0500
MIME-Version: 1.0
In-Reply-To: <545ACFC7.9090204@huawei.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-21-git-send-email-jiang.liu@linux.intel.com>
 <20141105224504.GG6168@google.com> <545ACFC7.9090204@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Nov 2014 21:04:22 -0700
Message-ID: <CAErSpo6VtVA7zi-Z9eFR41ENvJe-TCDJKx3pqaKF+SwyfGxWwA@mail.gmail.com>
Subject: Re: [Patch Part2 v4 20/31] PCI/MSI: Kill redundant calling for
 irq_set_msi_desc() for MSIx interrupts
To: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 6:32 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2014/11/6 6:45, Bjorn Helgaas wrote:
>> On Tue, Nov 04, 2014 at 08:01:54PM +0800, Jiang Liu wrote:
>>> It's arch_setup_msi_irq()/arch_setup_msi_irqs()'s responsibility to call
>>> irq_set_msi_desc() to associate IRQ descriptors and MSI descriptors,
>>> so kill the redundant call of irq_set_msi_desc() for MSIx interrupts
>>> in PCI MSI core.
>>
>> "MSI-X" in English text, "msix" in code.
>>
>> The default arch_setup_msi_irq() in drivers/pci/msi.c doesn't call
>> irq_set_msi_desc().  Does it happen somewhere inside chip->setup_irq()?
>
> Yes.
>
> I also found this.
> http://www.spinics.net/lists/linux-pci/msg34256.html

Yes, and I asked the same question then :)

It's just impractical to review things like this that make assumptions
about lots of code scattered all over the place with no direct linkage
to the change.

Bjorn
