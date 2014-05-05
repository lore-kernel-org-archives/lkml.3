Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaEER35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:29:57 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55562 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaEER34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:29:56 -0400
Date: Mon, 5 May 2014 19:29:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140505172951.GB7154@gmail.com>
References: <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502172731.GK30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Mon, 5 May 2014, Peter Zijlstra wrote:
> 
> > Does this one work better? Making sure all __perf_remove_from_context()
> > callers pass the right structure seems to improve things no end. My
> > machine is now happy to reboot again.
> 
> Yes, I've been fuzzing this for a few hours on both my haswell and core2 
> test systems and it's doing great, also survived a reboot cycle.
> 
> Tested-by: Vince Weaver <vincent.weaver@maine.edu>

I wish there was a stronger tag that would credit your efforts! ...

Kudos!

> (Although often things like to crash the instant my tested-by 
> e-mails clear the lkml list.)
> 
> I also want to say thanks for all the work everyone has done in 
> getting this analyzed and fixed.

I'm also thinking about waiting a bit before applying anything even 
borderline intrusive to the perf core, to make sure there's enough 
fuzz time to declare stable state (at least as far into the ABI as the 
fuzzing is able to reach). Future bisection efforts could use that 
kind of known-stable release.

Thanks,

	Ingo
