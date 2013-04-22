Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3DVVTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:19:55 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46759 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3DVVTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:19:54 -0400
Date: Tue, 23 Apr 2013 00:19:49 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64, mm BUG in 3.9-rc8
In-Reply-To: <20130422.152741.652969183920758931.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1304230019030.12820@math.ut.ee>
References: <alpine.SOC.1.00.1304221601370.4328@math.ut.ee> <20130422.152741.652969183920758931.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hello, I got a non-booting Sun E420R (sparc64) with 3.9-rc8: BUG-s in 
> > mm/slub.c:925 and mm/memory.c:1267 (the latter keeps scrolling until 
> > other things break and panic comes from trying to kill init). This is 
> > reproducible. Same machine runs 3.9.0-rc7-00004-gbb33db7 successfully.
> > Configuration is below.
> 
> It's certainly a bug in the TLB shootdown fix, please verify that
> reverting the following fixes things:
> 
> >From f36391d2790d04993f48da6a45810033a2cdf847 Mon Sep 17 00:00:00 2001
> From: "David S. Miller" <davem@davemloft.net>
> Date: Fri, 19 Apr 2013 17:26:26 -0400
> Subject: [PATCH] sparc64: Fix race in TLB batch processing.

Yes, reverting that makes it work again.

-- 
Meelis Roos (mroos@linux.ee)
