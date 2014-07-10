Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaGJVor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:44:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaGJVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:44:45 -0400
Date: Thu, 10 Jul 2014 23:44:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
In-Reply-To: <20140710213620.GA19858@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>
References: <20140703200750.648550267@goodmis.org> <20140710213620.GA19858@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Josh Poimboeuf wrote:

> I did some testing with kpatch and I found one minor issue.  The dynamically
> allocated trampoline seems to confuse dump_stack() somewhat.
> 
> I added a dump_stack() call in my ftrace_ops callback function
> (kpatch_ftrace_handler) which had a filter on meminfo_proc_show().

Interesting. Are you using dwarf2 unwinder for stack dumping by any 
chance? It seems to get things right here. Will look into it more 
tomorrow.

-- 
Jiri Kosina
SUSE Labs
