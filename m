Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaI2XJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:09:17 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36363 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaI2XJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <1412029912.4285.110.camel@pasglop>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <1412000971-9242-11-git-send-email-Liviu.Dudau@arm.com> <CAE9FiQXEUZvkuzwOrK+2zGVj0ywFaQsiWH7SHufZk9BRWnwddQ@mail.gmail.com>
 <CAE9FiQUkcPRMUEn01VJMyXz8aYvk6C5MBNZi5NCV2m3qkNabeg@mail.gmail.com>
 <1412024521.4285.98.camel@pasglop> <CAErSpo62ap1YkzvuZ6MCpXry9=VpLv+Skzrwr10h=+Lc4VfVgQ@mail.gmail.com>
 <1412029912.4285.110.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Sep 2014 17:08:49 -0600
Message-ID: <CAErSpo70t9TMdntjBt+GdTw3FVmMquACQePX8=SKkySPuG3F3Q@mail.gmail.com>
Subject: Re: [PATCH v13 10/12] PCI: Assign unassigned bus resources in pci_scan_root_bus()
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 4:31 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2014-09-29 at 15:33 -0600, Bjorn Helgaas wrote:
>> > Right and on powerpc and others as well. We need to survey existing
>> > resources. We also have a number of platform things that might need
>> > to happen before we do the final re-assignment pass.
>>
>> That's true today.  But I don't know whether it *has* to be this way
>> forever.  On x86, pcibios_resource_survey() throws in E820 information
>> (which we know long before we do any PCI enumeration) and some IO-APIC
>> resources (it looks like we also know these before PCI enumeration).
>> Powerpc has pcibios_reserve_legacy_regions(), but that looks like
>> mostly stuff that could be done when we find the host bridge, before
>> we enumerate PCI devices below it.
>
> Oh we can probably change that but it's going to be much more work than
> just moving the assignment into pci_scan_root_bus().

Agreed.  It's obvious that we can't apply Liviu's patch as-is.

> There are also a
> number of subtle and not-so-subtle bits of code that rely on side
> effects of the current code such as anything that tests for bus->added
> or dev->added. Again, nothing we can't sort out eventually but the
> transition might be a bit painful.
>
> We might need to introduce a new flag for platforms converted to the
> "new style" generalized resource assignment which we can deprecate once
> everybody has moved over.

There's definitely a lot of work here if we ever want to make this happen.

Bjorn
