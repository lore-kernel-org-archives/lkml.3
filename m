Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaGHSmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:42:15 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:60647 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaGHSmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140708104655.GC6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com> <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Jul 2014 12:41:50 -0600
Message-ID: <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
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

On Tue, Jul 8, 2014 at 4:46 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Tue, Jul 08, 2014 at 01:59:54AM +0100, Bjorn Helgaas wrote:

>> I wonder if it would help to make a weak pci_domain_nr() function that
>> returns "bridge->domain_nr".  Then each arch could individually drop its
>> pci_domain_nr() definition as it was converted, e.g., something like this:
>>
>>   - Convert every arch pci_domain_nr() from a #define to a non-inline
>>     function
>>   - Add bridge.domain_nr, initialized from pci_domain_nr()
>>   - Add a weak generic pci_domain_nr() that returns bridge.domain_nr
>>   - Add a way to create a host bridge in a specified domain, so we can
>>     initialize bridge.domain_nr without using pci_domain_nr()
>>   - Convert each arch to use the new creation mechanism and drop its
>>     pci_domain_nr() implementation
>
> I will try to propose a patch implementing this.

I think this is more of an extra credit, cleanup sort of thing.  I
don't think it advances your primary goal of (I think) getting arm64
PCI support in.  So my advice is to not worry about unifying domain
handling until later.

Bjorn
