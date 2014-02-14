Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaBNKwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:52:30 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:44316 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaBNKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:52:28 -0500
Message-ID: <52FDF564.1070904@codethink.co.uk>
Date: Fri, 14 Feb 2014 10:52:20 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-pci@vger.kernel.org, "Simon Horman [Horms]" <horms@verge.net.au>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 00/08] PCI: rcar: Recent driver patches from Ben Dooks
 and me
References: <20140213030302.10398.37322.sendpatchset@w520> <52FCBBEA.70300@codethink.co.uk> <CANqRtoRJvvFHXGTMVmyhu3_ERH0wB8McMeE3P-jbp5_HT_2COQ@mail.gmail.com>
In-Reply-To: <CANqRtoRJvvFHXGTMVmyhu3_ERH0wB8McMeE3P-jbp5_HT_2COQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/14 05:40, Magnus Damm wrote:
> On Thu, Feb 13, 2014 at 9:34 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>> On 13/02/14 03:03, Magnus Damm wrote:
>>>
>>> PCI: rcar: Recent driver patches from Ben Dooks and me
>>>
>>> [PATCH 01/08] PCI: rcar: check platform_get_irq() return code
>>> [PATCH v2 02/08] PCI: rcar: add error interrupt handling
>>> [PATCH 03/08] PCI: rcar: fix bridge logic configuration accesses
>>> [PATCH v2 04/08] PCI: rcar: Register each instance independently
>>> [PATCH v2 05/08] PCI: rcar: Break out window size handling
>>> [PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
>>> [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
>>> [PATCH 08/08] PCI: rcar: Make the Kconfig dependencies more generic
>>>
>>> These patches update the pci-rcar-gen2.c driver with patches from
>>> Ben Dooks and me. The first 3 are written by Ben (thanks!) and are
>>> included here to show what I would like to have merged and what I
>>> rebased my patches on. The following 4 are updated versions of
>>>
>>> [PATCH 00/04] PCI: rcar: Driver model and physical address space update
>>>
>>> The final patch is a new one that fixes up the Kconfig dependencies.
>>
>>
>> Thanks. Is there any chance of getting this driver device-tree
>> enabled too?
>
> I think so! The DT bindings proposed by you looked good for this device.
>
> The only question is how to handle the PHY hardware in a sane way. The
> PHY is the central problematic point so to say, since it ties these
> PCI USB2.0 devices together with USBHS and for some SoCs USB 3.0 as
> well.
>
> I'm thinking of something along these lines:
>
> 1) To use DT to describe the full hardware topology
> 2) Enable all or some device drivers in the kernel configuration
> 3) Have a sane default but use the bind interface to reassign
> driver-to-port configuration.
>
> What is your intended use case?

I think we can describe this all from the PHY node or links to
the PHY node. I was going to look at sorting out the bindings
next week, due to this week being mostly consumed by chasing
bugs.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
