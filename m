Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab3KMSMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:12:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46900 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3KMSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:12:39 -0500
Date: Wed, 13 Nov 2013 18:12:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: getcwd() rcu locking bug.
Message-ID: <20131113181238.GD13318@ZenIV.linux.org.uk>
References: <20131113174706.GA4541@redhat.com>
 <20131113180238.GA6419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113180238.GA6419@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:02:38PM -0500, Dave Jones wrote:
> On Wed, Nov 13, 2013 at 12:47:06PM -0500, Dave Jones wrote:
>  > My fuzzer just hit this on v3.12-7033-g42a2d923cc34
>  > 
>  > =====================================
>  > [ BUG: bad unlock balance detected! ]
>  > 3.12.0+ #2 Not tainted
>  > -------------------------------------
>  > trinity-child1/11681 is trying to release lock (rcu_read_lock) at:
>  > [<ffffffff811d287c>] SyS_getcwd+0x11c/0x300
>  > but there are no more locks to release!
>  > 
>  > other info that might help us debug this:
>  > no locks held by trinity-child1/11681.
>  > 
>  > stack backtrace:
>  > CPU: 1 PID: 11681 Comm: trinity-child1 Not tainted 3.12.0+ #2 
>  >  ffffffff81c480a0 ffff88009a40fea0 ffffffff8171b3dc ffff8802399b1560
>  >  ffff88009a40fec8 ffffffff810d370e ffff8802399b1560 ffffffff81c480a0
>  >  ffffffff811d287c ffff88009a40ff00 ffffffff810d80fe ffff88023d2d4600
>  > Call Trace:
>  >  [<ffffffff8171b3dc>] dump_stack+0x4e/0x7a
>  >  [<ffffffff810d370e>] print_unlock_imbalance_bug+0xee/0x100
>  >  [<ffffffff811d287c>] ? SyS_getcwd+0x11c/0x300
>  >  [<ffffffff810d80fe>] lock_release+0x25e/0x310
>  >  [<ffffffff811d2894>] SyS_getcwd+0x134/0x300
>  >  [<ffffffff811d2799>] ? SyS_getcwd+0x39/0x300
>  >  [<ffffffff8172e064>] tracesys+0xdd/0xe2
>  > ------------[ cut here ]------------
> 
> adding Linus, as this might be related to 68f0d9d92e54

Check today's vfs.git#for-linus, should be fixed there.
