Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaFWRig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:38:36 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:46373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbaFWRif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:38:35 -0400
Message-ID: <1403545094.4418.32.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Date: Mon, 23 Jun 2014 19:38:14 +0200
In-Reply-To: <20140623120805.1624e1db@gandalf.local.home>
References: <20140619213329.478113470@goodmis.org>
	 <20140619213952.058255809@goodmis.org>
	 <20140619220607.c6da2540.akpm@linux-foundation.org>
	 <20140620125823.5acb12dd@gandalf.local.home>
	 <1403422685.4418.4.camel@jlt4.sipsolutions.net>
	 <20140623120805.1624e1db@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 12:08 -0400, Steven Rostedt wrote:
> On Sun, 22 Jun 2014 09:38:05 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> 
> > Looking at the code though, I'm not sure it's a pure optimisation - if
> > you do say putc() after a failed puts(), without this code the putc()
> > would succeed? I can't tell right now if that's really a problem, but it
> > seems you could get some odd behaviour out of it.
> 
> How would putc() still succeed? We're just talking about the "full"
> field. It would still do the length check:
> 
> 	if (s->len >= (PAGE_SIZE - 1))
> 		return 0;

Right, but the puts() could fail if not all of the string fits, and a
subsequent putc() might fit.

johannes

