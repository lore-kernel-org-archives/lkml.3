Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3LDMtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:49:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:4133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab3LDMtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:49:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,824,1378882800"; 
   d="scan'208";a="444460667"
Message-ID: <1386161310.1871.62.camel@smile>
Subject: Re: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Koul, Vinod'" <vinod.koul@intel.com>,
        "'Williams, Dan J'" <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Jonas Bonn'" <jonas@southpole.se>
Date: Wed, 04 Dec 2013 14:48:30 +0200
In-Reply-To: <001501cef086$78d015f0$6a7041d0$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	 <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
	 <1386072642.1871.46.camel@smile>
	 <001501cef086$78d015f0$6a7041d0$%han@samsung.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 09:19 +0900, Jingoo Han wrote:
> On Tuesday, December 03, 2013 9:11 PM, Shevchenko, Andriy wrote:
> > On Tue, 2013-12-03 at 08:05 +0900, Jingoo Han wrote:
> > > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > > is not preferred.
> > 
> > I'm sorry, but Documentation/PCI/pci.txt still says "is the preferred
> > method".
> > 
> > Is there any link to patch for Documentation and discussion why change
> > is established?
> 
> (+cc Joe Perches, Jonas Bonn)
> 
> Since last week, there has been discussion about this.
> There is no special reason to use DEFINE_PCI_DEVICE_TABLE macro.
> 
> According to the Greg Kroah-Hartman,
> "Yeah, and it's a horrid macro that deserves to be removed,
> please don't use it in more places."
> 
> Currently, there is no other bus that has something like this
> macro for their device ids. Thus, DEFINE_PCI_DEVICE_TABLE macro
> should be removed.
> 
> Jonas Bonn (author of DEFINE_PCI_DEVICE_TABLE macro) also agreed
> to remove this macro. According to Jonas Bonn,
> "Actually, I think I submitted an even uglier macro called 
> DECLARE_PCI_DEVICE_TABLE... might have been the first kernel
> Patch I  ever sent?  In any case, it should certainly have been
> kindly rejected."
> 
> After Joe Perches's patch[1] is merged, I will send these patches
> to each subsystem maintainer.
> 
> [1][PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
>     (http://lkml.org/lkml/2013/12/2/400)
> 
> In this patch, Joe Perches fixed 'Documentation/PCI/pci.txt', and
> 'scripts/checkpatch.pl', in order to guide to use 'struct pci_device_id'
> instead of 'DEFINE_PCI_DEVICE_TABLE' macro.

Thanks for the detailed explanation!

Thus, give you my 

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for drivers/dma/dw/ part.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

