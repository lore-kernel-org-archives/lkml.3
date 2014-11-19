Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbaKSLZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:25:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33184 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaKSLZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:25:56 -0500
Date: Wed, 19 Nov 2014 11:25:53 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: David Long <dave.long@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
Message-ID: <20141119112553.GC15985@arm.com>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
 <1416292375-29560-2-git-send-email-dave.long@linaro.org>
 <20141118145643.GO18842@arm.com>
 <CA+b37P337jcTCPTg4Ydxh6TKwqmyMngt-eEowzfsTNBDZ7-NEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P337jcTCPTg4Ydxh6TKwqmyMngt-eEowzfsTNBDZ7-NEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:21:24AM +0000, Sandeepa Prabhu wrote:
> On 18 November 2014 20:26, Will Deacon <will.deacon@arm.com> wrote:
> 
> > One thing I noticed looking through this patch is that we're effectively
> > reinventing a bunch of the instruction decoding logic that we already have
> > in the kernel (introduced since Sandeepa last sent his patch).
> >
> > Could you take a look at include/asm/insn.h and kernel/insn.c please, and
> > see if you can at least consolidate some of this? Some of it should be easy
> > (i.e. reusing masks, using existing #defines to construct BRK encodings),
> > but I appreciate there may be places where kprobes needs to add extra bits,
> > in which case I'd really like to keep this all together if at all possible.
> >
> > We're currently in a position where the module loader, BPF jit, ftrace and
> > the proposed alternative patching scheme are all using the same instruction
> > manipulation functions, so we should try to continue that trend if we can.
> Will,
> 
> kernel/insn.c support generating instruction encodings(forming opcodes
> with given specifications), so for kprobes, only BRK encoding can use
> this mechanism.
> For instruction simulation, the instruction behavior should be
> simulated on saved pt_regs, which is not supported on insn.c routines,
> so still need probes-simulate-insn.c. Please point me if I am missing
> something here.

I was thinking of the magic hex numbers in the kprobes decode tables, which
seem to correspond directly to the instruction classes described in insn.c

Keeping the actual emulation code separate makes sense.

Will
