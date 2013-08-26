Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3HZRu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab3HZRu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:50:28 -0400
Date: Mon, 26 Aug 2013 13:50:12 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826175012.GA25202@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826133041.3d750b1b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 01:30:41PM -0400, Steven Rostedt wrote:

 > > On Mon, Aug 26, 2013 at 10:58:38AM -0400, Dave Jones wrote:
 > > > Another day, another rcu backtrace..
 > > > This says rc6, but it's pretty darn close to rc7, I think it was running
 > > > a build from Friday.
 > > 
 > > Could you please send your .config?  Also, were you running ftrace,
 > > perf, RCU event tracing, or what?
 > > 
 > > Looks like you are running ftrace, but I though Steven had set that
 > > up so that it could be called from an extended quiescent state.
 > > 
 > 
 > I know exactly what the issue is. Yes ftrace is safe to call even from
 > these extended quiescent states, the problem is that ftrace is also the
 > infrastructure of other users, where some of those users are not safe.
 > Namely, perf.
 > 
 > Right now perf is not safe to trace all functions, as some of those
 > functions have this issue. I was going to add something like:
 > 
 > FTRACE_NON_SAFE(rcu_eqs_enter);
 > 
 > where it will record locations that are not safe for all users, such
 > that unless a function registers to ftrace with a flag of
 > "FTRACE_FL_NON_SAFE_OK", anything that is on the non safe list (from
 > the macro) will not be traced.
 > 
 > Now, how urgent is this fix? perf can only trace functions as root, and
 > there's no reason for perf to be tracing all functions at the moment.
 > But yes, a root user could run that and get this warning. Because I was
 > going to implement this for 3.12 and not for this release.

This was triggered as a regular user fwiw.
I had not been running perf, or any other tracing. It was just left
fuzzing over the weekend with no interaction at all.

	Dave

