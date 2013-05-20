Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3ETJ7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:59:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab3ETJ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:59:37 -0400
Date: Mon, 20 May 2013 10:58:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.jf.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: dmatest regression in 3.10-rc1
Message-ID: <20130520095857.GI31359@mudshark.cambridge.arm.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
 <20130516153553.GI11706@mudshark.cambridge.arm.com>
 <20130517123423.GR14863@intel.com>
 <20130517141857.GM23112@mudshark.cambridge.arm.com>
 <1369036354.29283.115.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369036354.29283.115.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, May 20, 2013 at 08:52:34AM +0100, Andy Shevchenko wrote:
> On Fri, 2013-05-17 at 15:18 +0100, Will Deacon wrote: 
> > On Fri, May 17, 2013 at 01:34:23PM +0100, Vinod Koul wrote:
> > > On Thu, May 16, 2013 at 04:35:53PM +0100, Will Deacon wrote:
> > > > Right, so I think I understand what's causing this, but I'll leave it to
> > > > Andriy to suggest a fix.
> 
> Thanks for the report.
> 
> Unfortunately neither me nor other guys in the team could not reproduce
> mentioned issue on our hardware.
> Nevertheless I will try to allocate time and suggest possible fix if any
> comes to my mind. So, your testing and analysis is appreciated.

Sure. They way I trigger it is to unload the module whilst the DMA is
ongoing (I'm using a software model, so I can make the DMA nice and slow --
I guess you could try using some large buffers).

My script (I just run from busybox) is:

  #!/bin/sh

  mount proc -t proc /proc
  mount sysfs -t sysfs /sys
  mount debugfs -t debugfs /sys/kernel/debug

  echo 9 > /proc/sysrq-trigger

  modprobe dmatest
  echo 8 > /sys/kernel/debug/dmatest/iterations
  echo 8 > /sys/kernel/debug/dmatest/threads_per_chan
  echo 131072 > /sys/kernel/debug/dmatest/test_buf_size
  echo 1 > /sys/kernel/debug/dmatest/run
  modprobe -r dmatest

Will
