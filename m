Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3DEE13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:27:29 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:45163 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEE11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:27:27 -0400
Message-ID: <515E52A1.2080704@synopsys.com>
Date: Fri, 5 Apr 2013 09:57:13 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Christian Ruppert <christian.ruppert@abilis.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Add implicit barriers to irqsave/restore class of functions
References: <20130403130340.GA13826@ab42.lan>  <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com> <1365091982.2609.97.camel@laptop>
In-Reply-To: <1365091982.2609.97.camel@laptop>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 04/04/2013 09:43 PM, Peter Zijlstra wrote:
> -       : "cc");
> +       : "memory", "cc");
> That's not a memory barrier, that a memory clobber, aka a compiler
> barrier.

For the problem under consideration we indeed want a compiler barrier because the
error shows up due to a stale register which is live across a spinlock for
!PREEMPT_COUNT config.

However IMO doing this in irq save/restore macros is semantically incorrect since
those macros might be used elsewhere which don't need the compiler reload reg
semantics. Further per tglx' suggestion fixing preempt_* macros for !PREEMPT_COUNT
case would fix this independent of what arch is doing.

A patch to that effect was already posted to lists:
http://www.spinics.net/lists/kernel/msg1510885.html
Please let us know what you think.

Thx,
-Vineet


