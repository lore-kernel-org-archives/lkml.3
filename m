Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161611AbaKNRep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:34:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:13271 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161180AbaKNReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:34:44 -0500
Date: Fri, 14 Nov 2014 12:34:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 19/23 v4] seq_buf: Create seq_buf_used() to find
 out how much was written
Message-ID: <20141114123442.4669a0f4@gandalf.local.home>
In-Reply-To: <20141114172306.GE14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011413.321654244@goodmis.org>
	<20141114172306.GE14538@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 18:23:06 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Thu 2014-11-13 20:13:03, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
> > private macro to let callers have a method to know how much of the
> > seq_buf was written to.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> 
> The patch is correct. But we should move it before "[RFC][PATCH 17/23
> v4] tracing: Have seq_buf use full buffer" and use it everywhere
> any code is accessing the internal buffer using the seq.len value.
> I mean to solve the potential buffer overflows mentioned for
> "[RFC][PATCH 13/23 v4] tracing: Create seq_buf layer in trace_seq"
> 
> Best Regards,

Bah, I'm getting seq_buf_buffer_left() confused with seq_buf_used().
Yes, this should be moved before hand. I thought it was by looking at:

git show <patch-17-SHA1>:include/linux/seq_buf.h

I saw the seq_buf_buffer_left() and confused that with seq_buf_used()
and said to myself "oh good, it has the function I need". Not!

Thanks,

-- Steve
