Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3LMCL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:26 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35806 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab3LMCLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:11:12 -0500
Message-ID: <52AA6CB9.60302@linaro.org>
Date: Fri, 13 Dec 2013 10:11:05 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de> <20131212131309.GD5806@gmail.com> <52A9BC3A.7010602@linaro.org> <20131212141147.GB17059@gmail.com> <52AA5C92.7030207@linaro.org>
In-Reply-To: <52AA5C92.7030207@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:02 AM, Alex Shi wrote:
>> > You have not replied to this concern of mine: if my concern is valid 
>> > then that invalidates much of the current tunings.
> The benefit from pretend flush range is not unconditional, since invlpg
> also cost time. And different CPU has different invlpg/flush_all
> execution time. 

TLB refill time is also different on different kind of cpu.

BTW,
A bewitching idea is till attracting me.
https://lkml.org/lkml/2012/5/23/148
Even it was sentenced to death by HPA.
https://lkml.org/lkml/2012/5/24/143

That is that just flush one of thread TLB is enough for SMT/HT, seems
TLB is still shared in core on Intel CPU. This benefit is unconditional,
and if my memory right, Kbuild testing can improve about 1~2% in average
level.

So could you like to accept some ugly quirks to do this lazy TLB flush
on known working CPU?
Forgive me if it's stupid.

-- 
Thanks
    Alex
