Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724Ab3BNPtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:49:06 -0500
Received: from david.siemens.de ([192.35.17.14]:25728 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab3BNPtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:49:05 -0500
Message-ID: <511D074B.7040608@siemens.com>
Date: Thu, 14 Feb 2013 16:48:27 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tom Tromey <tromey@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Andi Kleen <andi@firstfloor.org>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 05/20] scripts/gdb: Add lx-symbols command
References: <cover.1359463075.git.jan.kiszka@siemens.com> <cover.1359463075.git.jan.kiszka@siemens.com> <9fd8d68344bdc125a0345f04d2f7484f262459a8.1359463075.git.jan.kiszka@siemens.com> <877gmakinx.fsf@fleche.redhat.com>
In-Reply-To: <877gmakinx.fsf@fleche.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-14 16:40, Tom Tromey wrote:
>>>>>> "Jan" == Jan Kiszka <jan.kiszka@siemens.com> writes:
> 
> Jan> In addition, the command installs a silent breakpoint in the load_module
> Jan> function at the point where the module was loaded but not yet
> Jan> initialized. The breakpoint handler will try to load symbols from the
> Jan> module files found during lx-symbols execution. This way, breakpoints
> Jan> can be set to module initialization functions, and there is usually no
> Jan> need to explicitly call lx-symbols after (re-)loading a module.
> 
> It is a nice approach, but I wonder whether the kernel's gdb stub could
> use the existing qXfer:libraries remote protocol packet.  And, if not,
> could we extend gdb to make it work.

That would help kgdb, but not QEMU or hardware debuggers. They have no
"Linux awareness" built in.

> 
> Jan> +		def _find_breakpoint_location(self):
> Jan> +			breakpoint_match = "^[0-9]*[\t]*err = parse_args\(.*"
> Jan> +
> Jan> +			src = gdb.execute("list kernel/module.c:load_module",
> Jan> +					  to_string = True)
> 
> Whatever works -- but I think there are better ways.
> 
> The simplest is introducing a function that is called at the right spot
> with the right arguments.  It doesn't need to do anything, just be a
> name where you can put a breakpoint.

Yes, I have this on my todo list. I already have a local config here
where the current heuristic broke - once again. We likely just need to
enforce un-inlining of do_init_module.

> 
> Jan> +	import symbols
> 
> I think it's better to put everything into its own package, e.g. 'import
> linux.symbols', to try to avoid conflicts with other python modules that
> may get loaded.

OK.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
