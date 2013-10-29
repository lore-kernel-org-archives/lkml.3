Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3J2T6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:58:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3J2T6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:58:06 -0400
Date: Tue, 29 Oct 2013 20:59:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] uprobes: add arch write opcode hook
Message-ID: <20131029195920.GA4538@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-6-git-send-email-dave.long@linaro.org> <20131019165051.GC7837@redhat.com> <5268137F.3030809@linaro.org> <20131028194914.GA15103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028194914.GA15103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Oleg Nesterov wrote:
>
> Yes, yes, sorry for confusion. What I actually tried to suggest is
> something like the trivial patch below.
>
> Then arm can do:
>
> 	uprobe_opcode_t arch_uprobe_swbp_insn(struct arch_uprobe *auprobe)
> 	{
> 		return __opcode_to_mem_arm(auprobe->bpinsn);
> 	}
>
> No?
>
> > I notice there don't seem to be any alternative set_swbp functions
> > in the (rc6) kernel tree
>
> Yes... I think we should simply make it "static". And set_orig_insn()
> too.

Or. arm can actually reimplement set_swbp(). This doesn't mean the
duplication of write_opcode() code, we can simply export this helper.

Either way is imho better than this patch. Unless I missed something.

Oleg.

