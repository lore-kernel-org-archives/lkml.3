Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaGIPK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:10:29 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48899 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbaGIPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140708224847.GC4980@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com> <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com> <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Jul 2014 09:10:04 -0600
Message-ID: <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for pci_host_bridge.
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 4:48 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Tue, Jul 08, 2014 at 07:41:50PM +0100, Bjorn Helgaas wrote:
>> On Tue, Jul 8, 2014 at 4:46 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > On Tue, Jul 08, 2014 at 01:59:54AM +0100, Bjorn Helgaas wrote:
>>
>> >> I wonder if it would help to make a weak pci_domain_nr() function that
>> >> returns "bridge->domain_nr".  Then each arch could individually drop its
>> >> pci_domain_nr() definition as it was converted, e.g., something like this:
>> >>
>> >>   - Convert every arch pci_domain_nr() from a #define to a non-inline
>> >>     function
>> >>   - Add bridge.domain_nr, initialized from pci_domain_nr()
>> >>   - Add a weak generic pci_domain_nr() that returns bridge.domain_nr
>> >>   - Add a way to create a host bridge in a specified domain, so we can
>> >>     initialize bridge.domain_nr without using pci_domain_nr()
>> >>   - Convert each arch to use the new creation mechanism and drop its
>> >>     pci_domain_nr() implementation
>> >
>> > I will try to propose a patch implementing this.
>>
>> I think this is more of an extra credit, cleanup sort of thing.  I
>> don't think it advances your primary goal of (I think) getting arm64
>> PCI support in.  So my advice is to not worry about unifying domain
>> handling until later.
>
> Getting arm64 supported *is* my main goal. But like you have stated in your
> review of v7, you wanted to see another architecture converted as a guarantee
> of "genericity" (for lack of a better word) for my patches. The one architecture
> I've set my eyes on is microblaze, and that one uses pci_scan_root_bus()
> rather than pci_create_root_bus() so I don't have any opportunity to pass the
> domain number or any additional info (like the sysdata pointer that we were
> talking about) to the pci_host_bridge structure unless I do this cleanup.

I think maybe I was too harsh about that, or maybe we had different
ideas about what "conversion" involved.  My comment was in response to
"pci: Introduce pci_register_io_range() helper function", and I don't
remember why I was concerned about that; it's not even in drivers/pci,
and it doesn't have an obvious connection to putting the domain number
in struct pci_host_bridge.

The thing I'm more concerned about is adding new PCI interfaces, e.g.,
pci_create_root_bus_in_domain(), that are only used by one
architecture.  Then it's hard to be sure that it's going to be useful
for other arches.  If you can add arm64 using the existing PCI
interfaces, I don't any problem with that.

Bjorn
