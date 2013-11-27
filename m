Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3K0XlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:41:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50595 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab3K0XlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:41:01 -0500
Date: Thu, 28 Nov 2013 00:40:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131127234053.GO32267@pd.tnic>
References: <5294F10C.8060901@amacapital.net>
 <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
 <52964EC7.9000504@zytor.com>
 <52966C0A.7070201@zytor.com>
 <20131127222104.GA748@pd.tnic>
 <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
 <20131127222944.GB748@pd.tnic>
 <529674C4.2030906@zytor.com>
 <20131127231010.GM32267@pd.tnic>
 <52967E27.3070906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52967E27.3070906@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 03:20:07PM -0800, H. Peter Anvin wrote:
> No.  MFENCE doesn't serialize the front end.

So my manual says

"The MFENCE instruction is weakly-ordered with respect to data and
instruction prefetches. Speculative loads initiated by the processor, or
specified explicitly using cache-prefetch instructions, can be reordered
around an MFENCE."

and the SDM has only one sentence stating "MFENCE does not serialize
the instruction stream." which I'm assuming means the same, i.e. MFENCE
doesn't have control on I$ prefetches and they can be reordered around
it.

But I'd guess that depends on the uarch because Bulldozer, reportedly,
implements MFENCE by causing a pipeline stall which controls the
prefetches too:

"[MFENCE] stalls the pipeline and the processor core cannot begin
processing any further instructions until all previous instructions are
completed and any outstanding memory operations (such as prefetches
and stores) have completed. (This stall applies only to the individual
integer unit of the compute unit where the MFENCE instruction is
executed.) Architecturally serializing instructions such as CPUID have
the same pipeline stall behavior as MFENCE."

It is not clear, though, whether with "memory operations" and
"prefetches" they mean I$ prefetches too.

Cool, one gets to learn new stuff every day so thanks for making me look
:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
