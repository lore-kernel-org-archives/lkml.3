Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab3BNPlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:41:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934661Ab3BNPlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:41:20 -0500
From: Tom Tromey <tromey@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Ben Widawsky <ben@bwidawsk.net>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 05/20] scripts/gdb: Add lx-symbols command
References: <cover.1359463075.git.jan.kiszka@siemens.com>
	<cover.1359463075.git.jan.kiszka@siemens.com>
	<9fd8d68344bdc125a0345f04d2f7484f262459a8.1359463075.git.jan.kiszka@siemens.com>
X-Attribution: Tom
Date: Thu, 14 Feb 2013 08:40:50 -0700
In-Reply-To: <9fd8d68344bdc125a0345f04d2f7484f262459a8.1359463075.git.jan.kiszka@siemens.com>
	(Jan Kiszka's message of "Tue, 29 Jan 2013 13:37:48 +0100")
Message-ID: <877gmakinx.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Kiszka <jan.kiszka@siemens.com> writes:

Jan> In addition, the command installs a silent breakpoint in the load_module
Jan> function at the point where the module was loaded but not yet
Jan> initialized. The breakpoint handler will try to load symbols from the
Jan> module files found during lx-symbols execution. This way, breakpoints
Jan> can be set to module initialization functions, and there is usually no
Jan> need to explicitly call lx-symbols after (re-)loading a module.

It is a nice approach, but I wonder whether the kernel's gdb stub could
use the existing qXfer:libraries remote protocol packet.  And, if not,
could we extend gdb to make it work.

Jan> +		def _find_breakpoint_location(self):
Jan> +			breakpoint_match = "^[0-9]*[\t]*err = parse_args\(.*"
Jan> +
Jan> +			src = gdb.execute("list kernel/module.c:load_module",
Jan> +					  to_string = True)

Whatever works -- but I think there are better ways.

The simplest is introducing a function that is called at the right spot
with the right arguments.  It doesn't need to do anything, just be a
name where you can put a breakpoint.

Jan> +	import symbols

I think it's better to put everything into its own package, e.g. 'import
linux.symbols', to try to avoid conflicts with other python modules that
may get loaded.

Tom
