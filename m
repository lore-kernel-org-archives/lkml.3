Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973Ab3BOPue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:50:34 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34357 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3BOPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:50:32 -0500
Date: Fri, 15 Feb 2013 16:50:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130215155028.GC3324@gmail.com>
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com>
 <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Paul? Apparently you end up with a dead machine at least 
> during resume and no oops. Which isn't very helpful. Maybe 
> there is possibly some BUG_ON() in the RCU code somewhere?

AFAICS there's no BUG_ON() or panic() in the RCU code, outside 
early init code allocation failure paths where we genuinely 
can't continue.

( Unless it _is_ one of those BUG_ON()s triggering during early 
  resume, reconstructing kernel threads, or the BUG_ON() comes 
  in indirectly via some other way ... )

Dave, one thing that might be worth trying is to disable 
CONFIG_BUG and see whether the system manages to limp through to 
get console output?

Thanks,

	Ingo
