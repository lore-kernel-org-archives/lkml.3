Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaEAOIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:08:19 -0400
Received: from mx2.parallels.com ([199.115.105.18]:41947 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaEAOIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:08:17 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>
CC: "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Thread-Topic: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Thread-Index: AQHPZLNvK1nxQSaf0ES3zCf+oGYc5JssOYIA
Date: Thu, 1 May 2014 14:08:12 +0000
Message-ID: <1398953290.2313.15.camel@dabdike.int.hansenpartnership.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.152.79]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <1B860C57CE435F42ACC242686911F720@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:33 -0600, Bjorn Helgaas wrote:
> dma_declare_coherent_memory() takes two addresses for a region of memory: a
> "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
> the physical address a *CPU* would use to access the region, and
> "device_addr" is the bus address the *device* would use to address the
> region.
> 
> Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.

Remind me what the difference between phys_addr_t and dma_addr_t are.

I thought phys_addr_t was the maximum address the CPU could reach after
address translation and dma_addr_t was the maximum physical address any
bus attached memory mapped devices could appear at. (of course, mostly
they're the same).

The intent of dma_declare_coherent_memory() is to take a range of memory
provided by some device on the bus and allow the CPU to allocate regions
from it for use as things like descriptors.  The CPU treats it as real
memory, but, in fact, it is a mapped region of an attached device.

If my definition is correct, then bus_addr should be dma_addr_t because
it has to be mapped from a device and dma_addr_t is the correct type for
device addresses.  If I've got the definition wrong, then we should
document it somewhere, because it's probably confusing other people as
well.

James

