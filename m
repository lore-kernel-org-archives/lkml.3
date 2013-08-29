Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3H2V00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3H2V0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:26:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FMtKoE46C6oA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mQgDvka74kUA:10 a=cUBnaquH_NFVZu-jDB8A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 29 Aug 2013 17:26:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 08/35] tracing: Replace __get_cpu_var uses
Message-ID: <20130829172622.3b458a80@gandalf.local.home>
In-Reply-To: <00000140c6781ceb-6c3e93f5-45d6-4b04-8034-e7cd4b5a77b5-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com>
	<00000140c6781ceb-6c3e93f5-45d6-4b04-8034-e7cd4b5a77b5-000000@email.amazonses.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 19:48:16 +0000

> Index: linux/kernel/trace/trace.c
> ===================================================================
> --- linux.orig/kernel/trace/trace.c	2013-08-26 14:25:53.000000000 -0500
> +++ linux/kernel/trace/trace.c	2013-08-26 14:26:29.464993617 -0500
> @@ -1676,7 +1676,7 @@ static void __ftrace_trace_stack(struct
>  	 */
>  	barrier();
>  	if (use_stack == 1) {
> -		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
> +		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
>  		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
>  
>  		if (regs)


This patch fails to build:

kernel/trace/trace.c: In function ‘__ftrace_trace_stack’:
kernel/trace/trace.c:1679:20: error: cast specifies array type

-- Steve
