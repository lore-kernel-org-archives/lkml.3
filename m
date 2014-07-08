Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaGHIet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:34:49 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50810 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753199AbaGHIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:34:46 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Thread-Topic: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Thread-Index: AQHPljNB2YNqvD5cNkq3/QaNLPhjzpuOEsDAgAF8RoCABWaUgIAA63Pw
Date: Tue, 8 Jul 2014 08:33:17 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726E211@AcuExch.aculab.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
 <063D6719AE5E284EB5DD2968C1650D6D1726BF4E@AcuExch.aculab.com>
 <20140704085816.GB12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo7QWc35seoMhJA+H1_=MkKWYMdeYG=hT=i1v=iz8d5ezA@mail.gmail.com>
In-Reply-To: <CAErSpo7QWc35seoMhJA+H1_=MkKWYMdeYG=hT=i1v=iz8d5ezA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s688YsNq015294

From: Bjorn Helgaas
...
> >> Even if you do that, you ought to write valid interrupt information
> >> into the 4th slot (maybe replicating one of the earlier interrupts).
> >> Then, if the device does raise the 'unexpected' interrupt you don't
> >> get a write to a random kernel location.
> >
> > I might be missing something, but we are talking of MSI address space
> > here, aren't we? I am not getting how we could end up with a 'write'
> > to a random kernel location when a unclaimed MSI vector sent. We could
> > only expect a spurious interrupt at worst, which is handled and reported.
> 
> Yes, that's how I understand it.  With MSI, the OS specifies the a
> single Message Address, e.g., a LAPIC address, and a single Message
> Data value, e.g., a vector number that will be written to the LAPIC.
> The device is permitted to modify some low-order bits of the Message
> Data to send one of several vector numbers (the MME value tells the
> device how many bits it can modify).
> 
> Bottom line, I think a spurious interrupt is the failure we'd expect
> if a device used more vectors than the OS expects it to.

So you need to tell the device where to write in order to raise the
'spurious interrupt'.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
