Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3DXSgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:36:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3DXSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:36:17 -0400
Date: Wed, 24 Apr 2013 14:36:15 -0400 (EDT)
Message-Id: <20130424.143615.334401973542739420.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64, mm BUG in 3.9-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130423.161751.2116707386990845036.davem@davemloft.net>
References: <20130422.152741.652969183920758931.davem@davemloft.net>
	<alpine.SOC.1.00.1304230019030.12820@math.ut.ee>
	<20130423.161751.2116707386990845036.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Apr 2013 11:36:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 23 Apr 2013 16:17:51 -0400 (EDT)

> From: Meelis Roos <mroos@linux.ee>
> Date: Tue, 23 Apr 2013 00:19:49 +0300 (EEST)
> 
>>> > Hello, I got a non-booting Sun E420R (sparc64) with 3.9-rc8: BUG-s in 
>>> > mm/slub.c:925 and mm/memory.c:1267 (the latter keeps scrolling until 
>>> > other things break and panic comes from trying to kill init). This is 
>>> > reproducible. Same machine runs 3.9.0-rc7-00004-gbb33db7 successfully.
>>> > Configuration is below.
>>> 
>>> It's certainly a bug in the TLB shootdown fix, please verify that
>>> reverting the following fixes things:
>>> 
>>> >From f36391d2790d04993f48da6a45810033a2cdf847 Mon Sep 17 00:00:00 2001
>>> From: "David S. Miller" <davem@davemloft.net>
>>> Date: Fri, 19 Apr 2013 17:26:26 -0400
>>> Subject: [PATCH] sparc64: Fix race in TLB batch processing.
>> 
>> Yes, reverting that makes it work again.
> 
> Just an update, using your config I was able to make one that boots on my
> machine and reproduces the problem.

Ok, I've narrowed it down to CONFIG_DEBUG_ATOMIC_SLEEP, as the exact config
option which starts the crashes happening when it is enabled.

I should have this fixed by the end of today.
