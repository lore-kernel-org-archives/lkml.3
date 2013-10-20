Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab3JTPmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 11:42:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50517 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3JTPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 11:42:09 -0400
Date: Sun, 20 Oct 2013 08:42:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Petr Mladek <pmladek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Message-ID: <20131020154203.GN4118@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
 <52629F08.2010609@hitachi.com>
 <20131019151658.583ac18e@gandalf.local.home>
 <20131019151919.2d4778d2@gandalf.local.home>
 <20131019213350.GH4118@linux.vnet.ibm.com>
 <20131019180239.1e318628@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019180239.1e318628@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102015-1344-0000-0000-0000029BD641
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 06:02:39PM -0400, Steven Rostedt wrote:
> On Sat, 19 Oct 2013 14:33:50 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > > It's used to convert the calls to mcount to nops. But maybe a better
> > > > thing to do is to check if we only have a single CPU:
> > > > 
> > > > static void run_sync(void)
> > > > {
> > > > 	if (num_online_cpus() != 1)
> > > 
> > > Hmm, to be more robust to handle our future "ideal" machines, perhaps
> > > this should be:
> > > 
> > > 	/* Ideally we would like to run on zero CPUS! */
> > > 	if (num_online_cpus() < 2)
> > 
> 
> Bah! And for such a simple computation, I got it wrong.
> 
> 
> 	/* Ideally we would like to run on zero CPUS! */
> 	if (num_online_cpus > 1)
> 
> But I guess the question comes. If we are running on zero CPUS, should
> we perform the "on_each_cpu(do_sync_core, NULL, 1);" or not? Same goes
> with 5i-3 CPUS, or negative number CPUs. If we need to do on_each_cpu(),
> then I guess the != 1 will suffice.

Makes sense to me!  Whoever adds the ability to run on zero, negative,
or complex numbers of CPUs can adjust on_each_cpu() accordingly.

							Thanx, Paul

