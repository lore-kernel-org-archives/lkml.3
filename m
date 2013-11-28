Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3K1G5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:57:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:44553 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab3K1G5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="416360345"
Date: Thu, 28 Nov 2013 11:30:03 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Olof Johansson <olof@lixom.net>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap
 data
Message-ID: <20131128060003.GN8834@intel.com>
References: <1385528004-19423-1-git-send-email-olof@lixom.net>
 <CAPcyv4hCO62DFA0DO0pH2JO+nEPFT2ZmjG=E5=AJTYrtUACr_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hCO62DFA0DO0pH2JO+nEPFT2ZmjG=E5=AJTYrtUACr_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:55:01AM -0800, Dan Williams wrote:
> On Tue, Nov 26, 2013 at 8:53 PM, Olof Johansson <olof@lixom.net> wrote:
> > commit d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> > added a generic unmap call but used the wrong argument for it. Fix it.
> >
> > Fixes: d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > ---
> >
> > I can't actually tell what the intent of d38a8cc622a1b and how mappings
> > are expected to be managed, but it's obviously passing the wrong thing
> > in here so it seems like the appropriate fix.
> >
> 
> For most dma-slave usage cases the client is explicitly handling the
> lifetime of the dma mappings.  It's primarily the mem-to-mem usage
> cases that rely on the dma driver to do the unmapping when the
> transaction is complete.  dma_descriptor_unmap() is a common
> implementation rather than requiring each driver to implement it
> uniquely.  Longer term we can require all clients to handle their
> mapping lifetimes and remove the responsibility from the individual
> drivers completely.
I think that would make sense and also remove any abuiguity on who does the
mapping in different usages..

~Vinod
