Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3JRPBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:01:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17193 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069Ab3JRPB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:01:29 -0400
Date: Fri, 18 Oct 2013 11:01:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 5/6] x86: patch all traced function calls using the
 int3-based framework
Message-ID: <20131018110128.7033ce4c@gandalf.local.home>
In-Reply-To: <20131018105557.0961a2f5@gandalf.local.home>
References: <1382106445-31468-6-git-send-email-pmladek@suse.cz>
	<20131018105557.0961a2f5@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 10:55:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 18 Oct 2013 16:27:24 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> 
> > +/*
> > + * We do not want to replace ftrace calls one by one because syncing all CPUs
> > + * is quite expensive.
> > + *
> > + * On the other hand, we do not want to modify all calls at once because
> > + * the buffers for text_poke_bp might be quite huge. Also we do not want
> > + * to count the number of records before the allocation.
> > + *
> > + * Let's modify the call in batches defined by this define.
> > + */
> > +#define FTRACE_MAX_RECS_PATCH 8192
> >  
> > -static int finish_update(struct dyn_ftrace *rec, int enable)
> > +static int ftrace_allocate_replace_buffers(unsigned long **addr, void **opcode)
> 
> I absolutely hate this. Current ftrace conversion does not need to
> allocate at all. I want to keep it that way.
> 

I should clarify that I do not hate the patch set. I actually like what
it's trying to achieve (a lot!). But I absolutely hate having to copy
records to do the bulk conversion. That part I'm giving a NAK to.

Add a text_poke_bp_iterate() or something, that removes the need for
allocating extra buffers, then I'll be very happy :-)

-- Steve
