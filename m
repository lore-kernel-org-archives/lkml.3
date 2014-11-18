Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaKRO1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:27:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbaKRO1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:27:05 -0500
Date: Tue, 18 Nov 2014 08:26:27 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
Message-ID: <20141118142627.GA1944@cerebellum.variantweb.net>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411181511110.1117@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411181511110.1117@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:11:43PM +0100, Miroslav Benes wrote:
> 
> Hi,
> 
> thank you for the revision. I'll rebase our patches on top of that. Anyway 
> there is a small bug in a header file. See below.
> 
> On Sun, 16 Nov 2014, Seth Jennings wrote:
> 
> [...]
> 
> > diff --git a/arch/x86/include/asm/livepatch.h 
> b/arch/x86/include/asm/livepatch.h
> > new file mode 100644
> > index 0000000..c5fab45
> > --- /dev/null
> > +++ b/arch/x86/include/asm/livepatch.h
> > @@ -0,0 +1,38 @@
> > +/*
> > + * livepatch.h - x86-specific Live Kernel Patching Core
> > + *
> > + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef _ASM_X86_LIVEPATCH_H
> > +#define _ASM_X86_LIVEPATCH_H
> > +
> > +#include <linux/module.h>
> > +
> > +#ifdef CONFIG_LIVE_PATCHING
> > +extern int lpc_write_module_reloc(struct module *mod, unsigned long 
> type,
> > +                               unsigned long loc, unsigned long value);
> > +
> > +#else
> > +static int lpc_write_module_reloc(struct module *mod, unsigned long 
> type,
> > +                               unsigned long loc, unsigned long value);
> > +{
> > +     pr_err("Kernel does not support live patching\n");
> > +     return -ENOSYS;
> > +}
> > +#endif
> > +
> > +#endif /* _ASM_X86_LIVEPATCH_H */
> 
> There should not be a semicolon at the end of the function header in #else 
> branch.

Good catch.

Also, I'm adding "build with LIVE_PATCHING=n" as a test step :-/

Thanks,
Seth

> 
> Regards,
> 
> ---
> Miroslav Benes
> SUSE Labs
