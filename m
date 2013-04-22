Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3DVW5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:57:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39654 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3DVW5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:57:47 -0400
Date: Mon, 22 Apr 2013 18:57:45 -0400 (EDT)
Message-Id: <20130422.185745.546880614466260395.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64, mm BUG in 3.9-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1304230019030.12820@math.ut.ee>
References: <alpine.SOC.1.00.1304221601370.4328@math.ut.ee>
	<20130422.152741.652969183920758931.davem@davemloft.net>
	<alpine.SOC.1.00.1304230019030.12820@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Apr 2013 15:57:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Tue, 23 Apr 2013 00:19:49 +0300 (EEST)

>> > Hello, I got a non-booting Sun E420R (sparc64) with 3.9-rc8: BUG-s in 
>> > mm/slub.c:925 and mm/memory.c:1267 (the latter keeps scrolling until 
>> > other things break and panic comes from trying to kill init). This is 
>> > reproducible. Same machine runs 3.9.0-rc7-00004-gbb33db7 successfully.
>> > Configuration is below.
>> 
>> It's certainly a bug in the TLB shootdown fix, please verify that
>> reverting the following fixes things:
>> 
>> >From f36391d2790d04993f48da6a45810033a2cdf847 Mon Sep 17 00:00:00 2001
>> From: "David S. Miller" <davem@davemloft.net>
>> Date: Fri, 19 Apr 2013 17:26:26 -0400
>> Subject: [PATCH] sparc64: Fix race in TLB batch processing.
> 
> Yes, reverting that makes it work again.

Thanks, could you post a prtconf dump from this machine?  I'll
add it to the prtconf GIT repo as well.
