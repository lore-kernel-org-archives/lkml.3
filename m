Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbaCTP05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:26:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32830 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751925AbaCTP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:26:56 -0400
Date: Thu, 20 Mar 2014 15:26:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: DMABOUNCE in pci-rcar
Message-ID: <20140320152640.GW7528@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de> <CAErSpo5RV=w+DkgHSZZPOFGiEBBxMSraLV3TepYUZwDJuV+Jzg@mail.gmail.com> <5165962.7bqj51B15Z@wuerfel> <532B0384.1000400@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532B0384.1000400@codethink.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 04:04:36PM +0100, Ben Dooks wrote:
> On 26/02/14 20:57, Arnd Bergmann wrote:
>> On Wednesday 26 February 2014 12:48:17 Bjorn Helgaas wrote:
>>> On Mon, Feb 24, 2014 at 4:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> Hi Magnus,
>>>>
>>>> I noticed during randconfig testing that you enabled DMABOUNCE for the
>>>> pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30
>>>>
>>>> I didn't see the original post unfortunately, but I fear we have to
>>>> revert it and come up with a better solution, ...
>>>
>>> Sounds like I should drop the following patches from my pci/host-rcar
>>> branch for now?
>>>
>>>    PCI: rcar: Add DMABOUNCE support
>>>    PCI: rcar: Enable BOUNCE in case of HIGHMEM
>>>    PCI: rcar: Make the Kconfig dependencies more generic
>>
>> Sounds good to me. The last patch is actually fine, but you'll have to
>> fix the context to apply it without the other two.
>
> As a note, if we now boot a Lager with DT on 3.14-rc3 series the USB
> controllers no longer work with full 2GiB RAM enabled in the device
> tree.
>
> Could we work around this by having 1GiB of memory defined in the
> 32bit memory and then add the rest of the 3GiB from the >32bit
> area via LPAE? Will the kernel ever try to allocate DMA memory from
> anything >32bit?

Ignore highmem.  What is the actual hardware restriction concerning memory
it can access?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
