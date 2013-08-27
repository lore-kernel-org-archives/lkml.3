Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3H0UBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:01:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H0UBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:01:52 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xQxuxMh46K0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RZDpadHLlpEA:10 a=QyXUC8HyAAAA:8 a=UF-aZLFQmoNNkeJJSAMA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 16:01:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
Message-ID: <20130827160150.36f10869@gandalf.local.home>
In-Reply-To: <a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	<a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 14:40:13 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

  		return;
> -	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
> +
> +	/* Here we're inside the tp handler's rcu_read_lock (__DO_TRACE()) */
> +	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);

What's the reason for using rcu_dereference_raw() and not normal
rcu_dereference?

-- Steve

> +	if (!ftrace_file)
> +		return;
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  
