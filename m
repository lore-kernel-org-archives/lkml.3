Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaKSNgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:36:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58980 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066AbaKSNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:36:37 -0500
Date: Wed, 19 Nov 2014 08:36:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] ftrace/x86/extable: Add is_ftrace_trampoline()
 function
Message-ID: <20141119083622.432a234b@gandalf.local.home>
In-Reply-To: <87mw7nppu0.fsf@sejong.aot.lge.com>
References: <20141119033331.689278545@goodmis.org>
	<20141119034829.497125839@goodmis.org>
	<87mw7nppu0.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> [SNIP]
> > @@ -102,6 +103,8 @@ int __kernel_text_address(unsigned long addr)
> >  		return 1;
> >  	if (is_module_text_address(addr))
> >  		return 1;
> > +	if (is_ftrace_trampoline(addr))
> > +		return 1;
> 
> What about kernel_text_address()?  It seems some archs like ARM use it
> instead of __kernel_text_address() although trampoline is only enabled
> on x86 for now.
> 

Good question. I just did this to get x86 working. But as we add
trampolines to other archs, we probably should add it to that too.

-- Steve
