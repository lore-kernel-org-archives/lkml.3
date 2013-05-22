Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3EVMly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:41:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38900 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab3EVMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:41:53 -0400
Date: Wed, 22 May 2013 13:41:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, "djbw @ fb . com" <djbw@fb.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel @ lists . infradead . org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: [PATCH] dmatest: abort transfers immediately when asked for
Message-ID: <20130522124112.GA16361@mudshark.cambridge.arm.com>
References: <20130516153553.GI11706@mudshark.cambridge.arm.com>
 <1369139597-24446-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130521151143.GH10453@mudshark.cambridge.arm.com>
 <CAHp75VdRn8baf0ak57HpoJKNues6vEsjBp1uOQ2Zpvwa+B5rjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdRn8baf0ak57HpoJKNues6vEsjBp1uOQ2Zpvwa+B5rjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 06:24:15PM +0100, Andy Shevchenko wrote:
> On Tue, May 21, 2013 at 6:11 PM, Will Deacon <will.deacon@arm.com> wrote:
> > Hi Andy,
> >
> > On Tue, May 21, 2013 at 01:33:17PM +0100, Andy Shevchenko wrote:
> >> When thread is going to be stopped we have to unconditionally terminate all
> >> ongoing transfers. Otherwise it would be possible that callback function will
> >> be called on the next interrupt and will try to access to already freed
> >> structures.
> >>
> >> The patch introduces specific error message for this, though it doesn't
> >> increase the counter of the failed tests.
> >>
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Reported-by: Will Deacon <will.deacon@arm.com>
> >
> > Thanks for persevering with this! Although this patch definitely fixes the
> > panic I was seeing, I now observe buffer verification failures in subsequent
> > test runs after an aborted run:
> 
> I think the description to the commit adfa543e "dmatest: don't use
> set_freezable_with_signal()" may shed light on this.
> 
> The background (if  I got it correctly) is in race with done flag. So,
> we got a callback call from the DMA engine, but we don't know which
> transfer triggers it.
> I might be wrong. This is just an assumption.

I've not managed to work out exactly what's going on, but it's certainly
something like that. In fact, I just managed to trigger a case where all but
one of the transfers is aborted, whilst the remaining one fails. Looking at
the code, I can't see how that situation comes about, since the threads are
protected with the info mutex and kthread_stop is synchronous.

> Have you ever see such behaviour on pre v3.10-rc1 kernels? (I mean
> with old dmatest module)

No, dmatest from 3.9 is completely reliable in my experience.

Will
