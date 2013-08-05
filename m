Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3HETyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:54:52 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33552 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754557Ab3HETyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:54:51 -0400
Date: Mon, 5 Aug 2013 15:54:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130805195446.GA22359@Krystal>
References: <1375721715.22073.80.camel@gandalf.local.home> <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com> <1375725328.22073.101.camel@gandalf.local.home> <51FFEC56.6040206@linux.intel.com> <1375727010.22073.110.camel@gandalf.local.home> <51FFEEEC.5060902@linux.intel.com> <1375728583.22073.118.camel@gandalf.local.home> <51FFF430.1060701@linux.intel.com> <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
[...]
> With two-byte jumps, you'd still get the I$ fragmentation (the
> argument generation and the call and the branch back would all be in
> the same code segment as the hot code), but that would be offset by
> the fact that at least the hot code itself could use a short jump when
> possible (ie a 2-byte nop rather than a 5-byte one).

I remember that choosing between 2 and 5 bytes nop in the asm goto was
tricky: it had something to do with the fact that gcc doesn't know the
exact size of each instructions until further down within compilation
phases on architectures with variable instruction size like x86. If we
have guarantees that the guessed size of each instruction is an upper
bound on the instruction size, this could probably work though.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
