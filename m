Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab3FCX3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:29:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:13029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab3FCX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:29:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,795,1363158000"; 
   d="scan'208";a="344273943"
Date: Mon, 3 Jun 2013 16:29:42 -0700
From: Jon Mason <jon.mason@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmatest: add ability to disable pq and xor
Message-ID: <20130603232941.GC18220@jonmason-lab>
References: <1368813243-29547-1-git-send-email-jon.mason@intel.com>
 <CAHp75VfABzMAg7Ue+Mj_wsnXWsCzJrNH1HR-nbAQq5A2i9ncyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfABzMAg7Ue+Mj_wsnXWsCzJrNH1HR-nbAQq5A2i9ncyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:22:10AM +0300, Andy Shevchenko wrote:
> On Fri, May 17, 2013 at 8:54 PM, Jon Mason <jon.mason@intel.com> wrote:
> > dmatest would create a thread to stress XOR and PQ, if the capability is
> > present in the hardware.  Add the ability to disable XOR and PQ by
> > disabling it if *_sources are set to zero.
> 
> Sorry, didn't comment this earlier.
> 
> Those threads are independent including MEMCPY stuff.
> I think it's better to have one additional parameter let's say
> type_of_test where you can set
> 1 for MEMCPY
> 2 for XOR
> 4 for PQ
> 
> Share this parameter via debugfs and use 0x07 as default value.
> I doubt we need this as a module parameter.

This is using the existing module parameter, so there is nothing new
added.  Since the testing is started immediately upon module
insertion, there needs to be a way to prevent it from ever starting.

Thanks,
Jon

> 
> --
> With Best Regards,
> Andy Shevchenko
