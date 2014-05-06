Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbaEFKCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:02:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62162 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558AbaEFKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:02:23 -0400
Date: Tue, 6 May 2014 12:02:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140506100217.GA27774@gmail.com>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
 <20140429100345.3f76a5bd@gandalf.local.home>
 <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 29 Apr 2014, Steven Rostedt wrote:
> 
> > > According to 38.4 of [1], when SMM mode is entered while the CPU is 
> > > handling NMI, the end result might be that upon exit from SMM, NMIs will 
> > > be re-enabled and latched NMI delivered as nested [2].
> > 
> > Note, if this were true, then the x86_64 hardware would be extremely
> > buggy. That's because NMIs are not made to be nested. If SMM's come in
> > during an NMI and re-enables the NMI, then *all* software would break.
> > That would basically make NMIs useless.
> > 
> > The only time I've ever witness problems (and I stress NMIs all the
> > time), is when the NMI itself does a fault. Which my patch set handles
> > properly. 
> 
> Yes, it indeed does.
> 
> In the scenario I have outlined, the race window is extremely small, 
> plus NMIs don't happen that often, plus SMIs don't happen that 
> often, plus (hopefully) many BIOSes don't enable NMIs upon SMM exit.

Note, the "NMIs don't happen that often" condition is pretty rare on 
x86 Linux systems. These days anyone doing a 'perf top', 'perf record' 
or running a profiling tool like SysProf will generate tens of 
thousands of NMIs, per second. Systems with profiling active are 
literally bathed in NMIs, and that is how we found the page fault NMI 
bug.

So I'd say any race condition hypothesis assuming "NMIs are rare" is 
probably invalid on modern Linux systems.

Thanks,

	Ingo
