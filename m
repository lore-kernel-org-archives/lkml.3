Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaEIUZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:25:46 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33076 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbaEIUZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:25:43 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "Liviu.Dudau@arm.com" <Liviu.Dudau@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Thread-Topic: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Thread-Index: AQHPaX1NMahrVPvX6kaqPxq/74Mo6Zs1NsQAgAERmwCAAK7kAIAAo+uAgADhvQCAAF01AIAASI8AgAAHtgCAAAGogA==
Date: Fri, 9 May 2014 20:25:40 +0000
Message-ID: <1399667139.2166.71.camel@dabdike.int.hansenpartnership.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
	 <1399629530.879.21.camel@i7.infradead.org>
	 <20140509153226.GA3571@google.com> <9450765.GaoRYW154J@wuerfel>
	 <CAErSpo5bPvaATcptz3wGdLWOG-1thHKCHDK5D8K=D9wy+NDomA@mail.gmail.com>
In-Reply-To: <CAErSpo5bPvaATcptz3wGdLWOG-1thHKCHDK5D8K=D9wy+NDomA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.150.111]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <0A9C8152E1EBAB44B05F2CF653EF37B0@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 14:19 -0600, Bjorn Helgaas wrote:
> On Fri, May 9, 2014 at 1:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 09 May 2014 09:32:26 Bjorn Helgaas wrote:
> >> > There are people who care deeply about the performance of IOMMU API
> >> > map/unmap. It isn't used *just* for virtual machines any more. See
> >> > drivers/infiniband/hw/usnic/usnic_uiom.c for example.
> >>
> >> Of course we should care about IOMMU API performance.  We should also
> >> care about interface consistency, and it seems there's a tradeoff in
> >> this case.  I said "relatively" because I expect map/unmap to be less
> >> frequent than read/write operations that use the mapping.  I don't
> >> know anything about infiniband, so maybe that assumption is false
> >> there.
> >
> > In most drivers using the streaming DMA API, every mapping is used
> > exactly once. Think of network or block drivers: they rarely send
> > the same data twice to the device, and it usually comes from or
> > goes to some user space buffer.
> 
> Oh, good point.  I don't work that high up in the stack, so thanks for
> reminding me of that.

To round this out, for most devices we have two types of mappings: the
mailbox ones, which designate regions of communication memory between
the kernel and the device which are usually permanent mappings, and the
transmission mappings: every bit of data we send to the device is
mapped, sent/received and then unmapped.  The setup and teardown costs
factor into the throughput.  Some high iops devices (like SSD or high
speed net) are peculiarly sensitive to this.

James

