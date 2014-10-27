Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJ0CD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:03:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaJ0CDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:03:55 -0400
Date: Sun, 26 Oct 2014 22:03:50 -0400 (EDT)
Message-Id: <20141026.220350.2098346782596904995.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: a.ryabinin@samsung.com, pablo@netfilter.org, mschmidt@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: don't copy over empty attribute data
From: David Miller <davem@davemloft.net>
In-Reply-To: <544D849A.4040304@oracle.com>
References: <54471438.1040907@oracle.com>
	<20141022.021508.2011745433893496421.davem@davemloft.net>
	<544D849A.4040304@oracle.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Oct 2014 19:03:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Sun, 26 Oct 2014 19:32:42 -0400

> How so? GCC states clearly that you should *never* pass a NULL
> pointer there:
> 
> "The pointers passed to memmove (and similar functions in <string.h>) must
> be non-null even when nbytes==0" (https://gcc.gnu.org/gcc-4.9/porting_to.html).
> 
> Even if it doesn't dereference it, it can break somehow in a subtle way. Leaving
> the kernel code assuming that gcc (or any other compiler) would always behave
> the same in a situation that shouldn't occur.

Show me a legal way in which one could legally dereference the pointer
when length is zero, and I'll entertain this patch.
