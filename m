Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaEQAqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:46:25 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45988 "EHLO
	new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaEQAqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:46:24 -0400
Message-Id: <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
X-Sasl-Enc: qzYaDu0kwj89nX8dOmL41QL8ZTkudBs2uL/wJy8g9tud 1400287582
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        tytso@mit.edu, price@mit.edu
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-988d4021
In-Reply-To: <20140516162117.GY11096@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
 <20140516162117.GY11096@twins.programming.kicks-ass.net>
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
Date: Fri, 16 May 2014 17:46:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014, at 9:21, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 09:06:13AM -0700, H. Peter Anvin wrote:
> > On 05/16/2014 08:34 AM, Peter Zijlstra wrote:
> > > 
> > > While fuzzing to reproduce my issue I hit the below, its triggered loads
> > > of times and then the machine wedged (needed a power cycle), I can
> > > provide the full console log if people care.
> > > 
> > > Anybody seen that one before?
> > > 
> > 
> > I certainly haven't... this bad.  Any idea what the actual system call
> > looked like?
> 
> Sadly, no, while I had syscall tracing enabled, the bug I'm chasing is
> non fatal so I hadn't set it to dump on bug -- not that dumping 24*1.4M
> trace buffers over serial would've completed this side of the century.
> 
> I did save the trinity output (including seeds) but my experience so far
> is that that is no guarantee for reproduction.

This should do the trick:
dd if=/dev/urandom of=/dev/zero bs=67108707

I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
culprit.

Bye,

  Hannes
