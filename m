Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3A1Kr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:47:27 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37591 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3A1KrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:47:23 -0500
Date: Mon, 28 Jan 2013 11:47:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, acme@redhat.com,
        eranian@google.com, jolsa@redhat.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers
 v2
Message-ID: <20130128104718.GB20263@gmail.com>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
 <1359151245-13179-5-git-send-email-andi@firstfloor.org>
 <20130126115402.GA13445@gmail.com>
 <20130126210000.GK30577@one.firstfloor.org>
 <20130127131451.GE3933@gmail.com>
 <20130128050234.GQ30577@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128050234.GQ30577@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> [dropping linux-kernel]

(Re-added, because this concerns others as well.)

> > So please re-send a truly minimal hw-enabling series first, 
> > as requested - a minimal series that enables most of the 
> > everyday usecases.
> 
> I don't have much interesting in arguing what is fundamental 
> and what is not. Variants of this patchkit have been used for 
> over a year to do Haswell work, and I have a reasonably large 
> user base for it both internal in Intel and with some other 
> Haswell users.
> 
> They need all these features. [...]

That argument is silly, dishonest and misleading: the majority 
of perf users don't *ever* specify a different profiling event 
from the default 'cycles' one, let alone do they specify CPU 
specific features - full stop.

They are using 'perf record/report', 'perf top', or use other 
tools like SysProf (that use perf 'cycles' events internally by 
default) and that's it.

A select few know about 'cycles:pp', perhaps. (In fact we'll 
make that the default in the future, to make profiling even 
easier by default.) Some do -g call-graph profiling.

Most developers that use profiling tools want to know where the 
silliest overhead in their app is and they don't care much about 
CPU specific events.

That group of users includes most kernel developers in fact: 
I've rarely seen people go beyond perf record / perf top - and 
that's *good* in a sense, because it means they get what they 
want from our primary source of profiling information already.

Things like cachemiss profiling or multi-event profiling are a 
distant second in terms of popularity. The use of CPU specific 
events is even rarer.

Any Haswell-specific features are a second or third order 
concern, at best, in terms of installed base. We *do* care about 
those usecases as well, but you are wasting precious 
hw-enablement time by insisting on more complex patches while 
stonewalling my request for the simplest ones - the minimal 
patches really belong upstream.

So please send a minimal series that serves the overwhelmingly 
common case, without any other distractions, and after that we 
can argue Haswell specific extensions to profiling.

This isn't such a difficult or in any way controversial concept 
really...

Thanks,

	Ingo
