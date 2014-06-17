Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaFQFus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:50:48 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:33008 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaFQFuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:50:46 -0400
Date: Tue, 17 Jun 2014 09:50:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] epoll: fix use-after-free in eventpoll_release_file
Message-ID: <20140617055042.GA3064@moon>
References: <20140617025805.29539.22007.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617025805.29539.22007.stgit@zurg>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 06:58:05AM +0400, Konstantin Khlebnikov wrote:
> This fixes use-after-free of epi->fllink.next inside list loop macro.
> This loop actually releases elements in the body. List is rcu-protected
> but here we cannot hold rcu_read_lock because we need to lock mutex inside.
> 
> Obvious solution is to use list_for_each_entry_safe(). RCU-ness isn't essential
> because nobody can change this list under us, it's final fput for this file.
> 
> Bug is here since ae10b2b4eb01bedc91d29d5c5bb9e416fd806c40
> ("epoll: optimize EPOLL_CTL_DEL using rcu")
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Stable <stable@vger.kernel.org> # 3.13+
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Jason Baron <jbaron@akamai.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
