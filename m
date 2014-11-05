Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKEVGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:06:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9823 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751017AbaKEVGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:06:20 -0500
Date: Wed, 5 Nov 2014 16:06:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141105160618.6c684f23@gandalf.local.home>
In-Reply-To: <20141105152130.09779ccf@gandalf.local.home>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.502133196@goodmis.org>
	<20141105163150.GI4570@pathway.suse.cz>
	<20141105152130.09779ccf@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:21:30 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> > 
> > I wonder if we want this change at all. It means that we are not able to
> > detect overflow in some functions. It is pity because the users
> > might want to increase the buffer size and try again if the print
> > was incomplete.
> 
> What do you mean we can't detect overflow? That's what
> seq_buf_has_overflowed() does.
> 

Although I'm looking at the seq_file versions of the bitmap code, which
does only return the len of what was written and not what would have
been written, and it does have this issue.

I hate to go back to the -1 of the size of buffer as that causes
inconsistencies within the functions themselves, as proved with the
seq_file code.

What I might do as just have the bitmap calls not be allowed to fill
the buffer and keep the logic the same. That is, if the bitmap calls
fill the rest of the length, assume we overflowed, otherwise we are
fine.

I'm going to change seq_buf to do that instead of my new update with
the bitmask code.

-- Steve
