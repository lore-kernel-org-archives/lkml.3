Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaCBPcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:32:32 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:46236 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaCBPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:32:31 -0500
Date: Sun, 2 Mar 2014 10:34:38 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Andi Kleen <andi@firstfloor.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <87bnxp6g5t.fsf@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1403021028480.9864@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
 <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <40f095f7-605f-4885-951f-31da7d2d637a@email.android.com> <alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu>
 <20140228163039.6eb6a8d6@gandalf.local.home> <alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu> <20140228223651.485042cc@gandalf.local.home> <87bnxp6g5t.fsf@tassilo.jf.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2014, Andi Kleen wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> >
> > BTW, is the perf_fuzzer code posted somewhere? It sounds like it can be
> > really useful for us to do our own testing too.
> 
> I believe it's part of trinity.
> 
> http://codemonkey.org.uk/projects/trinity/
> 
> Perhaps it should have a "ftracer fuzzer" too?

It's not part of trinity, it's a separate project that re-uses some 
of trinity's codebase.

http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/

You can get the source as part of the perf_event_tests package
	https://github.com/deater/perf_event_tests

go into the fuzzer directory, run make, then "./perf_fuzzer".
You can also run the ./fast_repro.sh script instead, it's what I've
been using to track this kernel issue, although it tripped over the issue
a lot faster when compiled with -mx32 than it did when complied as native 
x86_64.

I think the code as found in the git tree should be working, I made a lot 
of changes when tracking this problem and I need to make sure I only check 
in the proper ones and not let any weird debugging patches slip in.

I'm aware of at least two other WARN messages and possibly one or two 
hard-lockup bugs in addition to the potential system reboot that can be 
triggered by the fuzzer, it just takes a while to isolate these things.

Vince


