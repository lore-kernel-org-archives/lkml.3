Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3E0HLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:11:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:6267 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab3E0HLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,749,1363158000"; 
   d="scan'208";a="343817871"
Message-ID: <1369638667.29283.197.camel@smile>
Subject: Re: [PATCH] dmatest: do not allow to interrupt ongoing tests
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Will Deacon <will.deacon@arm.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, djbw@fb.com
Date: Mon, 27 May 2013 10:11:07 +0300
In-Reply-To: <Pine.LNX.4.64.1305242353210.7187@axis700.grange>
References: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <Pine.LNX.4.64.1305242353210.7187@axis700.grange>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 23:55 +0200, Guennadi Liakhovetski wrote: 
> On Thu, 23 May 2013, Andy Shevchenko wrote:
> 
> > When user interrupts ongoing transfers the dmatest may end up with console
> > lockup, oops, or data mismatch. This patch prevents user to abort any ongoing
> > test.
> 
> Personally I would be against such a change. What about interrupting the 
> test with rmmod?
>  Is it still possible after this your patch or not? If not 
> - this doesn't seem like a good idea to me. Why don't we just fix those 
> bugs, that you're describing?

The behaviour of the module is returned to the same page by this patch
as it was before (w/o debugfs).

The user can interrupt tests by rmmod, but it will take time up to
timeout.

I appreciate if you can do a deeper analysis of what happened in
case Will reported.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
