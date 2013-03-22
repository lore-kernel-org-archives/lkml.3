Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3CVO43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785Ab3CVO4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:56:22 -0400
Date: Fri, 22 Mar 2013 15:54:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/3] uprobes: add trap variant helper
Message-ID: <20130322145406.GB17286@redhat.com>
References: <20130322114446.GG26183@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322114446.GG26183@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Ananth N Mavinakayanahalli wrote:
>
> +/**
> + * is_trap_insn - check if instruction is breakpoint instruction.
> + * @insn: instruction to be checked.
> + * Default implementation of is_trap_insn
> + * Returns true if @insn is a breakpoint instruction.
> + *
> + * This function is needed for the case where an architecture has multiple
> + * trap instructions (like powerpc).
> + */
> +bool __weak is_trap_insn(uprobe_opcode_t *insn)
> +{
> +	return is_swbp_insn(insn);
> +}

OK, thanks, the whole series looks fine, just one note...

My patch also changed prepare_uprobe() to use is_trap_insn(), and I think
this is right. Exactly because of 3/3 which removes is_trap() from
arch_uprobe_analyze_insn().

If the original insn is_trap(), we do not want to singlestep it and get
another trap after we hit handle_swbp().

Oleg.

