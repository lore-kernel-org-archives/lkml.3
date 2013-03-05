Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3CELAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:00:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:4835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3CELAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="scan'208";a="299215109"
Date: Tue, 5 Mar 2013 16:05:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/10] dmatest: run test via debugfs
Message-ID: <20130305103525.GB13370@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1362388174-3435-7-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130305092649.GD28136@intel.com>
 <1362479804.28241.114.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362479804.28241.114.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:36:44PM +0200, Andy Shevchenko wrote:
> On Tue, 2013-03-05 at 14:56 +0530, Vinod Koul wrote: 
> > On Mon, Mar 04, 2013 at 11:09:30AM +0200, Andy Shevchenko wrote:
> > > @@ -0,0 +1,48 @@
> > > +				DMA Test Guide
> > > +				==============
> > > +
> > > +		Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > +
> > > +This small document introduces how to test DMA drivers using dmatest module.
> > > +
> > > +	Part 1 - How to build the test module
> > > +
> > > +The menuconfig contains an option that could be found by following path:
> > > +	Device Drivers -> DMA Engine support -> DMA Test client
> > > +
> > > +In the configuration file the option called CONFIG_DMATEST. The dmatest could
> > > +be built as module or inside kernel. Let's consider those cases.
> > > +
> > > +	Part 2 - When dmatest is built as a module...
> > > +
> > > +After mounting debugfs and loading the module, the /sys/kernel/debug/dmatest
> > > +folder with nodes will be created. They are the same as module parameters with
> > > +addition of the 'run' node that controls run and stop phases of the test.
> > > +
> > > +Note that in this case test will not run on load automatically.
> > > +
> > > +Example of usage:
> > > +	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
> > > +	% echo 2000 > /sys/kernel/debug/dmatest/timeout
> > > +	% echo 1 > /sys/kernel/debug/dmatest/iterations
> > > +	% echo 1 > /sys/kernel/debug/dmatest/run
> > How do you terminate a test? Esp if you have started bunch of concurent tests
> > and want to terminate one of them...
> 
> There is only one test in progress is possible.
Wasnt the idea to run concurrent tests, or I read wrongly...

--
~Vinod
