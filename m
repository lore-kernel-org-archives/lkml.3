Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaEIJSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:18:32 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63542 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaEIJS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:18:28 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, sbradshaw@micron.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] block: small performance optimization
Date: Fri,  9 May 2014 11:17:40 +0200
Message-Id: <1399627061-5960-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The IO accounting stats contribute significant overhead on high IO/multi-node
workloads. By moving the in_flight IO tracking to per-cpu counters, we can
elevate some of the cache coherence overhead, at the cost of setup/teardown
and percpu counters structure within the hd_struct structure.

Sam Bradshaw reported an IOPS increase of 20% on his fio workloads.

Thanks,
Matias

Matias Bjørling (1):
  blk: per-cpu counters for in-flight IO accounting

 block/partition-generic.c |  4 ++--
 include/linux/genhd.h     | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

-- 
1.9.1

