Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaATKOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:14:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaATKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:14:10 -0500
Date: Mon, 20 Jan 2014 11:13:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140120101345.GC3694@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <CAJvTdKmdopjSopfHrZRKXJBKqjizrFHich+dQCd6Fq7C3bOogw@mail.gmail.com>
 <20140120083021.GC30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120083021.GC30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:30:21AM +0100, Peter Zijlstra wrote:
> Then make them so. The fact was that most of the mwait idle sites
> were bloody broken. And the single mwait_idle_with_hints() function
> presents a single nice function that does all the required magics.

To stress this a bit more; have a look see at mwwait_idle_with_hints();
it does a whole lot of subtle magic.

 - current_{set,clr}_polling*(), these are crucial in not missing and
   wrecking NEED_RESCHED state.

 - X86_FEATURE_CLFLUSH_MONTIOR quirk

 - Does the monitor(); if (!need_resched()) mwait() thing.

All of those are required for a correct and functional idle loop. And
I've seen sites where any or all of the above were missing/broken.

Not unifying the lot into a simple usable function is just stupid --
history has shown people simply cannot be trusted to get this right.
