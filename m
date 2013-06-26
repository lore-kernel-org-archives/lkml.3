Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3FZQkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:40:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37754 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3FZQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:40:29 -0400
Date: Wed, 26 Jun 2013 18:40:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Message-ID: <20130626164027.GE6123@two.firstfloor.org>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
 <20130626115420.GG28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626115420.GG28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So on pretty much every program you'd be lucky to get the top of the
> callstack but can end up with nearly nothing.

The last few entries up are usually the interesting ones, and those will
be preserved.

Do you really care about main() for profiling?

When you pop back up there may be a few situations where you
have a very small visible stack, but as soon as the program
starts nesting deeper again that will be fixed.

> Given that, and the other limitations I don't think its a fair
> replacement for user callchains.

It's not intended to be a full replacement, just to cover
cases that cannot give you callgraphs at all today.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
