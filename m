Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaI2QPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:15:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:2821 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754260AbaI2QPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:15:37 -0400
Date: Mon, 29 Sep 2014 12:15:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929121534.34c3ebd9@gandalf.local.home>
In-Reply-To: <1412006881.4302.29.camel@joe-AO725>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
	<20140929154711.GF7996@ZenIV.linux.org.uk>
	<1412006881.4302.29.camel@joe-AO725>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 09:08:01 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-09-29 at 16:47 +0100, Al Viro wrote:
> > On Mon, Sep 29, 2014 at 04:41:22PM +0200, Petr Mladek wrote:
> > > Hmm, this inconsistency seems to be in more functions. I would divide
> > > it into three categories:
> []
> > No.  _Any_ caller that decides to report that error to its caller is fucking
> > broken.  We had some cases like that.
> []
> > And let's make seq_printf and friends return void.  Any breakage we miss
> > on grep will be caught by compiler.  Enough is enough.
> 
> https://lkml.org/lkml/2013/12/11/8
> 

Since you like posting links:

https://lkml.org/lkml/2013/12/11/76

If you want to resurrect your patches, go ahead. I'll pull them into my
list. Probably should rename seq_overflow() to seq_is_full(), which
makes it sound less of an error.

And as Al noted, only fix what's there (just the places that check the
return values). Don't add anything else.

-- Steve
