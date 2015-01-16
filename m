Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbbAPOyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:54:13 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41833 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbbAPOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:54:12 -0500
Message-ID: <54B92614.5090900@gmail.com>
Date: Fri, 16 Jan 2015 15:54:12 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v3 1/1] atm: remove deprecated use of pci api
References: <20150112161042.GA11374@sloth>	<20150113.215944.1703977685948196746.davem@davemloft.net>	<063D6719AE5E284EB5DD2968C1650D6D1CAC79B3@AcuExch.aculab.com>	<20150116085721.56aa8075@thirdoffive.cmf.nrl.navy.mil>	<54B91BD1.70909@gmail.com> <20150116095244.40249284@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20150116095244.40249284@thirdoffive.cmf.nrl.navy.mil>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16/01/2015 15:52, chas williams - CONTRACTOR wrote:
> On Fri, 16 Jan 2015 15:10:25 +0100
> Quentin Lambert <lambert.quentin@gmail.com> wrote:
>
>
>>> -    u32 dma_addr = pci_map_single((struct pci_dev*)fore200e->bus_dev, virt_addr, size, direction);
>>> +    u32 dma_addr = dma_map_single(&((struct pci_dev *) fore200e->bus_dev)->dev, virt_addr, size, direction);
>>>    
>>>        DPRINTK(3, "PCI DVMA mapping: virt_addr = 0x%p, size = %d, direction = %d,  --> dma_addr = 0x%08x\n",
>>>    	    virt_addr, size, direction, dma_addr);
>>>
>> []
>>
>> I am going try to make similar changes in some other part of the kernel and
>> I was wondering if you could explain how you decided it wasn't necessary to
>> check for "((struct pci_dev *) fore200e->bus_dev" nullity for instance.
> This gets set up in fore200e_pca_detect() which is pretty early in the
> intialization process.  We don't get as far as using any of the "DVMA"
> stubs unless pci_enable_device() succeeds, meaning pci_dev is good, and
> fore200e->bus_dev is assigned to pci_dev (around line 2724).
>
> fore200e->bus_dev is never cleared back to NULL, but obviously you
> shouldn't be using any of the DMA routines after disabling the pci
> device.  Hopefully the driver shuts down in an orderly fashion such
> that all DMA is over by the time the driver disables the pci device.
Thank you
