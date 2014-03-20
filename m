Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbaCTPhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:37:01 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37081 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758459AbaCTPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:36:58 -0400
Message-ID: <532B0B14.7040600@codethink.co.uk>
Date: Thu, 20 Mar 2014 16:36:52 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: DMABOUNCE in pci-rcar
References: <201402241200.21944.arnd@arndb.de> <CAErSpo5RV=w+DkgHSZZPOFGiEBBxMSraLV3TepYUZwDJuV+Jzg@mail.gmail.com> <5165962.7bqj51B15Z@wuerfel> <532B0384.1000400@codethink.co.uk> <20140320152640.GW7528@n2100.arm.linux.org.uk>
In-Reply-To: <20140320152640.GW7528@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/14 16:26, Russell King - ARM Linux wrote:
> On Thu, Mar 20, 2014 at 04:04:36PM +0100, Ben Dooks wrote:
>> On 26/02/14 20:57, Arnd Bergmann wrote:
>>> On Wednesday 26 February 2014 12:48:17 Bjorn Helgaas wrote:
>>>> On Mon, Feb 24, 2014 at 4:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> Hi Magnus,
>>>>>
>>>>> I noticed during randconfig testing that you enabled DMABOUNCE for the
>>>>> pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30
>>>>>
>>>>> I didn't see the original post unfortunately, but I fear we have to
>>>>> revert it and come up with a better solution, ...
>>>>
>>>> Sounds like I should drop the following patches from my pci/host-rcar
>>>> branch for now?
>>>>
>>>>     PCI: rcar: Add DMABOUNCE support
>>>>     PCI: rcar: Enable BOUNCE in case of HIGHMEM
>>>>     PCI: rcar: Make the Kconfig dependencies more generic
>>>
>>> Sounds good to me. The last patch is actually fine, but you'll have to
>>> fix the context to apply it without the other two.
>>
>> As a note, if we now boot a Lager with DT on 3.14-rc3 series the USB
>> controllers no longer work with full 2GiB RAM enabled in the device
>> tree.
>>
>> Could we work around this by having 1GiB of memory defined in the
>> 32bit memory and then add the rest of the 3GiB from the >32bit
>> area via LPAE? Will the kernel ever try to allocate DMA memory from
>> anything >32bit?
>
> Ignore highmem.  What is the actual hardware restriction concerning memory
> it can access?

If the window is set to 2GiB it can only access 2GiB aligned to 2GiB
boundary, however DRAM spans a 2GiB boundary (being at 1-3GiB)


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
