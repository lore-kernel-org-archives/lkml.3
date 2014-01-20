Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaATNIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:08:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:1087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaATNIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:08:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,690,1384329600"; 
   d="scan'208";a="461627734"
Date: Mon, 20 Jan 2014 17:37:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Message-ID: <20140120120714.GF26823@intel.com>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
 <20131210101025.GF29580@intel.com>
 <1386676582.1871.137.camel@smile>
 <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
 <20131218154955.GF16227@intel.com>
 <1387450289.1871.240.camel@smile>
 <20140120092501.GS26823@intel.com>
 <1390222075.7619.29.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390222075.7619.29.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 06:17:56PM +0530, Shevchenko, Andriy wrote:
> On Mon, 2014-01-20 at 14:55 +0530, Vinod Koul wrote:
> > On Thu, Dec 19, 2013 at 12:51:29PM +0200, Andy Shevchenko wrote:
> > > On Wed, 2013-12-18 at 21:19 +0530, Vinod Koul wrote:
> > > > On Mon, Dec 16, 2013 at 01:51:47PM +0530, Chew, Chiau Ee wrote:
> > > 
> > > > > As mentioned by Andy, we are using *_noirq  verion of suspend/resume PM
> > > > > callback whereby the callbacks would be executed after IRQ handlers have been
> > > > > disabled. If using SET_SYSTEM_SLEEP_PM_OPS, it would be the normal
> > > > > suspend/resume PM callback. Looking at the Desginware DMAC platform code
> > > > > (drivers/dma/dw/platform.c), it is using the *_noirq suspend/resume PM
> > > > > callback. Is it advisable to use the normal suspend/resume PM callback instead
> > > > > of *_noirq suspend/PM callback? 
> > > > 
> > > > i dont see a reason why we need the noirq versions
> > > 
> > > Okay. I imagine the following use case.
> > > 
> > > For example we have compiled in DMA driver (dw_dmac) along with, for
> > > example, SPI driver.
> > > 
> > > System was scheduled to go sleep.
> > > 
> > > An order of calling IIUC might be DMA first, then SPI (since they are
> > > not in parent / child relations).
> > > 
> > > What was happened when SPI would like to do a DMA transfer and DMA is
> > > going to sleep? I'm trying to understand if this is a case.
> > In that case how does no irq version help us?
> 
> It guarantees that we have no user of DMA anymore, since there is no
> interrupt going on.
well how is that. It will gaurantee that there wont be interrupt. User can still
submit a transaction or another transaction will be in progress...

> > For these cases, I have been using suspend_late. Since the dmaengine driver is
> > providing service to other clients (SPI), it needs to esnure that it suspends
> > after SPI using suspend_late and resume using resume_early. That way dma is
> > availble whenever the client is active
> 
> suspend_late is working in context that interrupt handler may be
> invoked. Thus, to have DMA driver be properly shut down we have to
> wait / terminate possible ongoing transfer.
Well client is already suspended via .suspend. So where is the transaction :)
> 
> It seems for me all DMA drivers that are using
> system .suspend()/.resume() are potentially buggy.
Yup!

-- 
~Vinod
