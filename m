Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaJ1R06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:26:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:56795 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925AbaJ1R04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:26:56 -0400
Date: Tue, 28 Oct 2014 13:26:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
Message-ID: <20141028132654.7d020288@gandalf.local.home>
In-Reply-To: <20141028171409.GH1193@ld-irv-0074>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	<20141022082916.GD16128@brian-ubuntu>
	<20141028111301.22481f2a@gandalf.local.home>
	<1414511877.6643.12.camel@perches.com>
	<20141028120552.63c2324c@gandalf.local.home>
	<20141028171409.GH1193@ld-irv-0074>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 10:14:09 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Tue, Oct 28, 2014 at 12:05:52PM -0400, Steven Rostedt wrote:
> > On Tue, 28 Oct 2014 08:57:57 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > On Tue, 2014-10-28 at 11:13 -0400, Steven Rostedt wrote:
> > > > I'm going to be working on changes to remove the return value of
> > > > seq_printf() and friends.
> > > 
> > > I'm sure you know all of this, but for anyone else:
> > > 
> > > This doesn't need to be done in a single pass.
> > 
> > Yeah, I took a look at all the places, and I've decided to take it off
> > in chunks. I'm starting with the ones you posted, and will try to get
> > acks for them. And then go after other chunks as I have time.
> 
> I'll keep this in my tree as-is for now. Let me know if you still need
> something changed. I can give my 'Ack' if you really want to pull this
> into a separate branch.

If I get to a point where I can change the seq_printf() to return void,
then I'll want it, otherwise without it, it will cause my branch to fail
to compile on that code.

That's why I would like it. If we keep it in your tree and have that for
the next release, it will matter which tree goes into Linus's tree
first. If mine goes in first, then it will break his build.

Now, that's assuming I get this ready for 3.19, as I'll need quite a
few Acked-by's for the changes that I'll be making. If I don't get it
by 3.19, then it wont be an issue if that change goes in with your tree.

-- Steve

> 
> BTW, I just noticed the $subject has a typo: s/miuse/misuse/
