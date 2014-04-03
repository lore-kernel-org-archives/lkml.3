Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaDCQdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:33:20 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55587 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaDCQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:33:12 -0400
Date: Thu, 3 Apr 2014 22:03:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes/x86: Fold prepare_fixups() into
 arch_uprobe_analyze_insn()
Message-ID: <20140403163304.GB4882@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140331194337.GA9257@redhat.com>
 <20140331194359.GA9278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140331194359.GA9278@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040316-0260-0000-0000-000004A3A9EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-03-31 21:43:59]:

> No functional changes, preparation.
> 
> Shift the code from prepare_fixups() to arch_uprobe_analyze_insn()
> with the following modifications:
> 
> 	- Do not call insn_get_opcode() again, it was already called
> 	  by validate_insn_bits().
> 
> 	- Move "case 0xea" up. This way "case 0xff" can fall through
> 	  to default case.
> 
> 	- change "case 0xff" to use the nested "switch (MODRM_REG)",
> 	  this way the code looks a bit simpler.
> 
> 	- Make the comments look consistent.
> 
> While at it, kill the initialization of rip_rela_target_address and
> ->fixups, we can rely on kzalloc(). We will add the new members into
> arch_uprobe, it would be better to assume that everything is zero by
> default.
> 
> TODO: cleanup/fix the mess in validate_insn_bits() paths:
> 
> 	- validate_insn_64bits() and validate_insn_32bits() should be
> 	  unified.
> 
> 	- "ifdef" is not used consistently; if good_insns_64 depends
> 	  on CONFIG_X86_64, then probably good_insns_32 should depend
> 	  on CONFIG_X86_32/EMULATION
> 
> 	- the usage of mm->context.ia32_compat looks wrong if the task
> 	  is TIF_X32.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
-- 
Thanks and Regards
Srikar Dronamraju

