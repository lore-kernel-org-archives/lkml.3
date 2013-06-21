Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098Ab3FUVOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:14:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:2319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945954Ab3FUVOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,915,1363158000"; 
   d="scan'208";a="357584388"
Message-ID: <1371849279.6453.44.camel@empanada>
Subject: Re: [PATCH 04/11] tracing: fix disabling of soft disable
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 16:14:39 -0500
In-Reply-To: <1371847171.18733.128.camel@gandalf.local.home>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C43537.8070300@hitachi.com>
	 <1371847171.18733.128.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 16:39 -0400, Steven Rostedt wrote:
> On Fri, 2013-06-21 at 20:12 +0900, Masami Hiramatsu wrote:
> > (2013/06/21 3:31), Tom Zanussi wrote:
> > > The comment on the soft disable 'disable' case of
> > > __ftrace_event_enable_disable() states that the soft disable bit
> > > should be cleared in that case, but currently only the soft mode bit
> > > is actually cleared.
> > > 
> > > This essentially leaves the standard non-soft-enable enable/disable
> > > paths as the only way to clear the soft disable flag, but the soft
> > > disable bit should also be cleared when removing a trigger with '!'.
> > 
> > Indeed, the soft-disabled flag may remain after the event itself
> > disabled. However that soft-disabled flag will be cleared when
> > the event is re-enabled. it seems no bad side-effect.
> > 
> > Thus I doubt this patch is separately required. I guess this is
> > required for adding new trigger flag, isn't it? :)
> 
> Tom, I'm guessing Masami is correct here. It's needed for the trigger
> work to work, correct?
> 

Well, the trigger should really work without this - this is basically
just a cleanup I added because it bothered me that I couldn't completely
revert the enable state back to the original state that existed before I
added the trigger (by reverting the trigger using '!').  It also just
seemed obviously correct from looking at the code as well (though I
agree, it's hard to keep the state machine of that function in your head
in order to prove it correct, and the straggling soft-disable state
hasn't bothered anyone until now, so maybe it's not worth it..)

In any case, if the SOFT_DISABLED bit is erroneously set but there are
no triggers, it shouldn't be a problem, since the trigger calls would
just return immediately, so not having this patch wouldn't break
anything... 

Tom


> Either way, I probably could add it as a clean up patch regardless. I'll
> just have to test the hell out of it some more, as the accounting for
> soft-disable vs real disable was a PITA.
> 


> -- Steve
> 


