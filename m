Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaAWKd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:33:29 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46861 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbaAWKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:33:24 -0500
Date: Thu, 23 Jan 2014 10:32:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: Re: [PATCH v2 5/7] ARM: perf_event: Fully support Krait CPU PMU
 events
Message-ID: <20140123103216.GC5466@mudshark.cambridge.arm.com>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
 <1389808535-23852-6-git-send-email-sboyd@codeaurora.org>
 <20140121180711.GN30706@mudshark.cambridge.arm.com>
 <52DEBE6B.7000904@codeaurora.org>
 <52E02E7E.4050203@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E02E7E.4050203@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:47:58PM +0000, Stephen Boyd wrote:
> On 01/21/14 10:37, Stephen Boyd wrote:
> > On 01/21/14 10:07, Will Deacon wrote:
> >> Do you need isbs to ensure the pmresrn side-effects have happened, or are
> >> the registers self-synchronising? Similarly for your other IMP DEF
> >> registers.
> > There aren't any isbs in the downstream android sources so I assume
> > they're self synchronizing. I'll confirm with the CPU designers to make
> > sure.
> >
> 
> CPU folks say no need for isb.

Good, good!

> They mentioned that the lack of an isb after the
> armv7_pmnc_enable_counter() call will leave the action of enabling the
> counter "in-flight". The window is probably pretty short on an SMP kernel
> because of the spin_unlock right after with the barriers in it, but the
> same can't be said for a UP kernel.

Yep, we rely on the exception return for that.

> Also, the fuzzer didn't find anything else, but I found a bug in the
> bitmap logic, updated and reran the fuzzer this morning. Everything
> looks good.

Okey doke, I guess if you can repost at -rc1 then I can look at pulling
this into my tree.

Cheers,

Will
