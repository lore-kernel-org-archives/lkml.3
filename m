Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaBEJA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:00:29 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:53903 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaBEJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:00:27 -0500
MIME-Version: 1.0
In-Reply-To: <52F1F74C.2090106@codethink.co.uk>
References: <20140205065243.29445.76593.sendpatchset@w520>
	<52F1F74C.2090106@codethink.co.uk>
Date: Wed, 5 Feb 2014 18:00:26 +0900
Message-ID: <CANqRtoRMAjBEXjBzivPxqMu8KhFsOkp0wb6jBbuZQx=B-qYuUA@mail.gmail.com>
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space update
From: Magnus Damm <magnus.damm@gmail.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-pci@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Feb 5, 2014 at 5:33 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 05/02/14 06:52, Magnus Damm wrote:
>>
>> PCI: rcar: Driver model and physical address space update
>>
>> [PATCH 01/04] PCI: rcar: Register each instance independently
>> [PATCH 02/04] PCI: rcar: Break out window size handling
>> [PATCH 03/04] PCI: rcar: Add DMABOUNCE support
>> [PATCH 04/04] PCI: rcar: Enable BOUNCE in case of HIGHMEM
>>
>> These patches update the pci-rcar-gen2.c driver in various ways
>> including cleanups for driver model interface (1/4), readability
>> update (2/4) and also bounce buffer support (3/4, 4/4). Basically
>> the first two are just cleanups and the rest are fixes.
>>
>> As it is today without these patches the system memory start address
>> is hard coded at 0x4000000 and the window is fixed at 1GiB. So we
>> have board specific code hidden in the driver which is good to avoid.
>>
>> With these hard coded board specific constants there are some error cases
>> that are not handled, in particular the issue that only maximum 1GiB of
>> physical address space can be used for bus mastering with a single window.
>> The common case of using ARM CONFIG_VMSPLIT_3G results in no visible
>> issues
>> as long as CONFIG_BOUNCE is used, but other CONFIG_VMSPLIT settings will
>> break due to the hard coded 1GiB window not being enough. It has been
>> verified that reducing the window size to 256MB makes the driver behave
>> the same with VMSPLIT_3G as 1GiB window size and other VMSPLIT settings.
>>
>> To handle the maximum 1GiB physical address space limitation two types
>> of bounce buffers are added. The ARM specific DMABOUNCE code is in 3/4
>> hooked up to a chunk of local memory that is also handed of as coherent
>> memory to the pci devices hanging off the PCI bridge. The driver makes
>> sure to set the window so the local memory is always included. When the
>> PCI devices are operating and in case memory is used outside the window
>> then the DMABOUNCE buffers kicks in. This makes the driver support all
>> kinds of VMSPLIT settings and window sizes. The BOUNCE code in 4/4 is
>> selected to make sure bounce buffers are used for HIGHMEM.
>>
>> With these patches this driver can be used with or without CMA and
>> with or without DMA zone. Basically the system wide memory setup is
>> left to the user. If a DMA zone is used then the PCI window will
>> be setup to cover that. Same thing with CMA.
>>
>> Tested with USB storage using LPAE and various VMSPLIT settings together
>> with renesas git tag renesas-devel-v3.14-rc1-20140204 from kernel.org
>
>
> Ok, is it possible to build a set with my of updates ready for next
> merge window? I can update the set based on this if you like and try
> and make the necessary changes to deal with the modifications from this
> series.

I think we should try to pick out the stuff that is ready to be merged
first. I think these patches may require a bit of time before people
start looking at them. I don't mind resending in the future.

To be honest, I have not been paying too much attention to other
patches including yours - been focused trying to get the memory
management part right.. So I'd like to focus on correctness over DT
for now if possible. Of course we it all.

Would it be possible for you to provide a list of pci-rcar-gen2.c
patches that you posted? Or perhaps you can resend your series and
include acks that you received?

Thanks,

/ magnus
