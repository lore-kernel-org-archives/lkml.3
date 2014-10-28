Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaJ1Pmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:42:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:42822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750873AbaJ1Pmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:42:44 -0400
Date: Tue, 28 Oct 2014 11:42:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
Message-ID: <20141028114241.0bebcedd@gandalf.local.home>
In-Reply-To: <1414509951.6643.8.camel@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
	<20141028105831.69a14d4d@gandalf.local.home>
	<1414509951.6643.8.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 08:25:51 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2014-10-28 at 10:58 -0400, Steven Rostedt wrote:
> > On Mon, 29 Sep 2014 16:08:26 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > Adding repeated -1 to the return is not correct.
> > > Use seq_is_full to test for unnecessary seq_printf uses
> > > and always return 0.
> []
> > Actually, debugfs_print_regs32() should return void as well.
> > I'll update that.
> 
> Great though this should possibly be another patch.

Could have, but other patches that had functions returning the value of
seq_printf() also changed their output with the change. Don't worry
about being blamed, I update the change log to show that I modified it
too. ;-)

> 
> I didn't want to update the documentation.

It was a one liner, that didn't really change the content.

> 
> Maybe remove the prototype and make it static too.
> 

Now that can be a separate patch set if you want. I'm not too worried
about that as it doesn't affect the updates I want to do with
seq_file.

-- Steve

