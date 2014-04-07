Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaDGSyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:54:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46785 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaDGSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:54:19 -0400
Subject: Re: [RFC PATCH 0/6] uprobes/x86: fix the reprel jmp/call handling
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140406201524.GA32694@redhat.com>
References: <20140404185038.GA14679@redhat.com>
	 <20140404193226.GA23092@redhat.com>
	 <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com>
	 <20140406201524.GA32694@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Apr 2014 11:54:12 -0700
Message-ID: <1396896852.9333.14.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040718-9332-0000-0000-0000006E3F1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 22:15 +0200, Oleg Nesterov wrote:
> On 04/04, Jim Keniston wrote:
> >
> > On Fri, 2014-04-04 at 21:32 +0200, Oleg Nesterov wrote:
> > >
> > > 	1. Why insn_get_displacement() doesn't work? See "HELP!!!"
> > > 	   below.
> >
> > insn->moffset1.value seems to be what you want.
> 
> Works! Thanks a lot.
> 
> Still I can't understand why displacement.nbytes == 0 in this case...
> Nevermind.

Looking at Masami's arch/x86/lib/x86-opcode-map.txt and related code, I
see that the operands to the Jcc and JMP instructions are treated as
immediate values.  So insn->immediate.value (which is in the same union
as insn->moffset1.value) is more appropriate, and insn->immediate.nbytes
should get you the correct size.  Again, insn_get_length() finishes
parsing the whole instruction as necessary, so insn_get_immediate() gets
called as a side effect.

> 
> OK. Please see the RFC changes. Obviously not for inclusion yet. And
> totally untested, except I verified that the test-case from 4/6 works.
> 
> Please comment.

I'll look at the new patches today.

> 
> Oleg.

Jim

