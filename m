Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3LRCVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:21:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3LRCVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:21:48 -0500
Date: Tue, 17 Dec 2013 21:21:45 -0500 (EST)
Message-Id: <20131217.212145.893665929052097867.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ffusco@redhat.com, dborkman@redhat.com,
        tgraf@redhat.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131218125643.8ff140371e1f8c306327d354@canb.auug.org.au>
References: <20131218125643.8ff140371e1f8c306327d354@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Dec 2013 18:21:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Dec 2013 12:56:43 +1100

> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/hashtable.h:12:0,
>                  from include/linux/elevator.h:5,
>                  from include/linux/blkdev.h:222,
>                  from init/do_mounts.h:2,
>                  from init/do_mounts_rd.c:21:
> include/linux/hash.h:18:22: fatal error: asm/hash.h: No such file or directory
>  #include <asm/hash.h>
>                       ^
> 
> And many more ...
> 
> Caused by commit 71ae8aac3e19 ("lib: introduce arch optimized hash
> library").  Presumably this would break any architecture other than
> x86 :-(

The author believed that putting a header file in asm-generic/
makes it get used automatically by architectures which lack
that header file.

At the very least we have to add a generic-y entry for it to
arch/${ARCH}/include/asm/Kbuild

I'll try to fix this up, thanks for the report.
