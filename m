Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3JKHW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:22:58 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60067 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3JKHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:22:57 -0400
Message-Id: <20131011071802.148101321@kernel.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 15:18:02 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 0/4] blk-mq: use percpu_ida to manage tags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, blk-mq and percpu_ida use similar algorithm to manage tags. The difference
is when a cpu can't allocate tags, blk-mq will use ipi to purge remote cpu
cache, while percpu-ida directly purges remote cpu cache. In practice, the
percpu-ida approach is much faster when we can't allocate enough for percpu
cache.

This patch makes blk-mq use percpu_ida to manage tags, this avoids some
duplicate code and has better performance as I mentioned. To test the patches,
rebase blk-mq tree to latest kernel first.

Thanks,
Shaohua
