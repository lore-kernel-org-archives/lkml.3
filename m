Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3EFTCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:02:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3EFTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:02:01 -0400
Date: Mon, 6 May 2013 21:00:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130506190024.GB17723@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
 <20130501090718.GA28253@dyad.programming.kicks-ass.net>
 <m261z3uipb.fsf@firstfloor.org>
 <20130501111219.GF28253@dyad.programming.kicks-ass.net>
 <CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
 <20130501191342.GH17814@two.firstfloor.org>
 <CABPqkBS7FxoT1fioe_VdBMcLAdZtfwRiMmSMocSY5TB3QAyPQQ@mail.gmail.com>
 <20130502073252.GG7521@dyad.programming.kicks-ass.net>
 <CABPqkBSqs8f9jomytPs5tyXMum1UCwSYHcTDuYwg0c-MTVvEow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSqs8f9jomytPs5tyXMum1UCwSYHcTDuYwg0c-MTVvEow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 07:41:54PM +0200, Stephane Eranian wrote:

> Problem is, those events are really important. We need to be able to
> measure them.

At what cost? If the code we need to make it work is horrendous we need to
maintain that too -- possibly quite a lot longer than Intel thinks IVB is
relevant.

Anyway; since these events are immediately dangerous (they corrupt state)
blocking them is the right thing; we can always merge a patch that undoes that
once we've figured out a sane way.

Currently I'm still waiting for someone to explain (in complete detail) how the
corruption manifests. Until that is clear I can't even begin formulating what
might be needed to make it work again.

One mode that makes sense to me is where CNTx on SMTi corrupts CNTx on SMTj for
i != j. However there's also been said that the only case that doesn't corrupt
is for SMTj to have all counters disabled -- which contradicts the previous
case.

The former case we could maybe make work; the latter I can't see how we could
possible make work at all.
