Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAKCbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 21:31:21 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57398 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAKCbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 21:31:19 -0500
X-Nat-Received: from [202.181.97.72]:57695 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389407424.11745
To: joe@perches.com, akpm@linux-foundation.org
Cc: pavel@ucw.cz, keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
	<201401111059.HCH39012.MFtVHFOFQOLOJS@I-love.SAKURA.ne.jp>
	<1389406553.2537.52.camel@joe-AO722>
In-Reply-To: <1389406553.2537.52.camel@joe-AO722>
Message-Id: <201401111130.HJG17194.MHFOOOQLtSJFFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 11:30:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7296163, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2014-01-11 at 10:59 +0900, Tetsuo Handa wrote:
> > I just added noinline_for_stack as with other functions does.
> > But indeed, stack used by name[] is only 16 bytes but stack used by function
> > arguments are larger than 16 bytes. We should remove noinline_for_stack ?
> 
> My recollection is that certain gcc versions don't do
> well with multiple inline functions that have stack
> variables.
> 
> Instead of collapsing the variables, gcc will
> accumulate the stack depth of all the inlines
> args instead of reusing the stack.
> 

I tried what commit cf3b429b "vsprintf.c: use noinline_for_stack" says
using gcc 4.4.7, but it made no difference for stack usage.
Thus, it seems harmless to keep noinline_for_stack keyword.
