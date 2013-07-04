Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3GDOBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:01:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3GDOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:01:46 -0400
Date: Thu, 4 Jul 2013 16:00:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
Message-ID: <20130704140057.GN18898@dyad.programming.kicks-ass.net>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
 <20130704095735.GL18898@dyad.programming.kicks-ass.net>
 <20130704134457.GS6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704134457.GS6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 03:44:57PM +0200, Andi Kleen wrote:
> Evidently it's not read-only on Haswell at least.

It would be ever so good if you could at least test run such patches against
semi-current chips, not only the very latest.

> And if we don't restore the TOS it can be completely wrong, and
> the stack state would corrupt.

How so? You could simply write into idx := (tos + i) % nr_lbr ?

> The LBR stack is quite sensitive to any corruption of the state,
> that is different from other LBR uses.
> 
> I suppose the wrmsr could be made checking to catch any potential
> failure. But normally Intel CPUs are quite consistent in things
> like that.

Please verify with the appropriate hardware teams and update the SDM
accordingly. This code is used with all Intel CPUs that have LBR support, which
is pretty much all of them except Yonah.

Using a checking wmsr isn't really a nice option; esp as this is in a somewhat
time critical path.

