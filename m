Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaJXKat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:30:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:30:46 -0400
Date: Fri, 24 Oct 2014 12:30:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
Message-ID: <20141024103030.GH12706@worktop.programming.kicks-ass.net>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
 <20141021094714.GR23531@worktop.programming.kicks-ass.net>
 <544630CA.2000502@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544630CA.2000502@samsung.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:09:14PM +0400, Andrey Ryabinin wrote:
> On 10/21/2014 01:47 PM, Peter Zijlstra wrote:
> > On Mon, Oct 20, 2014 at 02:54:59PM +0400, Andrey Ryabinin wrote:
> >>
> >> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
> >> Compiler inserts code that perform certain kinds of
> >> checks before operations that could cause UB.
> >> If check fails (i.e. UB detected) __ubsan_handle_* function called.
> >> to print error message.
> >>
> >> So the most of the work is done by compiler.
> >> This patch just implements ubsan handlers printing errors.
> >>
> >> GCC supports this since 4.9, however upcoming GCC 5.0 has
> >> more checkers implemented.
> > 
> > It might be useful if you've got a link to the relevant GCC
> > documentation of this new shiny stuf.
> > 
> 
> Documentation is very brief (look for fsanitize=undefined): https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
> GCC 4.9.1 doc: https://gcc.gnu.org/onlinedocs/gcc-4.9.1/gcc/Debugging-Options.html
> 
> And there is an article which might be interesting: http://developerblog.redhat.com/2014/10/16/gcc-undefined-behavior-sanitizer-ubsan/

Thanks, please consider including these in the changelog of future
postings of this patch set.
