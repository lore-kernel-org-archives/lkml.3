Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbaKNQWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:22:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965050AbaKNQWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:22:13 -0500
Date: Fri, 14 Nov 2014 11:21:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 12/23 v4] tracing: Remove return values of most
 trace_seq_*() functions
Message-ID: <20141114112152.25542b93@gandalf.local.home>
In-Reply-To: <20141114095339.79e7e51c@gandalf.local.home>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.992510720@goodmis.org>
	<20141114131728.GC2988@dhcp128.suse.cz>
	<20141114095339.79e7e51c@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 09:53:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> > > @@ -334,10 +297,7 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> > >  		/* j increments twice per loop */
> > >  		len -= j / 2;
> > >  		hex[j++] = ' ';
> > > -
> > > -		cnt += trace_seq_putmem(s, hex, j);
> > 
> > trace_seq_putmem(s, hex, j); should stay ;-)
> 
> Ouch! Looks like I got a little happy with the delete line key stroke.
> 
> Good catch!
> 

And in the end it really didn't matter, as the patch "tracing: Create
seq_buf layer in trace_seq" took all this out.

I'll still update the patch for correctness.

Thanks,

-- Steve
