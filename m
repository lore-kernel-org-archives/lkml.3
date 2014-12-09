Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaLIOH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:07:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53661 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaLIOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:07:58 -0500
Date: Tue, 9 Dec 2014 06:07:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: linux-next: build failure after merge of the rcu tree
Message-ID: <20141209140733.GA25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141209224230.57f0aa34@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209224230.57f0aa34@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120914-0013-0000-0000-000006E781F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:42:30PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> include/linux/notifier.h:51:4: warning: its scope is only this definition or declaration, which is probably not what you want
> In file included from include/linux/memory_hotplug.h:6:0,
>                  from include/linux/mmzone.h:790,
>                  from include/linux/gfp.h:5,
>                  from arch/powerpc/mm/pgtable.c:25:
> include/linux/notifier.h:51:4: error: 'struct notifier_block' declared inside parameter list [-Werror]
>     unsigned long action, void *data);
>     ^
> 
> And many more (most just warnings ...).
> 
> Presumably caused by commit 44dec3761b63 ("srcu: Isolate srcu sections
> using CONFIG_SRCU") and reverting that commit makes the messages go
> away, so I have done that for today.

Apologies, I forgot to push the fix to rcu/next, will do.

							Thanx, Paul

