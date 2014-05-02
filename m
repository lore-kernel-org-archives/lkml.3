Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaEBLC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:02:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47842 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBLCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:02:25 -0400
Date: Fri, 2 May 2014 12:02:20 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Message-ID: <20140502110220.GK4750@e106497-lin.cambridge.arm.com>
Mail-Followup-To: James Bottomley <jbottomley@parallels.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <1398953290.2313.15.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
In-Reply-To: <1398953290.2313.15.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 02 May 2014 11:02:35.0923 (UTC) FILETIME=[064EEE30:01CF65F6]
X-MC-Unique: 114050212022207101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 03:08:12PM +0100, James Bottomley wrote:
> On Wed, 2014-04-30 at 14:33 -0600, Bjorn Helgaas wrote:
> > dma_declare_coherent_memory() takes two addresses for a region of memory: a
> > "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
> > the physical address a *CPU* would use to access the region, and
> > "device_addr" is the bus address the *device* would use to address the
> > region.
> > 
> > Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.
> 
> Remind me what the difference between phys_addr_t and dma_addr_t are.
> 
> I thought phys_addr_t was the maximum address the CPU could reach after
> address translation and dma_addr_t was the maximum physical address any
> bus attached memory mapped devices could appear at. (of course, mostly
> they're the same).

My understanding is that dma_addr_t has nothing to do (directly) with the
bus the device is on. In the way I understand things, dma_addr_t is the
range of addresses that a DMA engine (possibly inside a device) can access.

So it is possible to have a device sitting on a PCI bus that uses addresses
for dma_addr_t that are 32bit but those addresses are then translated by
the bus translation setup into phys_addr_t and that can be any size
(preferrably >= dma_addr_t).

One way of seeing dma_addr_t is a translated IO physical address. And yes,
that means that there are two ways of expressing a phys_addr_t, except
that dma_addr_t is further restricted to the space that the DMA engine can
access and how the address output of the DMA engine gets mapped on the
physical busses.

Best regards,
Liviu

> 
> The intent of dma_declare_coherent_memory() is to take a range of memory
> provided by some device on the bus and allow the CPU to allocate regions
> from it for use as things like descriptors.  The CPU treats it as real
> memory, but, in fact, it is a mapped region of an attached device.
> 
> If my definition is correct, then bus_addr should be dma_addr_t because
> it has to be mapped from a device and dma_addr_t is the correct type for
> device addresses.  If I've got the definition wrong, then we should
> document it somewhere, because it's probably confusing other people as
> well.
> 
> James
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

