Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaKFELX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:11:23 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64106 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKFELU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <545AD5B3.60009@huawei.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
 <20141105230952.GH6168@google.com> <545AD5B3.60009@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Nov 2014 21:10:59 -0700
Message-ID: <CAErSpo5PNAQ40-AQZiz_RTU0JKnSAVXO2Wz=XPQ7aMWjm-iaNA@mail.gmail.com>
Subject: Re: [Patch Part2 v4 21/31] PCI/MSI: enhance PCI MSI core to support
 hierarchy irqdomain
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
        Alexander Gordeev <agordeev@redhat.com>,
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

On Wed, Nov 5, 2014 at 6:58 PM, Yijing Wang <wangyijing@huawei.com> wrote:

>>> +{
>>> +    return (irq_hw_number_t)msidesc->msi_attrib.entry_nr |
>>> +            PCI_DEVID(pdev->bus->number, pdev->devfn) << 11 |
>>> +            (pci_domain_nr(pdev->bus) & 0xFFFFFFFF) << 27;
>>
>> Where does this bit layout come from?  Is this defined in the spec
>> somewhere?  A reference would help.
>
> Currently, more and more Non-PCI device use MSI(or similar MSI mechanism), like DMAR fault irq
> and HPET FSB irq. And we have to add additional code to support the MSI capability.
> So I hope we can decouple MSI code and PCI code, then we can unify all MSI(or Message Based interrupt)
> in one framework.

Was that supposed to answer my question?  If so, I didn't understand
how it explains where the bit layout came from.

Bjorn
