Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaJ3AK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:10:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:6454 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932318AbaJ3AK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:10:58 -0400
Date: Wed, 29 Oct 2014 20:10:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFA][PATCH 1/8] seq_file: Rename seq_overflow() to
 seq_has_overflowed() and make public
Message-ID: <20141029201048.698eb701@gandalf.local.home>
In-Reply-To: <1414626810.2542.5.camel@perches.com>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.333126455@goodmis.org>
	<1414620516.2542.3.camel@perches.com>
	<20141029194215.44e86ffb@gandalf.local.home>
	<1414626810.2542.5.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 16:53:30 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-10-29 at 19:42 -0400, Steven Rostedt wrote:
> > On Wed, 29 Oct 2014 15:08:36 -0700 Joe Perches <joe@perches.com> wrote:
> > > On Wed, 2014-10-29 at 17:56 -0400, Steven Rostedt wrote:
> > > > +A true return from seq_has_overflowed means that the seq_file buffer is full
> > > > +and further output will be discarded.
> > > Perhaps the description is a bit unclear here.
> > > Doesn't a return of true to seq_has_overflowed mean that
> > > more characters have already been written than the buffer
> > > can accept?
> > Actually, right now the comment is correct and the name is misleading.
> > But I have a patch that will make the comment incorrect (and will be
> > fixed) and the name correct.
> > 
> > But since seq_has_overflowed() is to be used throughout the kernel, I
> > didn't want to have to go do patches all over again for a temporary
> > misnomer.
> 
> I think it'd be better if the first submission
> of the function has the correct operation for
> the name.

I'm hoping that both of these will make it into 3.19, so it really
doesn't matter the order. I'm working on this patch first, because, as
you said earlier, it is important to get the call to
seq_has_overflowed() out there.

> 
> > In other words, I'm going to change the function to really return only
> > if it did overflow and not just be full. But that's another patch set
> > to come.
> 
> Why would it be a set and not a single patch?
> 

That particular change is a single patch. But it is in with other
patches I'm doing, so I called it a patch set.

-- Steve

