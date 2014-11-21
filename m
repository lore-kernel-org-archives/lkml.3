Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaKUTQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:16:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaKUTQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:16:50 -0500
Date: Fri, 21 Nov 2014 12:29:12 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141121182912.GA1887@cerebellum.variantweb.net>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
 <20141121164027.GB11339@cerebellum.variantweb.net>
 <546F77F3.3050002@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546F77F3.3050002@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 06:35:47PM +0100, Jiri Slaby wrote:
> On 11/21/2014, 05:40 PM, Seth Jennings wrote:
> >>> --- /dev/null
> >>> +++ b/arch/x86/include/asm/livepatch.h
> >>> @@ -0,0 +1,37 @@
> ...
> >>> +#ifndef _ASM_X86_LIVEPATCH_H
> >>> +#define _ASM_X86_LIVEPATCH_H
> >>> +
> >>> +#include <linux/module.h>
> >>> +
> >>> +#ifdef CONFIG_LIVE_PATCHING
> >>> +extern int klp_write_module_reloc(struct module *mod, unsigned long type,
> >>> +				  unsigned long loc, unsigned long value);
> >>> +
> >>> +#else
> >>> +static int klp_write_module_reloc(struct module *mod, unsigned long type,
> >>
> >> static inline?
> > 
> > I think the practice is to let the compiler handle inline determination
> > unless you are sure that the compiler isn't inlining something you think
> > it should.
> 
> Although you are right, it is a correct C, gcc specs (6.39) suggests to
> use 'static inline' on such functions. gcc then shall inline such functions.

Fair enough.  Queued up.

Thanks,
Seth

> 
> And if you look around in the kernel, we use that combination almost
> everywhere.
> 
> thanks,
> -- 
> js
> suse labs
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
