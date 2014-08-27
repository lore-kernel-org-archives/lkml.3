Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbaH0WUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaH0WUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:20:45 -0400
Date: Wed, 27 Aug 2014 18:19:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: HT1000 SATA broken by "x86, irq, ACPI: Use common irqdomain map
 interface to program IOAPIC pins"
In-Reply-To: <alpine.DEB.2.10.1408272322130.3323@nanos>
Message-ID: <alpine.LRH.2.02.1408271819210.26495@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1408271657300.17705@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.10.1408272322130.3323@nanos>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2014, Thomas Gleixner wrote:

> On Wed, 27 Aug 2014, Mikulas Patocka wrote:
> 
> > Hi
> > 
> > The patch d7b830013f59cf586c1cec3caa1ce7156da59a13, committed to 3.17-rc1, 
> > breaks the SATA controller (sata_svw driver) on HT1000 ServerWorks 
> > chipset. The other drivers work correctly.
> > 
> > With the patch d7b830013f59cf586c1cec3caa1ce7156da59a13, the SATA 
> > controller times out after every command with lost interrupt.
> > 
> > With the patch 16ee7b3dcc56be14b9a813612cff2cc2339cdced, the SATA driver 
> > can't be loaded at all, it fails with:
> > sata_svw 0000:01:0e.0: version 2.3
> > Failed to set pin attr for GSI11
> > sata_svw 0000:01:0e.0: PCI INT A: failed to register GSI
> > sata_svw: probe of 0000:01:0e.0 failed with error -1
> 
> Can you please pull 
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent
> 
> into your tree and check whether this solves the issues?
> 
> Thanks,
> 
> 	tglx

Yes, that fixes it.

Mikulas
