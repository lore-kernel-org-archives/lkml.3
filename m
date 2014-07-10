Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaGJWCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbaGJWCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:02:00 -0400
Date: Thu, 10 Jul 2014 17:01:37 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140710220137.GB19858@treble.redhat.com>
References: <20140703200750.648550267@goodmis.org>
 <20140710213620.GA19858@treble.redhat.com>
 <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:44:43PM +0200, Jiri Kosina wrote:
> On Thu, 10 Jul 2014, Josh Poimboeuf wrote:
> 
> > I did some testing with kpatch and I found one minor issue.  The dynamically
> > allocated trampoline seems to confuse dump_stack() somewhat.
> > 
> > I added a dump_stack() call in my ftrace_ops callback function
> > (kpatch_ftrace_handler) which had a filter on meminfo_proc_show().
> 
> Interesting. Are you using dwarf2 unwinder for stack dumping by any 
> chance?

I think so (but not sure).  How can I check?  I do see the following
macros being defined in my kernel build:

  -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1

> It seems to get things right here. Will look into it more tomorrow.

Thanks, please let me know what you find...

-- 
Josh
