Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaEAAaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:30:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57489 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaEAAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:30:04 -0400
Subject: Re: [PATCH] uprobes: use BX register for rip-relative fixups, not
 AX
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com>
	 <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 17:29:58 -0700
Message-ID: <1398904198.4878.34.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050100-0320-0000-0000-00000323DBCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 19:06 +0200, Denys Vlasenko wrote:
> Otherwise, instructions such as cmpxchg and div will be mishandled.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c | 57 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
...
> @@ -296,41 +296,58 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  	 */
>  	cursor = auprobe->insn + insn_offset_modrm(insn);
>  	/*
> -	 * Convert from rip-relative addressing to register-relative addressing
> -	 * via a scratch register.
> +	 * Convert from rip-relative addressing
> +	 * to register-relative addressing via a scratch register.
>  	 */

This comment looks like a regression. :-)

Looks good otherwise (setting aside your later findings about cmpxchg8b
and such -- I guess we need some way to helpfully reject rip-relative
forms of such instructions).

Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

