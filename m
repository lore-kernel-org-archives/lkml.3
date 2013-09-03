Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab3ICWSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:18:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39816 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021Ab3ICWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:18:13 -0400
Date: Tue, 3 Sep 2013 15:18:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130903221808.GH3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.601365837@goodmis.org>
 <20130903171516.16290c47@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903171516.16290c47@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090322-1542-0000-0000-0000011BA959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:15:16PM -0400, Steven Rostedt wrote:
> On Sat, 31 Aug 2013 01:11:18 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index a6d098c..3750360 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1356,6 +1356,23 @@ ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
> >  static void
> >  ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
> >  
> > +static int ftrace_convert_size_to_bits(int size)
> > +{
> > +	int bits;
> > +
> > +	/*
> > +	 * Make the hash size about 1/2 the # found
> > +	 */
> > +	for (size /= 2; size; size >>= 1)
> > +		bits++;
> > +
> > +	/* Don't allocate too much */
> > +	if (bits > FTRACE_HASH_MAX_BITS)
> > +		bits = FTRACE_HASH_MAX_BITS;
> > +
> > +	return bits;
> > +}
> > +
> 
> Just found this bug. Strange that gcc never gave me a warning :-/

I can't give gcc too much trouble, as I also didn't give you an
uninitialized-variable warning.

							Thanx, Paul

