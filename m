Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab3CVPHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:07:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46873 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3CVPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:07:18 -0400
Date: Fri, 22 Mar 2013 20:37:01 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/3] uprobes: add trap variant helper
Message-ID: <20130322150701.GA20010@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130322114446.GG26183@in.ibm.com> <20130322145406.GB17286@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322145406.GB17286@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032215-9360-0000-0000-000011700101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 03:54:06PM +0100, Oleg Nesterov wrote:
> On 03/22, Ananth N Mavinakayanahalli wrote:
> >
> > +/**
> > + * is_trap_insn - check if instruction is breakpoint instruction.
> > + * @insn: instruction to be checked.
> > + * Default implementation of is_trap_insn
> > + * Returns true if @insn is a breakpoint instruction.
> > + *
> > + * This function is needed for the case where an architecture has multiple
> > + * trap instructions (like powerpc).
> > + */
> > +bool __weak is_trap_insn(uprobe_opcode_t *insn)
> > +{
> > +	return is_swbp_insn(insn);
> > +}
> 
> OK, thanks, the whole series looks fine, just one note...

OK.

> My patch also changed prepare_uprobe() to use is_trap_insn(), and I think
> this is right. Exactly because of 3/3 which removes is_trap() from
> arch_uprobe_analyze_insn().
> 
> If the original insn is_trap(), we do not want to singlestep it and get
> another trap after we hit handle_swbp().

OK, I'll send a v2 with that change.

Ananth

