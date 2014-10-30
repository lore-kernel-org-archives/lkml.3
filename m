Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaJ3AUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:20:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:16650 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755558AbaJ3AUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:20:53 -0400
Date: Wed, 29 Oct 2014 20:20:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFA][PATCH 1/8] seq_file: Rename seq_overflow() to
 seq_has_overflowed() and make public
Message-ID: <20141029202045.1988662c@gandalf.local.home>
In-Reply-To: <1414620516.2542.3.camel@perches.com>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.333126455@goodmis.org>
	<1414620516.2542.3.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 15:08:36 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-10-29 at 17:56 -0400, Steven Rostedt wrote:
> > +A true return from seq_has_overflowed means that the seq_file buffer is full
> > +and further output will be discarded.
> 
> Perhaps the description is a bit unclear here.
> 
> Doesn't a return of true to seq_has_overflowed mean that
> more characters have already been written than the buffer
> can accept?
> 

Actually, come to think about it. It really doesn't matter. As if it is
"full" or overflowed, the buffer currently gets discarded regardless.
Thus, it could mean that the buffer was already overflowed. Because the
current logic is full == overflowed. Really, a full buffer is a buffer
with all but one byte left used. If size == len, then it has indeed
overflowed.

That is what my other patch changes.

I'll change the comment about that.

-- Steve
