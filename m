Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3GCLZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:25:51 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57077 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3GCLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:25:49 -0400
Date: Wed, 3 Jul 2013 12:25:41 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Joern Engel <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jul 3
Message-ID: <20130703112539.GA32584@linaro.org>
References: <20130703180620.6919bf7d7f13f7ed21046c68@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703180620.6919bf7d7f13f7ed21046c68@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 06:06:20PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130702:
> 
> The powerpc tree lost its build failure.
> 
> The device-mapper tree gained a conflict against the md tree.
> 
> The net-next tree gained a build failure for which I cherry-picked an
> upcoming fix.
> 
> The trivial tree gained conflicts against the btrfs and Linus' trees.
> 
> The xen-two tree gained a conflict against the tip tree.
> 
> The akpm tree lost some patches that turned up elsewhere.
> 
> The cpuinit tree lost a patch that turned up elsewhere.
> 
> ----------------------------------------------------------------------------
> 

Hi,
Today's linux-next appears to introduce some BUGs when running the libhugetlbfs
testsuite (under both ARM64 and x86_64):

[   94.320661] BUG: Bad rss-counter state mm:ffff880119461040 idx:1 val:-512
[   94.330346] BUG: Bad rss-counter state mm:ffff880119460680 idx:1 val:-2560
[   94.341746] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
[   94.347518] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
[   94.415203] BUG: Bad rss-counter state mm:ffff8801194f9040 idx:1 val:-1024

I've bisected this to commit:
commit 446313e3e4e7274c4d1e449d107fab6c041ec59c
hugetlb: properly account rss

The bad counter values I get are all negative.

To reproduce this, just run through the latest libhugetlbfs test suite, these
warnings appear pretty much immediately. (I set aside 200 huge pages first):
http://libhugetlbfs.sourceforge.net/

Reverting this commit allows the test suite to run without problems.

Cheers,
-- 
Steve
