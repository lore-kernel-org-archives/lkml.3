Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3L1UGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 15:06:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3L1UGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 15:06:21 -0500
Date: Sat, 28 Dec 2013 12:08:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-Id: <20131228120815.31f7d378.akpm@linux-foundation.org>
In-Reply-To: <1388260405.24123.18.camel@joe-AO722>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	<20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
	<201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
	<CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
	<20131228112509.8a62548c.akpm@linux-foundation.org>
	<CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
	<1388260405.24123.18.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:

> > > #define PRINTK_PID      "\002"
> > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> > >
> > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > >
> > > It's certainly compact.  I doubt if there's any existing code which
> > > deliberately prints control chars?
> > 
> > But the rest looks OK to me.
> 
> Tell me again, what's wrong with using p or current?
> 
> printk("%pt", current);

Nothing much.  It's just that all these callsites are generating the
code to pass an argument which the callee already has access to. 
Optimizing that will reduce text size a bit.

There's also the matter of providing a standard and abstracted way of
representing a task, instead of directly accessing its ->comm.  But
that's a separate thing from new printk tokens.
