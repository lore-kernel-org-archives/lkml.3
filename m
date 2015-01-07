Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbbAGXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:30:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbAGXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:30:08 -0500
Date: Wed, 7 Jan 2015 15:30:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: livepatching tree for linux-next
Message-Id: <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
	<20141226155613.36dd95b9@canb.auug.org.au>
	<20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
	<alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015 00:01:02 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 7 Jan 2015, Andrew Morton wrote:
> 
> > > OK, I have added this from today
> > 
> > My x86_64 allmodconfig broke.
> > 
> > In file included from include/linux/livepatch.h:29,
> >                  from kernel/livepatch/core.c:30:
> > ./arch/x86/include/asm/livepatch.h:29:2: error: #error Your compiler must support -mfentry for live patching to work
> 
> [ adding Steven and Masami to CC, as this in some sense is related in 
>   both to ftrace regs caller, and to IPMODIFY users in general ]
> 
> Well, if your gcc is too old (which is a fact detemined during build time, 
> so there is no way to express this in Kconfig language in form of 
> dependencies), we have to introduce build-time failure, as there is no way 
> for this to work on compilers that don't support fentry on x86_64.
> 
> The only remaining option is to let the code build, pretend that 
> everything is working, but do something like
> 
> #ifndef CC_USING_FENTRY
> 	printk("The compiler you used to compile your kernel was ancient "
> 		"there is no way for you to make use of this feature\n");
> 	return -EINVAL;
> #endif
> 
> or so ... which I personally detest even more.

um, what's so special about this patchset that it gets to be the first
code in the history of the kernel which breaks allmodconfig?

Please find a way to fix it.  Copying CONFIG_CC_STACKPROTECTOR is one way.

