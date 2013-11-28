Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab3K1Fwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:52:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3K1Fwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:52:38 -0500
Date: Wed, 27 Nov 2013 21:53:28 -0800
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131128055328.GA565@kroah.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
 <20131128040750.GA29917@kroah.com>
 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
 <1385617213.12210.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385617213.12210.5.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> > On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> > > On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> > > > This macro is used to create a struct pci_device_id array.
> > > 
> > > Yeah, and it's a horrid macro that deserves to be removed, please don't
> > > use it in more places.
> > > 
> > > Actually, if you could just remove it, that would be best, sorry, I'm
> > > not going to take these patches.
> > 
> > (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> > 
> > Hi Joe Perches,
> > 
> > Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> > Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> > as below.
> > 
> >   WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> >   #331: FILE: drivers/usb/host/ehci-pci.c:331:
> >   +static const struct pci_device_id pci_ids [] = { {
> > 
> > However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> > shouldn't be used anymore.
> > 
> > So, would you change checkpatch.pl in order to guide to use
> > struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> > 
> > For example,
> >   WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> 
> The documentation doesn't agree with Greg.
> 
> Documentation/PCI/pci.txt:
> 
> The ID table is an array of struct pci_device_id entries ending with an
> all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> method of declaring the table.

Then it should be fixed.

> Neither does the kernel tree:
> 
> $ git grep -w DEFINE_PCI_DEVICE_TABLE | wc -l
> 410
> 
> $ git grep -E "\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*=" | wc -l
> 376
> 
> Most of the 376 should be const and are not.
> 
> $ git grep -E "\bconst\s+struct\s+pci_device_id\s+\w+\s*\[\s*\]\s*=" | wc -l
> 155

Then fix those and make them const.

Hiding structures behind an odd (and misnamed) macro isn't the best
thing.

> Everything that uses DEFINE_PCI_DEVICE_TABLE is const.
> 
> $ git grep -A1 -E "define\s+DEFINE_PCI_DEVICE_TABLE"
> include/linux/pci.h:#define DEFINE_PCI_DEVICE_TABLE(_table) \
> include/linux/pci.h-    const struct pci_device_id _table[]

I say just remove it, I should have done that years ago when I was the
PCI maintainer, just never got around to it.  No other bus has something
like this for their device ids, why should PCI be "special"?

thanks,

greg k-h
