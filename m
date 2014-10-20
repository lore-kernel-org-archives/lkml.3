Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaJTJYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:24:23 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58561 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaJTJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:24:20 -0400
Date: Mon, 20 Oct 2014 11:24:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        mpe@ellerman.id.au, anton@samba.org, brueckner@linux.vnet.ibm.com
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141020112413.56450095@mschwide>
In-Reply-To: <20141020084813.GB3219@twins.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
	<b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
	<CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
	<20141019213534.GG23531@worktop.programming.kicks-ass.net>
	<CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
	<20141020084813.GB3219@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102009-0013-0000-0000-00000181E418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 10:48:13 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> >  - cpumsf_pmu_event_idx is the same as power_pmu_event_idx.
> 
> Oh cute, lets ask the s390 people, do you guys have a userspace
> instruction to read the actual counter value?

The "extract cpu counter" ECCTR instruction can be authorized to
be used in user-space with a bit in CR0. With the current code
this bit is not set, the cpu measurement facility is not usable
in user space without a patch to the kernel.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

