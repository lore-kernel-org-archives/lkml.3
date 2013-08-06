Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3HFRu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:50:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3HFRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:50:57 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=o9wxAiQGZFUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lPGdCojwBkAA:10 a=NufY4J3AAAAA:8 a=jZqTZzPk8I_7HgC1ek0A:9 a=QEXdDO2ut3YA:10 a=re9sYKne76oA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375811455.25420.39.camel@gandalf.local.home>
Subject: Re: x86: use this_cpu for debug_stack_usage
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 13:50:55 -0400
In-Reply-To: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>
References: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 17:01 +0000, Christoph Lameter wrote:
> Reduces overhead a bit and frees up a couple of registers.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/arch/x86/include/asm/debugreg.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/debugreg.h	2013-07-30 14:00:30.000000000 -0500
> +++ linux/arch/x86/include/asm/debugreg.h	2013-07-30 14:00:57.503076270 -0500
> @@ -97,11 +97,11 @@ extern void hw_breakpoint_restore(void);
>  DECLARE_PER_CPU(int, debug_stack_usage);
>  static inline void debug_stack_usage_inc(void)
>  {
> -	__get_cpu_var(debug_stack_usage)++;
> +	__this_cpu_inc(debug_stack_usage);

I don't remember why I didn't use this in the first place. Perhaps I was
still in the "get_cpu" mind set.

Also, what's the difference between "__this_cpu_inc()" and
"this_cpu_inc()"?

>  }
>  static inline void debug_stack_usage_dec(void)
>  {
> -	__get_cpu_var(debug_stack_usage)--;
> +	__this_cpu_dec(debug_stack_usage);
>  }
>  int is_debug_stack(unsigned long addr);
>  void debug_stack_set_zero(void);

Might as well change is_debug_stack() to use __this_cpu_read() instead
of __get_cpu_var().

-- Steve


