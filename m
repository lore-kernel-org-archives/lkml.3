Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaFWQIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:08:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:23489 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755251AbaFWQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:08:08 -0400
Date: Mon, 23 Jun 2014 12:08:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-ID: <20140623120805.1624e1db@gandalf.local.home>
In-Reply-To: <1403422685.4418.4.camel@jlt4.sipsolutions.net>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<20140619220607.c6da2540.akpm@linux-foundation.org>
	<20140620125823.5acb12dd@gandalf.local.home>
	<1403422685.4418.4.camel@jlt4.sipsolutions.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014 09:38:05 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:


> Looking at the code though, I'm not sure it's a pure optimisation - if
> you do say putc() after a failed puts(), without this code the putc()
> would succeed? I can't tell right now if that's really a problem, but it
> seems you could get some odd behaviour out of it.

How would putc() still succeed? We're just talking about the "full"
field. It would still do the length check:

	if (s->len >= (PAGE_SIZE - 1))
		return 0;

-- Steve
