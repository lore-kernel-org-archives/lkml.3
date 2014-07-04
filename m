Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbaGDNcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:32:52 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33051 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaGDNcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:32:51 -0400
Message-ID: <53B6ACFC.3090300@hitachi.com>
Date: Fri, 04 Jul 2014 22:32:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 1/3] ftrace/x86: Add dynamic allocated trampoline
 for ftrace_ops
References: <20140703200750.648550267@goodmis.org> <20140703202324.832135644@goodmis.org>
In-Reply-To: <20140703202324.832135644@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/04 5:07), Steven Rostedt wrote:
> +
> +void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> +{
> +	unsigned char *new;
> +	unsigned long start_offset;
> +	unsigned long call_offset;
> +	unsigned long offset;
> +	unsigned long ip;
> +	int ret;
> +
> +	if (ops->trampoline) {
> +		/*
> +		 * The ftrace_ops caller may set up its own trampoline.
> +		 * In such a case, this code must not modify it.
> +		 */
> +		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
> +			return;

Just a question, what happen if the ftrace_ops caller sets up a trampoline which is
not compatible to the ftrace's trampoline, and the ftrace_ops conflicts on a IP with other
ftrace_ops? I guess in that case ftrace will use the loop callback on the IP, but since
the trampoline is not compatible, the result will not be same, is that right? :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


