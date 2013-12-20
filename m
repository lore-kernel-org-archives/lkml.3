Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3LTTsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:48:06 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:37248 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab3LTTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:48:04 -0500
Message-ID: <1387568838.3311.5.camel@computer5.home>
Subject: Re: [PATCH v4 15/16] ARM: add uprobes support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: David Long <dave.long@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Dec 2013 19:47:18 +0000
In-Reply-To: <CAH+eYFDqVpBzzjxR5tVpPUUKS3XLWiDU1Fe5p0CQTUP4yWUDhg@mail.gmail.com>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
	 <1387166930-13182-16-git-send-email-dave.long@linaro.org>
	 <1387564464.3404.106.camel@linaro1.home>
	 <CAH+eYFDqVpBzzjxR5tVpPUUKS3XLWiDU1Fe5p0CQTUP4yWUDhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 20:00 +0100, Rabin Vincent wrote:
> 2013/12/20 Jon Medhurst (Tixy) <tixy@linaro.org>
> > On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> > > +static int uprobes_substitute_pc(unsigned long *pinsn, u32 oregs)
> > > +{
> > > +     probes_opcode_t insn = __mem_to_opcode_arm(*pinsn);
> > > +     probes_opcode_t temp;
> > > +     probes_opcode_t mask;
> > > +     int freereg;
> > > +     u32 free = 0xffff;
> > > +     u32 regs;
> > > +
> > > +     for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
> > > +             if ((regs & 0xf) == REG_TYPE_NONE)
> > > +                     continue;
> > > +
> > > +             free &= ~(1 << (insn & 0xf));
> > > +     }
> > > +
> > > +     /* No PC, no problem */
> > > +     if (free & (1 << 15))
> > > +             return 15;
> > > +
> > > +     if (!free)
> > > +             return -1;
> > > +
> > > +     /*
> > > +      * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
> > > +      * pick LR instead of R1.
> >
> > Do we know why this is desirable, i.e. preferring the higher numbered
> > registers? If there isn't a preference, then no need for comment really.
> >
> > Also, the comment as is is wrong, should be "...pick LR instead of R2"
> > because R1 wouldn't be chosen as the instruction already uses it.
> 
> The second destination register of LDRD (R1 in the example above) is
> not encoded in the instruction

Ah, that's the fact I'd missed, so the code and comment in this patch is
correct.

Thanks

-- 
Tixy


