Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKFPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:01:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46338 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaKFPBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:01:25 -0500
Date: Thu, 6 Nov 2014 16:01:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated
 trampoline for ftrace_ops
Message-ID: <20141106150122.GB4318@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
 <20141027182948.284867581@goodmis.org>
 <20141105102801.GA5245@pd.tnic>
 <20141106085715.2ba0771e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141106085715.2ba0771e@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:57:15AM -0500, Steven Rostedt wrote:
> > > +/* Trampolines can only be created if modules are supported */
> > 
> > Just for my own understanding: why? You're not loading additional .ko's
> > right?
> 
> It goes back to the EXEC issue. The module allocation goes through
> leaps and bounds to get memory allocated for EXEC correct. I wasn't
> about to duplicate that.
> 
> Ideally, there should be a generic way to allocate memory that will be
> used for executing code, but right now we depend on module code.

Yah, that could be a nice addition (in a separate patch, ontop, as you
say) to explain the dependency on CONFIG_MODULES, which is not trivially
apparent.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
