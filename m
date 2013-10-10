Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3JJExP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:53:15 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57120 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3JJExN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:53:13 -0400
Date: Thu, 10 Oct 2013 06:53:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131010045309.GB23267@gmail.com>
References: <20131009144150.108f7041@gandalf.local.home>
 <5255C07E.70805@linux.intel.com>
 <878uy2ytd8.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uy2ytd8.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> - That said, I think a software CLI/STI is somewhat useful for 
> profiling, as it can allow to measure how long interrupts are delayed by 
> CLI/STI. [...]

That could be measured directly in a simpler way, without disrupting 
CLI/STI: by turning all IRQs into NMIs and resending them from a special 
NMI handler. (and of course timestamping the NMI arrival time and the IRQ 
entry time so that instrumentation can recover it.)

If indirect, statistical measurement suffices then IRQ delivery latencies 
can also be estimated statistically without any kernel changes: by 
profiling IRQ disable/enable sections (there's a counter for that), 
calculating average IRQ-disable section length from that. The average IRQ 
delay will be 50% of that value, assuming normal distribution of IRQs. 
This should be good enough for most cases.

Thanks,

	Ingo
