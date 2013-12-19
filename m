Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3LSKwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:52:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:63716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3LSKwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:52:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="446895084"
Message-ID: <1387450289.1871.240.camel@smile>
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Dec 2013 12:51:29 +0200
In-Reply-To: <20131218154955.GF16227@intel.com>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com> <1386676582.1871.137.camel@smile>
	 <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
	 <20131218154955.GF16227@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 21:19 +0530, Vinod Koul wrote:
> On Mon, Dec 16, 2013 at 01:51:47PM +0530, Chew, Chiau Ee wrote:

> > As mentioned by Andy, we are using *_noirq  verion of suspend/resume PM
> > callback whereby the callbacks would be executed after IRQ handlers have been
> > disabled. If using SET_SYSTEM_SLEEP_PM_OPS, it would be the normal
> > suspend/resume PM callback. Looking at the Desginware DMAC platform code
> > (drivers/dma/dw/platform.c), it is using the *_noirq suspend/resume PM
> > callback. Is it advisable to use the normal suspend/resume PM callback instead
> > of *_noirq suspend/PM callback? 
> 
> i dont see a reason why we need the noirq versions

Okay. I imagine the following use case.

For example we have compiled in DMA driver (dw_dmac) along with, for
example, SPI driver.

System was scheduled to go sleep.

An order of calling IIUC might be DMA first, then SPI (since they are
not in parent / child relations).

What was happened when SPI would like to do a DMA transfer and DMA is
going to sleep? I'm trying to understand if this is a case.

> > > How about SET_SYSTEM_SLEEP_PM_OPS instead?
> > 
> > So, we are using *_noirq versions of the functions here. What happened when we switch to normal ones? Any side effects?



-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

