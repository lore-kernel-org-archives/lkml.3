Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaAKBtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:49:08 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50359 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAKBtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:49:04 -0500
X-Nat-Received: from [202.181.97.72]:56365 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389404902.24255
To: joe@perches.com
Cc: akpm@linux-foundation.org, pavel@ucw.cz, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
	<201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
	<1389404212.2537.47.camel@joe-AO722>
In-Reply-To: <1389404212.2537.47.camel@joe-AO722>
Message-Id: <201401111048.IFE82362.VOOSJHFFQMLtOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 10:48:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7296163, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2014-01-11 at 10:28 +0900, Tetsuo Handa wrote:
> >   Step 1: (targeted to 3.14-rc1)
> >     Add "%pT" format specifier and commcpy() wrapper function.
> > 
> >   Step 2: (started after step 1 is reflected to other git trees)
> >     Replace printk("%s", p->comm) with printk("%pT", p).
> 
> Replace printk("%s", current->comm) with printk("%pT", NULL);
> 
> ?

Right. I forgot to add it.

> 
> >     Replace strcpy(buf, p->comm) with commcpy(buf, p).
> 
> >   Step 3: (started after step 2 is reflected to other git trees)
> >     Add rcu_read_lock()/rcu_read_unlock() into commcpy().
> >     Modify set_task_comm() etc. to replace ->comm using RCU.
> 
> Aren't steps 2 and 3 independent?
> 

If step 3 is merged before step 2 complete, those who are not using
"%pT" or commcpy() might crash due to reading RCU protected ->comm without
rcu_read_lock()/rcu_read_unlock(). 

Step 2 depends on step 1 for avoiding compile time errors.
Step 3 depends on step 2 for avoiding run time errors.
