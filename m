Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3HLQL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:11:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58864 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HLQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:11:54 -0400
Date: Mon, 12 Aug 2013 18:11:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130812161137.GU3008@twins.programming.kicks-ass.net>
References: <1375721715.22073.80.camel@gandalf.local.home>
 <20130812091707.GB27162@twins.programming.kicks-ass.net>
 <5208F78A.3000708@linux.intel.com>
 <878v06oq2t.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v06oq2t.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:02:02AM -0700, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@linux.intel.com> writes:
> 
> > However, I would really like to
> > understand what the value is.
> 
> Probably very little. When I last looked at it, the main overhead in
> perf currently seems to be backtraces and the ring buffer, not this
> code.

backtraces do indeed blow and make pretty much everything else
irrelevant, but when not using them the branch forest was significant
when I last looked at it.
