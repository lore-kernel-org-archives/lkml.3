Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaKFF3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:29:21 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52319 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaKFF3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:29:16 -0500
MIME-Version: 1.0
In-Reply-To: <545AFFF1.5030509@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com>
 <20141105230952.GH6168@google.com> <545AFFF1.5030509@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Nov 2014 22:28:55 -0700
Message-ID: <CAErSpo4JYzSQJQkRTaK-M18RVXaLKX-0yoAm853tu2NJypiL9g@mail.gmail.com>
Subject: Re: [Patch Part2 v4 21/31] PCI/MSI: enhance PCI MSI core to support
 hierarchy irqdomain
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
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

On Wed, Nov 5, 2014 at 9:58 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> On 2014/11/6 7:09, Bjorn Helgaas wrote:
>> On Tue, Nov 04, 2014 at 08:01:55PM +0800, Jiang Liu wrote:

>>> +{
>>> +    return (irq_hw_number_t)msidesc->msi_attrib.entry_nr |
>>> +            PCI_DEVID(pdev->bus->number, pdev->devfn) << 11 |
>>> +            (pci_domain_nr(pdev->bus) & 0xFFFFFFFF) << 27;
>>
>> Where does this bit layout come from?  Is this defined in the spec
>> somewhere?  A reference would help.
> We need a unique number to identify every possible MSI source,
> and this ID number is only used within the irqdomain subsystem.
> So we used above algorithm to generate the ID number, there's
> no specification for it.

A comment to that effect would be great.

Bjorn
