Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3KFLuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:50:10 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54287 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3KFLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:50:08 -0500
Date: Wed, 6 Nov 2013 12:50:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
Message-ID: <20131106115004.GB20249@gmail.com>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
 <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
 <20131104210053.76c37210@gandalf.local.home>
 <20131105060901.GA29936@gmail.com>
 <5278973A.1010705@hitachi.com>
 <20131105070537.GA2007@gmail.com>
 <5278D89B.1070806@hitachi.com>
 <20131106060737.GC24044@gmail.com>
 <527A1B50.6080408@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A1B50.6080408@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/11/06 15:07), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >>>> [...] I hope to build the list when the kernel build time if 
> >>>> possible... Would you have any idea to classify some annotated(but no 
> >>>> side-effect) functions?
> >>>
> >>> The macro magic I can think of would need to change the syntax of the 
> >>> function definition - for example that is how the SYSCALL_DEFINE*() 
> >>> macros work.
> >>
> >> Would you mean something like the below macro? :)
> >>
> >> NOKPROBE_SYMBOL(int, func_ptr_is_kernel_text)(void *ptr)
> > 
> > I think this is rather ugly and harder to maintain. The whole _point_ of 
> > such annotations is to make them 'easy on the eyes', to make it easy to 
> > skip a 'noinline', 'noprobe' or 'notrace' tag.
> > 
> > Using something like NOKPROBE_SYMBOL() makes the whole construct ugly and 
> > attention seeking.
> 
> Hmm, by the way how about Steven's idea? A macro like EXPORT_SYMBOL? At 
> least for kprobes_blacklist, which is defined/maintained in kprobes.c 
> for some symbols(*), that is useful for updating it because we can put 
> it near the function definition.

Dunno, it feels a bit fragile to me.

Thanks,

	Ingo
