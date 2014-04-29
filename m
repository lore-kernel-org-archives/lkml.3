Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbaD2PYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:24:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaD2PYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:24:37 -0400
Date: Tue, 29 Apr 2014 17:24:32 +0200 (CEST)
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
In-Reply-To: <20140429100345.3f76a5bd@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz> <20140429100345.3f76a5bd@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Steven Rostedt wrote:

> > According to 38.4 of [1], when SMM mode is entered while the CPU is 
> > handling NMI, the end result might be that upon exit from SMM, NMIs will 
> > be re-enabled and latched NMI delivered as nested [2].
> 
> Note, if this were true, then the x86_64 hardware would be extremely
> buggy. That's because NMIs are not made to be nested. If SMM's come in
> during an NMI and re-enables the NMI, then *all* software would break.
> That would basically make NMIs useless.
> 
> The only time I've ever witness problems (and I stress NMIs all the
> time), is when the NMI itself does a fault. Which my patch set handles
> properly. 

Yes, it indeed does. 

In the scenario I have outlined, the race window is extremely small, plus 
NMIs don't happen that often, plus SMIs don't happen that often, plus 
(hopefully) many BIOSes don't enable NMIs upon SMM exit.

The problem is, that Intel documentation is clear in this respect, and 
explicitly states it can happen. And we are violating that, which makes me 
rather nervous -- it'd be very nice to know what is the background of 38.4 
section text in the Intel docs.

-- 
Jiri Kosina
SUSE Labs
