Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbaD2KFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:05:18 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59596 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaD2KFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:05:13 -0400
Date: Tue, 29 Apr 2014 15:35:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes/x86: Add is_64bit_mm(), kill
 validate_insn_bits()
Message-ID: <20140429100502.GB3269@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140419170104.GA30667@redhat.com>
 <20140419170151.GA30857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140419170151.GA30857@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042910-5490-0000-0000-0000058674F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-04-19 19:01:51]:

> 1. Extract the ->ia32_compat check from 64bit validate_insn_bits()
>    into the new helper, is_64bit_mm(), it will have more users.
> 
>    TODO: this checks is actually wrong if mm owner is X32 task,
>    we need another fix which changes set_personality_ia32().
> 
>    TODO: even worse, the whole 64-or-32-bit logic is very broken
>    and the fix is not simple, we need the nontrivial changes in
>    the core uprobes code.
> 
> 2. Kill validate_insn_bits() and change its single caller to use
>    uprobe_init_insn(is_64bit_mm(mm).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

