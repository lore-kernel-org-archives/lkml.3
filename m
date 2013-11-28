Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3K1FkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:40:22 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:59229 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751074Ab3K1FkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:40:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:45:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2551:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:7652:7903:8604:8784:9108:9393:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12114:12295:12296:12438:12517:12519:12663:12740:13161:13200:13229:13548,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stamp60_1f446427a364a
X-Filterd-Recvd-Size: 3035
Message-ID: <1385617213.12210.5.camel@joe-AO722>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Date: Wed, 27 Nov 2013 21:40:13 -0800
In-Reply-To: <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
	 <20131128040750.GA29917@kroah.com>
	 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> > On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> > > This macro is used to create a struct pci_device_id array.
> > 
> > Yeah, and it's a horrid macro that deserves to be removed, please don't
> > use it in more places.
> > 
> > Actually, if you could just remove it, that would be best, sorry, I'm
> > not going to take these patches.
> 
> (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> 
> Hi Joe Perches,
> 
> Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> as below.
> 
>   WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
>   #331: FILE: drivers/usb/host/ehci-pci.c:331:
>   +static const struct pci_device_id pci_ids [] = { {
> 
> However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> shouldn't be used anymore.
> 
> So, would you change checkpatch.pl in order to guide to use
> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> 
> For example,
>   WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE

The documentation doesn't agree with Greg.

Documentation/PCI/pci.txt:

The ID table is an array of struct pci_device_id entries ending with an
all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
method of declaring the table.

Neither does the kernel tree:

$ git grep -w DEFINE_PCI_DEVICE_TABLE | wc -l
410

$ git grep -E "\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*=" | wc -l
376

Most of the 376 should be const and are not.

$ git grep -E "\bconst\s+struct\s+pci_device_id\s+\w+\s*\[\s*\]\s*=" | wc -l
155

Everything that uses DEFINE_PCI_DEVICE_TABLE is const.

$ git grep -A1 -E "define\s+DEFINE_PCI_DEVICE_TABLE"
include/linux/pci.h:#define DEFINE_PCI_DEVICE_TABLE(_table) \
include/linux/pci.h-    const struct pci_device_id _table[]


