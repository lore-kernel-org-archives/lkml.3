Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaEAVCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaEAVCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:02:15 -0400
Date: Thu, 1 May 2014 16:01:54 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140501210154.GC3907@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <87ppjxcjo2.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ppjxcjo2.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 01:45:33PM -0700, Andi Kleen wrote:
> Josh Poimboeuf <jpoimboe@redhat.com> writes:
> >
> > kpatch checks the backtraces of all tasks in stop_machine() to ensure
> > that no instances of the old function are running when the new function
> > is applied.
> 
> How does that work for tail calls? 
> 
>       call foo
> foo:
>       ...
>       jmp bar
> 
> bar:
>       ... code executing ...
> 
> When you backtrace you will see foo, but you are running in bar.

> Note that tail calls can be indirect, so they cannot be resolved
> statically.
> 
> CONFIG_DEBUG_INFO usually disables tail calls, but not supporting 
> it would seem like a large limitation, as the cost can be high.
> 
> It wouldn't surprise me if there are some similar special cases that
> can even happen with them disabled.
> 
> In theory you could read LBRs, but even that may miss some extreme
> cases.

When bar returns, would it skip foo and go straight back to foo's
caller?  If so, then it should be safe to patch foo after it jumps to
bar.

-- 
Josh
