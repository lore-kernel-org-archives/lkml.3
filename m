Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab3HGPCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab3HGPCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:02:13 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=Z59vuUBYmP0ofHBUxzgA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375887730.6848.7.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?Q?Ond=C5=99ej_B=C3=ADlka?= <neleai@seznam.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 07 Aug 2013 11:02:10 -0400
In-Reply-To: <20130807050601.GA5385@domone.kolej.mff.cuni.cz>
References: <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <1375727977.22073.112.camel@gandalf.local.home>
	 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	 <1375798783.25420.30.camel@gandalf.local.home>
	 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
	 <1375811885.25420.44.camel@gandalf.local.home>
	 <20130806203319.GA16170@Krystal>
	 <1375821817.25420.50.camel@gandalf.local.home>
	 <1375836304.25420.76.camel@gandalf.local.home>
	 <1375836960.25420.80.camel@gandalf.local.home>
	 <20130807050601.GA5385@domone.kolej.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 07:06 +0200, Ondřej Bílka wrote:

> Add short_counter,long_counter and before increment counter before each
> jump. That way we will know how many short/long jumps were taken. 

That's not trivial at all. The jump is a single location (in an asm
goto() statement) that happens to be inlined through out the kernel. The
assembler decides if it will be a short or long jump. How do you add a
counter to count the difference?

The output I gave is from the boot up code that converts the jmp back to
a nop (or in this case, the default nop to the ideal nop). It knows the
size by reading the op code. This is a static analysis, not a running
one. It's no trivial task to have a counter for each jump.

There is a way though. If we enable all the jumps (all tracepoints, and
other users of jumplabel), record the trace and then compare the trace
to the output that shows which ones were short jumps, and all others are
long jumps.

I'll post the patches soon and you can have fun doing the compare :-)

Actually, I'm working on the 4 patches of the series that is more about
clean ups and safety checks than the jmp conversion. That is not
controversial, and I'll be posting them for 3.12 soon.

After that, I'll post the updated patches that have the conversion as
well as the counter, for RFC and for others to play with.

-- Steve


