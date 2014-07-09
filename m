Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbaGIPVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:21:43 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:53263 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaGIPVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <201407090820.49418.arnd@arndb.de>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <201407080900.44882.arnd@arndb.de> <20140708212951.GA4555@google.com> <201407090820.49418.arnd@arndb.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Jul 2014 09:21:17 -0600
Message-ID: <CAErSpo6Oj-0cceTRM838nAFsSAJ1R7XVtqtUWV+DocqM=iwyqQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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

On Wed, Jul 9, 2014 at 12:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 08 July 2014, Bjorn Helgaas wrote:

>> I think my confusion is because your pci_register_io_range() and
>> pci_addess_to_pci() implementations assume that every io_range starts at
>> I/O port 0 on PCI (correct me if I'm wrong).  I suspect that's why you
>> don't save the I/O port number in struct io_range.
>
> I think you are just misreading the code, but I agree it's hard to
> understand and I made the same mistake in my initial reply to the
> first version.
>
> pci_register_io_range and pci_address_to_pci only worry about the mapping
> between CPU physical and Linux I/O address, they do not care which PCI
> port numbers are behind that. The mapping between PCI port numbers and
> Linux port numbers is done correctly in patch 8/9 in the
> pci_host_bridge_of_get_ranges() function.

Ah, I see now.  Thanks for explaining this again (I see you explained
it earlier; I just didn't understand it).  Now that I see it, it *is*
very slick to handle both MMIO and PIO spaces the same way.

Bjorn
