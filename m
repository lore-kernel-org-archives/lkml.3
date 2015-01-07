Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbbAGXBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:01:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbbAGXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:01:06 -0500
Date: Thu, 8 Jan 2015 00:01:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: livepatching tree for linux-next
In-Reply-To: <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Andrew Morton wrote:

> > OK, I have added this from today
> 
> My x86_64 allmodconfig broke.
> 
> In file included from include/linux/livepatch.h:29,
>                  from kernel/livepatch/core.c:30:
> ./arch/x86/include/asm/livepatch.h:29:2: error: #error Your compiler must support -mfentry for live patching to work

[ adding Steven and Masami to CC, as this in some sense is related in 
  both to ftrace regs caller, and to IPMODIFY users in general ]

Well, if your gcc is too old (which is a fact detemined during build time, 
so there is no way to express this in Kconfig language in form of 
dependencies), we have to introduce build-time failure, as there is no way 
for this to work on compilers that don't support fentry on x86_64.

The only remaining option is to let the code build, pretend that 
everything is working, but do something like

#ifndef CC_USING_FENTRY
	printk("The compiler you used to compile your kernel was ancient "
		"there is no way for you to make use of this feature\n");
	return -EINVAL;
#endif

or so ... which I personally detest even more.

-- 
Jiri Kosina
SUSE Labs
