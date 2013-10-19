Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3JSWCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:02:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51772 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751481Ab3JSWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:02:40 -0400
Date: Sat, 19 Oct 2013 18:02:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Petr Mladek <pmladek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Message-ID: <20131019180239.1e318628@gandalf.local.home>
In-Reply-To: <20131019213350.GH4118@linux.vnet.ibm.com>
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
	<52629F08.2010609@hitachi.com>
	<20131019151658.583ac18e@gandalf.local.home>
	<20131019151919.2d4778d2@gandalf.local.home>
	<20131019213350.GH4118@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013 14:33:50 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

 
> > > It's used to convert the calls to mcount to nops. But maybe a better
> > > thing to do is to check if we only have a single CPU:
> > > 
> > > static void run_sync(void)
> > > {
> > > 	if (num_online_cpus() != 1)
> > 
> > Hmm, to be more robust to handle our future "ideal" machines, perhaps
> > this should be:
> > 
> > 	/* Ideally we would like to run on zero CPUS! */
> > 	if (num_online_cpus() < 2)
> 

Bah! And for such a simple computation, I got it wrong.


	/* Ideally we would like to run on zero CPUS! */
	if (num_online_cpus > 1)

But I guess the question comes. If we are running on zero CPUS, should
we perform the "on_each_cpu(do_sync_core, NULL, 1);" or not? Same goes
with 5i-3 CPUS, or negative number CPUs. If we need to do on_each_cpu(),
then I guess the != 1 will suffice.

-- Steve
