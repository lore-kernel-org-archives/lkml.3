Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3EWK7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:59:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:16157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab3EWK7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:59:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,727,1363158000"; 
   d="scan'208";a="318316333"
Date: Thu, 23 May 2013 15:52:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "djbw @ fb . com" <djbw@fb.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel @ lists . infradead . org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: [PATCH] dmatest: abort transfers immediately when asked for
Message-ID: <20130523102248.GC30200@intel.com>
References: <20130516153553.GI11706@mudshark.cambridge.arm.com>
 <1369139597-24446-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130521151143.GH10453@mudshark.cambridge.arm.com>
 <CAHp75VdRn8baf0ak57HpoJKNues6vEsjBp1uOQ2Zpvwa+B5rjA@mail.gmail.com>
 <20130523100932.GA30200@intel.com>
 <CAHp75Vf58kq0t7+et9i54fxjEdQfBrTWxji4xk_MS-fZgWGOdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf58kq0t7+et9i54fxjEdQfBrTWxji4xk_MS-fZgWGOdQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 01:51:29PM +0300, Andy Shevchenko wrote:
> On Thu, May 23, 2013 at 1:09 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, May 21, 2013 at 08:24:15PM +0300, Andy Shevchenko wrote:
> >> On Tue, May 21, 2013 at 6:11 PM, Will Deacon <will.deacon@arm.com> wrote:
> >> > On Tue, May 21, 2013 at 01:33:17PM +0100, Andy Shevchenko wrote:
> >> >> When thread is going to be stopped we have to unconditionally terminate all
> >> >> ongoing transfers. Otherwise it would be possible that callback function will
> >> >> be called on the next interrupt and will try to access to already freed
> >> >> structures.
> >> >>
> >> >> The patch introduces specific error message for this, though it doesn't
> >> >> increase the counter of the failed tests.
> >> >>
> >> > Thanks for persevering with this! Although this patch definitely fixes the
> >> > panic I was seeing, I now observe buffer verification failures in subsequent
> >> > test runs after an aborted run:
> >>
> >> I think the description to the commit adfa543e "dmatest: don't use
> >> set_freezable_with_signal()" may shed light on this.
> >>
> >> The background (if  I got it correctly) is in race with done flag. So,
> >> we got a callback call from the DMA engine, but we don't know which
> >> transfer triggers it.
> >> I might be wrong. This is just an assumption.
> >>
> >> Have you ever see such behaviour on pre v3.10-rc1 kernels? (I mean
> >> with old dmatest module)
> > Terminate shouldnt cause the issue with buffer verfication, can you try this on
> > dw_dmac, do you see similar failures on verfication?
> 
> I saw the similar errors on dw_dmac on Intel Medfield device.
Ah, so may not be a driver issue.

> Anyway, I checked another approach with Will.
> For now I will send a quick fix that prevents tester to abort an
> ongoing transfer.
okay so taht should prevent regression, let me check on my setup if I find
anything

--
~Vinod
> In future we could implement a robust logic when transfers can be
> interrupted at any time.
> 
> -- 
> With Best Regards,
> Andy Shevchenko
