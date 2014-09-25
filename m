Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaIYQRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:17:00 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49509 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <8057985.kyfsioKAVy@wuerfel>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <3414852.SWQ9rRcUDx@wuerfel> <CA+sq2CcXCVrk=fxH79n88ZJj5fBQmbyhnzj08qHNO8EmpZT1Yg@mail.gmail.com>
 <8057985.kyfsioKAVy@wuerfel>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Sep 2014 10:16:36 -0600
Message-ID: <CAErSpo4oFLKbtddzVoXBN-1dXZn5C4pmzY_QiFMwV+RWtmtjiQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 1:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 25 September 2014 00:37:00 Sunil Kovvuri wrote:
>> On Thu, Sep 25, 2014 at 12:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Wednesday 24 September 2014 23:34:04 Sunil Kovvuri wrote:

>> >> All on-board PCI devices connected to this PCI controller have fixed resources
>> >> and doesn't have to be allocated/reassigned. Some of these devices are
>> >> SRIOV based.
>> >
>> > I think you need to mark the ones that are nonrelocatable with flag
>> > 0x80000000, otherwise the PCI core might decide to reassign them.
>>
>> Is this flag part of DT pci node properties ?
>> I am using IORESOURCE_PCI_FIXED flag. Its there in other patches of
>> the same series.
>
> Ah, right. I checked the source code again and it seems that we don't handle
> this right at the moment. I think a range that has the nonrelocatable
> flag set should be used for IORESOURCE_PCI_FIXED mappings without any
> host specific code, but that needs to be implemented in common code.

What connection do you envision between nonrelocatable ranges and
IORESOURCE_PCI_FIXED?  I don't know what a nonrelocatable range is,
but for IORESOURCE_PCI_FIXED, all I intend is that the PCI core should
not try to assign a different address, e.g., because the BAR is
read-only or because it's a legacy IDE/VGA/etc. range for which there
is no BAR at all.

Bjorn
