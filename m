Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3KENNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:13:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60401 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754632Ab3KENNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:13:21 -0500
Date: Tue, 5 Nov 2013 08:13:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
Message-ID: <20131105081310.34f88a92@gandalf.local.home>
In-Reply-To: <20131105070537.GA2007@gmail.com>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
	<20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
	<20131104210053.76c37210@gandalf.local.home>
	<20131105060901.GA29936@gmail.com>
	<5278973A.1010705@hitachi.com>
	<20131105070537.GA2007@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 08:05:37 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> The macro magic I can think of would need to change the syntax of the 
> function definition - for example that is how the SYSCALL_DEFINE*() macros 
> work.

Or something like the EXPORT_SYMBOL(), but that wouldn't include the
size of the function. But using the name we could use kallsyms to see
if a probe is placed in a function that is blacklisted. Not very pretty
to do though.

> 
> It would be nice if there was a GCC extension that marked a function 
> noinline and allowed the emitting of the function's address (and size) 
> into a special section - but I'm not aware of any such compiler feature 
> today.

Yeah, I was wishing the same thing. Maybe I'll try to talk with the gcc
folks about adding such a feature. Something like

void  __attribute__((save_loc_and_size(".section"))) function(void)
{
}

-- Steve


