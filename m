Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3LSQtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:49:31 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52237 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3LSQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:49:29 -0500
Date: Thu, 19 Dec 2013 17:49:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131219164925.GA29546@gmail.com>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
 <CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
 <20131215155539.GM11295@suse.de>
 <20131216102439.GA21624@gmail.com>
 <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131219142405.GM11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219142405.GM11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> [...]
> 
> Because we lack data on TLB range flush distributions I think we 
> should still go with the conservative choice for the TLB flush 
> shift. The worst case is really bad here and it's painfully obvious 
> on ebizzy.

So I'm obviously much in favor of this - I'd in fact suggest making 
the conservative choice on _all_ CPU models that have aggressive TLB 
range values right now, because frankly the testing used to pick those 
values does not look all that convincing to me.

I very much suspect that the problem goes wider than just IvyBridge 
CPUs ... it's just that few people put as much testing into it as you.

We can certainly get more aggressive in the future, subject to proper 
measurements.

Thanks,

	Ingo
