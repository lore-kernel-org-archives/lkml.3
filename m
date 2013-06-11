Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3FKAhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 20:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab3FKAhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 20:37:17 -0400
Date: Mon, 10 Jun 2013 20:37:12 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/trace/ftrace.c:1605
 __ftrace_hash_rec_update.part.37+0x20a/0x240()
Message-ID: <20130611003712.GA9537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130610234806.GA7069@redhat.com>
 <1370910794.9844.150.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370910794.9844.150.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 08:33:14PM -0400, Steven Rostedt wrote:
 > On Mon, 2013-06-10 at 19:48 -0400, Dave Jones wrote:
 > > 3.10-rc5 + the two patches referenced in the RCU thread from earlier.
 > > 
 > > 	Dave
 > > 
 > > [ 2313.381283] WARNING: at kernel/trace/ftrace.c:1605 __ftrace_hash_rec_update.part.37+0x20a/0x240()
 > 
 > Grumble,
 > 
 > Somehow the list of functions that perf enabled got out of sync with
 > what ftrace had. When perf disabled its list of functions from ftrace,
 > perf thought it had a function enabled that wasn't and ftrace cried
 > about that.
 > 
 > What does 'trinity-child2' do?

Same as all the other child processes. Random syscalls, semi-intelligent args.

 > and is this reproducible?

I'm sure I'll hit it again eventually.  The This one looks tricky because
the trace isn't a syscall that I can go hammer on, it's happening
at process exit time.

	Dave

