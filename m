Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3JIM1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:27:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3JIM1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:27:18 -0400
Date: Wed, 9 Oct 2013 14:27:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009122705.GG3081@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009121911.GA18770@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009121911.GA18770@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:19:11PM +0800, Fengguang Wu wrote:
> > > Fengguang, I do not think this will help, but just in case. Could you
> > > show the result of
> > > 
> > >         $ kernel/task_work.s
> 
> Update: I recompiled the kernel with gcc 4.4.7 and find it booting fine!

> # 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
> 	bts $1, 8(%eax); setc %dl	#,, c

That compiler doesn't appear to have asm goto support, so we fall back
to the code we already knew worked :-)
