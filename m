Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3LTLNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:13:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab3LTLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:13:09 -0500
Date: Fri, 20 Dec 2013 11:13:03 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131220111303.GZ11295@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
 <CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
 <20131215155539.GM11295@suse.de>
 <20131216102439.GA21624@gmail.com>
 <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131219142405.GM11295@suse.de>
 <20131219164925.GA29546@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131219164925.GA29546@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 05:49:25PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > [...]
> > 
> > Because we lack data on TLB range flush distributions I think we 
> > should still go with the conservative choice for the TLB flush 
> > shift. The worst case is really bad here and it's painfully obvious 
> > on ebizzy.
> 
> So I'm obviously much in favor of this - I'd in fact suggest making 
> the conservative choice on _all_ CPU models that have aggressive TLB 
> range values right now, because frankly the testing used to pick those 
> values does not look all that convincing to me.
> 

I think the choices there are already reasonably conservative. I'd be
reluctant to support merging a patch that made a choice on all CPU models
without having access to the machines to run tests on. I don't see the
Intel people volunteering to do the necessary testing.

-- 
Mel Gorman
SUSE Labs
