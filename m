Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaI2QL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:11:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:26080 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753991AbaI2QL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:11:27 -0400
Date: Mon, 29 Sep 2014 12:11:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Petr Mladek <pmladek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929121125.4e2d6495@gandalf.local.home>
In-Reply-To: <1412005610.4302.26.camel@joe-AO725>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
	<20140929112538.3929a9a2@gandalf.local.home>
	<1412005610.4302.26.camel@joe-AO725>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 08:46:50 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-09-29 at 11:25 -0400, Steven Rostedt wrote:
> > Anyway, that should be a second patch, and we should get my current
> > patch (the one to make putc and puts the same) in first, as that
> > actually fixes the inconsistency between the two.
> > 
> > I'll post another patch to try to make seq_file operations a bit more
> > consistent. Perhaps we can have m->count be what would have been
> > written.
> 
> https://lkml.org/lkml/2013/9/11/801
> 

That has nothing to do with what I'm working on. I'm not touching the
return value of the seq_*() functions. I may make them all return void
though.

I may just make m->count == m->size + 1 for all cases. The m->count ==
what would have been written is if seq_buf() needs it. Which I highly
doubt it would.

-- Steve
