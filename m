Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKGJLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:11:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaKGJLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:11:13 -0500
Date: Fri, 7 Nov 2014 10:11:07 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141107091107.GA1136@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.502133196@goodmis.org>
 <20141105163150.GI4570@pathway.suse.cz>
 <20141105152130.09779ccf@gandalf.local.home>
 <20141105160618.6c684f23@gandalf.local.home>
 <20141106153107.GH2001@dhcp128.suse.cz>
 <20141106142402.0daada65@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106142402.0daada65@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-06 14:24:02, Steven Rostedt wrote:
> On Thu, 6 Nov 2014 16:31:07 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
>  
> > I like the idea of having the exception only in the bitmap code and filling
> > the whole buffer in other cases.
> > 
> > I am now in doubts about the overflow state. A solution would
> > be to add an "overflow" flag to struct seq_bug. I agree that it
> > is ugly but it looks more secure then "len = size + 1".
> > 
> > Well, I do not have that strong opinion about it. What do you think?
> 
> Ideally, I want struct seq_buf defined only within seq_buf.c, and all
> users must access the buffer via function methods.
> 
> We would need to remove all the inline calls, which will have a small
> affect on performance. But most seq_buf code is for output of text,
> where this overhead would be a nit to the total cost of operations.
> 
> That would get rid of all users that think it's safe to access
> s->buffer + s->len.

Sounds like a good plan.

Best Regards,
Petr
