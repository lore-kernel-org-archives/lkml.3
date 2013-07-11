Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3GKXBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:01:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57926 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752856Ab3GKXBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:01:31 -0400
Message-ID: <1373583689.2614.4.camel@joe-AO722>
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 16:01:29 -0700
In-Reply-To: <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 22:26 +0200, Jiri Kosina wrote:
> Introduce a method for run-time instrucntion patching on a live SMP kernel 

Some of the typos anyway.

s/instrunction/instruction

[]

> v2 -> v3:
>   + fixed few typos (Joe Perches)
[]
> +       /* we are not interested in non-int3 faults and ring > 0 faults */
> +       if (val != DIE_INT3 || !args->regs || user_mode_vm(args->regs)
> +                           || (unsigned long) bp_int3_addr != args->regs->ip)
> +               return NOTIFY_DONE;
> +
> +       /* set up the specified breakpoint handler */
> +       args->regs->ip = (unsigned long) bp_int3_handler;

Still think the test and set should be in the same order.

> +/*
> + * text_poke_bp() -- update instructions on live kernel on SMP
> + * @addr:      address to patch
> + * @opcode:    opcode of new instruction
> + * @len:       length to copy
> + * @handler:   address to jump to when the temporary breakpoint is hit
> + *

This sure looks like kernel-doc but misses the leading /**



