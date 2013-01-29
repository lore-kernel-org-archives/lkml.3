Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3A2SF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:05:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3A2SF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:05:26 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6f0zkeQHV1kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=y0H1T4b0-z4A:10 a=heGAstucJEVD2p3ktkEA:9 a=PUjeQqilurYA:10 a=KAc_-xApNX5yArX8:21 a=yoBFXbWdPLill11U:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359482724.17639.48.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated
 header file
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <williams@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 29 Jan 2013 13:05:24 -0500
In-Reply-To: <20130129115743.0f9e67dc@redhat.com>
References: <20130128143120.1b60bfb6@redhat.com>
	 <87vcagv808.fsf@sejong.aot.lge.com> <20130129115743.0f9e67dc@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 11:57 -0600, Clark Williams wrote:

> > > +/* provide a home for sysctl scheduler tuning knobs */
> > > +
> > > +/*
> > > + * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> > > + * Timeslices get refilled after they expire.
> > > + */
> > > +#define RR_TIMESLICE		(100 * HZ / 1000)
> > 
> > It seems this line came from sched.h but I can't find that part
> > deleted.
> > 
> 
> Arggghh! I reorganized the commits and didn't remove RR_TIMESLICE when
> I moved it. I'm surprised it compiled. 
> 
> I can generate a new patchset or let Ingo just remove it from sched.h.

gcc won't warn if you define a macro to what it is already defined to.

#define foo bar
#define foo bar

won't warn


#define foo bar
#define foo cat

will.

-- Steve


