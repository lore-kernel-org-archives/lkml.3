Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKFTY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:24:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:30843 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069AbaKFTYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:24:19 -0500
Date: Thu, 6 Nov 2014 14:24:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141106142402.0daada65@gandalf.local.home>
In-Reply-To: <20141106153107.GH2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.502133196@goodmis.org>
	<20141105163150.GI4570@pathway.suse.cz>
	<20141105152130.09779ccf@gandalf.local.home>
	<20141105160618.6c684f23@gandalf.local.home>
	<20141106153107.GH2001@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014 16:31:07 +0100
Petr Mladek <pmladek@suse.cz> wrote:

 
> I like the idea of having the exception only in the bitmap code and filling
> the whole buffer in other cases.
> 
> I am now in doubts about the overflow state. A solution would
> be to add an "overflow" flag to struct seq_bug. I agree that it
> is ugly but it looks more secure then "len = size + 1".
> 
> Well, I do not have that strong opinion about it. What do you think?

Ideally, I want struct seq_buf defined only within seq_buf.c, and all
users must access the buffer via function methods.

We would need to remove all the inline calls, which will have a small
affect on performance. But most seq_buf code is for output of text,
where this overhead would be a nit to the total cost of operations.

That would get rid of all users that think it's safe to access
s->buffer + s->len.

-- Steve
