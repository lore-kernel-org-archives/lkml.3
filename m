Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaI3Syu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:54:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:61936 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaI3Sys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:54:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Tue, 30 Sep 2014 20:54:41 +0200
Message-ID: <3079787.54pZijGjZM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930174821.GX841@e106497-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <20140930173540.GB16583@e102568-lin.cambridge.arm.com> <20140930174821.GX841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:v33WNrngwAQUjHwDFtdDuKKYIZX/9D/SMOSB8SRNSGe
 RMHpKPh/tayrlnmUcd6pMuu1235va/TAKgqyBwaSdwACTbAqcQ
 km7sxSf4hCIa4xb61ASHcyaowzY/M/KsxPXIcmYA7qejAX0y1/
 lweFeIe+ywhlizfewRrAGGtK73l/wMgJUsDjOUz5T7EDbJ/pnc
 +jr+aH4b7+frnc6s90n6Dh5bOcHxX+j44au6mN0fqX5X7Ky+p4
 YZvQomTyP81GfM1Da5vnu324uvMztE5s+SZOLuSMmHCbx0+l9G
 PISnTgq6CrxnRGewNF29AuE2mM1tpIucp7G/i5jWD1X3BMx+3M
 47Ezmo8Mdwujo+AaFCPQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 18:48:21 Liviu Dudau wrote:
> > > > > These are the functions I found that refer to pci_sys_data on arm32:
> > > > > 
> > > > > pcibios_add_bus
> > > > > pcibios_remove_bus
> 
> These are only needed if you want to do per HB processing of the bus
> 
> > > > > pcibios_align_resource
> 
> mvebu is the only user of this function.
> 
> > > > > pci_mmap_page_range
> 
> This is only needed when mapping a PCI resource to userspace. Is that your case here?
> 
> > > > > pci_domain_nr
> > > > > pci_proc_domain
> 
> We have equivalent functionality in the generic patches for those.
> 

We clearly don't need those functions for the new drivers, but that's not
the point. The problem is that when you build a kernel that has both
a traditional host bridge driver and a new one in it, you always get those
functions and they get called from the PCI core, with incorrect arguments.

	Arnd
