Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3JOBHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:07:37 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44130 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3JOBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:07:36 -0400
Message-Id: <20131015010500.435964635@kernel.org>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 09:05:00 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 0/4 v2] blk-mq: use percpu_ida to manage tags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
blk-mq and percpu_ida use similar algorithm to manage tags. The difference
is when a cpu can't allocate tags, blk-mq will use ipi to purge remote cpu
cache, while percpu-ida directly purges remote cpu cache. In practice, the
percpu-ida approach is much faster when we can't allocate enough for percpu
cache.

This patch makes blk-mq use percpu_ida to manage tags, this avoids some
duplicate code and has better performance as I mentioned. To test the patches,
rebase blk-mq tree to latest kernel first.

The v2 patch updated some log descriptions, fixed one issue Kent pointed out
and added performance data.

Thanks,
Shaohua
