Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3GCQSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:18:47 -0400
Received: from longford.logfs.org ([213.229.74.203]:59726 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3GCQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:18:45 -0400
Date: Wed, 3 Jul 2013 10:48:03 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Steve Capper <steve.capper@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Jul 3
Message-ID: <20130703144802.GA32130@logfs.org>
References: <20130703180620.6919bf7d7f13f7ed21046c68@canb.auug.org.au>
 <20130703112539.GA32584@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130703112539.GA32584@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 July 2013 12:25:41 +0100, Steve Capper wrote:
> 
> Today's linux-next appears to introduce some BUGs when running the libhugetlbfs
> testsuite (under both ARM64 and x86_64):
> 
> [   94.320661] BUG: Bad rss-counter state mm:ffff880119461040 idx:1 val:-512
> [   94.330346] BUG: Bad rss-counter state mm:ffff880119460680 idx:1 val:-2560
> [   94.341746] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
> [   94.347518] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
> [   94.415203] BUG: Bad rss-counter state mm:ffff8801194f9040 idx:1 val:-1024
> 
> I've bisected this to commit:
> commit 446313e3e4e7274c4d1e449d107fab6c041ec59c
> hugetlb: properly account rss
> 
> The bad counter values I get are all negative.
> 
> To reproduce this, just run through the latest libhugetlbfs test suite, these
> warnings appear pretty much immediately. (I set aside 200 huge pages first):
> http://libhugetlbfs.sourceforge.net/
> 
> Reverting this commit allows the test suite to run without problems.

Thank you, I will have a look.  For the interim, dropping this patch
from -mm seems the best approach.

Jörn

--
Geld macht nicht glücklich.
Glück macht nicht satt.
