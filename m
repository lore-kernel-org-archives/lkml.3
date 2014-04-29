Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaD2QvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:51:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaD2QvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:51:16 -0400
Date: Tue, 29 Apr 2014 18:51:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
In-Reply-To: <20140429120908.61ee947f@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1404291835560.16783@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz> <20140429100345.3f76a5bd@gandalf.local.home> <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz> <20140429120908.61ee947f@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Steven Rostedt wrote:

> You keep saying 38.4, but I don't see any 38.4. Perhaps you meant 34.8?

Yeah, sorry for the typo.

> Which BTW is this:
> 
> ----
> 34.8 NMI HANDLING WHILE IN SMM
[ ... snip ... ]
> ----
> 
> Read the first paragraph. That sounds like normal operation. The SMM
> should use the RSM to return and that does not re-enable NMIs if the
> SMM triggered during an NMI.

Yup, so far so good.

> The above is just stating that the SMM can enable NMIs if it wants to
> by executing an IRET. Which to me sounds rather buggy to do.

That's exactly the point actually. Basically, that paragraph allows the 
SMM code writers to issue iret. If they do it, the very problem I am 
trying to describe here might happen.

> Now the third paragraph is rather ambiguous. It sounds like it's still
> talking about doing an IRET in the SMI handler. As the IRET will enable
> NMIs, and if the SMI happened while an NMI was happening, the new NMI
> will happen. In this case, the NMI handler needs to address this. But
> this really sounds like if you have control of both SMM handlers and
> NMI handlers, which the Linux kernel certainly does not. Again, I label
> this as a bug in the BIOS.
> 
> And again, if the SMM were to trigger a fault, it too would enable
> NMIs. That is something that the SMM handler should not do.

That's what the last paragraph is talking about BTW, related to Pentium 
CPUs. That part is scary by itself.

> Can you reproduce your problem on different platforms, or is this just
> one box that exhibits this behavior? If it's only one box, I'm betting
> it has a BIOS doing nasty things.

Just to be clear here -- I don't have a box that can reproduce this; I 
whole-heartedly believe that even if there are boxes with this behavior 
(and I assume there are, otherwise Intel wouldn't be mentioning it in the 
docs), it'd be hard to trigger on those.

We were hunting something completely different, and came through this 
paragraph in the Intel manual, and found it rather scary.

-- 
Jiri Kosina
SUSE Labs
