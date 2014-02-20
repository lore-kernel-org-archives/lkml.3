Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaBTPam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:30:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38393 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752160AbaBTPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:30:41 -0500
Date: Thu, 20 Feb 2014 10:30:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140220103033.32860caf@gandalf.local.home>
In-Reply-To: <878uteecu0.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<877g8zg0ed.fsf@rustcorp.com.au>
	<20140213161156.3548df43@gandalf.local.home>
	<878uteecu0.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to clean out my email box. This email was hidden in between a
pile of other crap email.

On Fri, 14 Feb 2014 11:21:19 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > On Thu, 13 Feb 2014 13:54:42 +1030
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> >
> >> I'm ambivalent towards out-of-tree modules, so not tempted unless I see
> >> a bug report indicating a concrete problem.  Then we can discuss...
> >
> > As I replied in another email, this is a concrete problem, and affects
> > in-tree kernel modules.
> >
> > If you have the following in your .config:
> >
> > CONFIG_MODULE_SIG=y
> > # CONFIG_MODULE_SIG_FORCE is not set
> > # CONFIG_MODULE_SIG_ALL is not set
> 
> This means you've set the "I will arrange my own module signing" config
> option:
> 
> 	  Sign all modules during make modules_install. Without this option,
> 	  modules must be signed manually, using the scripts/sign-file tool.
> 
> comment "Do not forget to sign required modules with scripts/sign-file"
> 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
> 
> Then you didn't do that.  You broke it, you get to keep both pieces.

In this case we should fail the module load all together, and require
insmod to add the --force flag to load it. Why the hell are we setting
a FORCED_MODULE flag when no module was forced????

-- Steve

> 
> Again: is there an actual valid use case?
> Rusty.

