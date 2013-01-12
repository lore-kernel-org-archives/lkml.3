Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3ALMz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 07:55:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:63530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab3ALMzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 07:55:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,456,1355126400"; 
   d="scan'208";a="271271886"
Date: Sat, 12 Jan 2013 04:30:55 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a
 device in place
Message-ID: <20130112123055.GX19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130109134757.GN19691@intel.com>
 <CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
 <20130109153848.GT19691@intel.com>
 <CAKohpo=8PKk0VF3tpZLNYseHMv7dF-qg9iwKcC+VmPtb_8kzjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=8PKk0VF3tpZLNYseHMv7dF-qg9iwKcC+VmPtb_8kzjg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:04:53PM +0530, Viresh Kumar wrote:
> On 9 January 2013 21:08, Vinod Koul <vinod.koul@intel.com> wrote:
> >> >>  subsys_initcall(dw_init);
> > Viresh, Linus
> >
> > We had this discussion sometime back. pl022 use dma and we need DMA before SPI.
> > So if we have pl022 as late_init and dma as device_init. If we have one  more
> > dependency then moving dw_dmac to fs_init should help too. But arch/subsys seems
> > overkill here?
> 
> We probably can't make spi late_init as they may be others waiting for
> it to be in. And
> so did subsys_init for dma. fs is for filesystem? then that may not be
> logically correct too.
well subsys_init doesnt seem to be logical for dma driver too!

--
~Vinod
