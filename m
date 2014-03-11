Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaCKKoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:44:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:52099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaCKKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:44:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Liviu Dudau <liviu@dudau.co.uk>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic host_bridge from device tree
Date: Tue, 11 Mar 2014 11:43:39 +0100
Message-ID: <2664356.LLPHGvlG5M@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140311094641.GA27064@e106497-lin.cambridge.arm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com> <4254618.BlpDUOctDb@wuerfel> <20140311094641.GA27064@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ewz9TtT1rFUcxB9+UIyR5eM2qW3LqFSjnudNBwKNJMq
 43nHtUrQp7I+SVPLUNxMxXu6cev4GVo/HQX0Vu6fiR+T0WcE+p
 SkkD5ijN40fI780Sa1jRQcZVX68UsxV3M6TPBY3LMKjhnELa5N
 C1ZM3BvGKhXSxAMHae6Fg4uD8r5gF6iZkDpO6d9msM6iFglFlR
 3L176Ao+BgBncFjzk/DtRiA6IyIOmZsefVNc9FKhG9aFr2Rde5
 83UzflRxedsr/ZILvM2jGPIZ9kRq/Ou/VXxJUf6kagSjXhJbfq
 rZiXu0PEYat31YSrmAE+s7B253Fa8ggfljT5UXnfgQqQnkbRh6
 zaFsyzVaMdjJi2rAVg2o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2014 09:46:41 Liviu Dudau wrote:
> On Tue, Mar 11, 2014 at 06:50:24AM +0000, Arnd Bergmann wrote:
> > On Monday 10 March 2014 21:56:00 Liviu Dudau wrote:
> > > 
> > > PCI_IOBASE is always defined. See the discussion with Russell on this subject.
> > > 
> > > include/asm-generic/io.h has at line 118:
> > > 
> > > #ifndef PCI_IOBASE
> > > #define PCI_IOBASE ((void __iomem *) 0)
> > > #endif
> > 
> > That is only defined for those that use asm-generic/pci.h, which most architectures
> > don't.
> 
> I think it is defined for anyone that #includes <asm-generic/io.h>. There is no other
> #ifdef around that.
> 

My mistake, I meant to write asm-generic/io.h.

On a related note, I would actually prefer to get rid of this PCI_IOBASE
default and move it into the architectures that really want it like this.
The default when PCI_IOBASE is not set IMHO should be to also not provide
inb/outb and ioport_map() helpers, but we need a little more infrastructure
to actually make the kernel build in all valid configuration when we remove them.

	Arnd
