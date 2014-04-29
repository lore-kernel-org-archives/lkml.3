Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbaD2Ssk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:48:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbaD2Ssh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:48:37 -0400
Date: Tue, 29 Apr 2014 20:48:34 +0200 (CEST)
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
In-Reply-To: <20140429131220.63069221@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1404292044240.16783@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz> <20140429100345.3f76a5bd@gandalf.local.home> <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz> <20140429120908.61ee947f@gandalf.local.home> <alpine.LNX.2.00.1404291835560.16783@pobox.suse.cz>
 <20140429131220.63069221@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Steven Rostedt wrote:

> > Just to be clear here -- I don't have a box that can reproduce this; I 
> > whole-heartedly believe that even if there are boxes with this behavior 
> > (and I assume there are, otherwise Intel wouldn't be mentioning it in the 
> > docs), it'd be hard to trigger on those.
> 
> I see your point. But it is documented for those that control both NMIs
> and SMMs. As it says in the document: "If the SMI handler requires the
> use of NMI interrupts". That to me sounds like a system that has
> control over both SMIs *and* NMIs. The BIOS should not have any control
> over NMIs, as the OS requires that. And the OS has no control over
> SMIs.
> 
> That paragraph sounds irrelevant to normal BIOS and OS systems as
> neither "owns" both SMIs and NMIs.

Which doesn't really help me being less nervous about this whole thing.

I don't believe Intel would put a completely arbitrary and nonsencial 
paragraph into the manual all of a sudden. It'd be great to know the 
rationale why this has been added in the first place.

> > We were hunting something completely different, and came through this 
> > paragraph in the Intel manual, and found it rather scary.
> 
> But this is all irrelevant anyway as this is all hypothetical and
> there's been no real world bug with this.

One would hope. Again -- I believe if this would trigger here and here a 
few times a year, everyone would probably atribute it to a "random hang", 
reboot, and never see the bug again.

-- 
Jiri Kosina
SUSE Labs
