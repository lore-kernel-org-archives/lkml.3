Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaKROLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:11:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbaKROLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:11:39 -0500
Date: Tue, 18 Nov 2014 15:11:43 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411181511110.1117@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

thank you for the revision. I'll rebase our patches on top of that. Anyway 
there is a small bug in a header file. See below.

On Sun, 16 Nov 2014, Seth Jennings wrote:

[...]

> diff --git a/arch/x86/include/asm/livepatch.h 
b/arch/x86/include/asm/livepatch.h
> new file mode 100644
> index 0000000..c5fab45
> --- /dev/null
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -0,0 +1,38 @@
> +/*
> + * livepatch.h - x86-specific Live Kernel Patching Core
> + *
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _ASM_X86_LIVEPATCH_H
> +#define _ASM_X86_LIVEPATCH_H
> +
> +#include <linux/module.h>
> +
> +#ifdef CONFIG_LIVE_PATCHING
> +extern int lpc_write_module_reloc(struct module *mod, unsigned long 
type,
> +                               unsigned long loc, unsigned long value);
> +
> +#else
> +static int lpc_write_module_reloc(struct module *mod, unsigned long 
type,
> +                               unsigned long loc, unsigned long value);
> +{
> +     pr_err("Kernel does not support live patching\n");
> +     return -ENOSYS;
> +}
> +#endif
> +
> +#endif /* _ASM_X86_LIVEPATCH_H */

There should not be a semicolon at the end of the function header in #else 
branch.

Regards,

---
Miroslav Benes
SUSE Labs
