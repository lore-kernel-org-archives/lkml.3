Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FGIpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:45:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49946 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab3FGIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:45:48 -0400
Date: Fri, 7 Jun 2013 09:44:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH] dmatest: do not allow to interrupt ongoing tests
Message-ID: <20130607084458.GA3132@mudshark.cambridge.arm.com>
References: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <Pine.LNX.4.64.1305242353210.7187@axis700.grange>
 <1369638667.29283.197.camel@smile>
 <20130605171001.GC26663@mudshark.cambridge.arm.com>
 <20130607004525.GH23045@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607004525.GH23045@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 01:45:25AM +0100, Vinod Koul wrote:
> On Wed, Jun 05, 2013 at 06:10:01PM +0100, Will Deacon wrote:
> > On Mon, May 27, 2013 at 08:11:07AM +0100, Andy Shevchenko wrote:
> > > On Fri, 2013-05-24 at 23:55 +0200, Guennadi Liakhovetski wrote: 
> > > > On Thu, 23 May 2013, Andy Shevchenko wrote:
> > > > 
> > > > > When user interrupts ongoing transfers the dmatest may end up with console
> > > > > lockup, oops, or data mismatch. This patch prevents user to abort any ongoing
> > > > > test.
> > > > 
> > > > Personally I would be against such a change. What about interrupting the 
> > > > test with rmmod?
> > > >  Is it still possible after this your patch or not? If not 
> > > > - this doesn't seem like a good idea to me. Why don't we just fix those 
> > > > bugs, that you're describing?
> > > 
> > > The behaviour of the module is returned to the same page by this patch
> > > as it was before (w/o debugfs).
> > > 
> > > The user can interrupt tests by rmmod, but it will take time up to
> > > timeout.
> > > 
> > > I appreciate if you can do a deeper analysis of what happened in
> > > case Will reported.
> > 
> > Did this query hold up the application of this patch? I'd really like to see
> > *something* in 3.10, otherwise dmatest will be broken.
> I though we had some data corruption on subsequent tests, or was that different
> one?

We ended up with something that worked in the end:

  https://lkml.org/lkml/2013/5/23/196

Will
