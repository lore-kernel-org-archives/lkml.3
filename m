Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaFDBRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:17:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53196 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487AbaFDBQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:16:59 -0400
Date: Tue, 3 Jun 2014 21:16:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603211651.79263d7e@gandalf.local.home>
In-Reply-To: <20140603192525.GA1105@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
	<20140603140529.048701b9@gandalf.local.home>
	<20140603192525.GA1105@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 21:25:25 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 06/03, Steven Rostedt wrote:
> >
> > You know, this code could use some comments. I may send you a patch,
> > because that __lock_task_sighand() is doing a lot of subtle things and
> > there's not a single comment explaining it :-(
> 
> Yes, agreed. Not only SLAB_DESTROY_BY_RCU is not obvious, local_irq_save()
> is not clear at all. The latter already has a doc patch from Paul, I'll try
> to add more comments on top once I see that patch in Linus's tree.
> 
> But I would be happy if you send the patch ;)
> 
> And this reminds me... I still think that __lock_task_sighand() should be
> de-uglified. I already sent the patch, probably I'll resend it.

I'd be happy to document the hell out of that function, but it sounds
like you have some updates to it. Is there a git repo somewhere with
your latest that I can base a patch against?

-- Steve
