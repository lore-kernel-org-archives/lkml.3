Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaJMIzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:55:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44310 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaJMIzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:55:53 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v2 0/3] zram: add rw_page implementation for zram and clean up unnecessary parameter
Date: Mon, 13 Oct 2014 17:55:39 +0900
Message-Id: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

Recently rw_page block device operation has been added.
This patchset implements rw_page operation for zram block device
and does some clean-up .

I implemented the feature in zram and tested it.
Test bed was the G2, LG electronic mobile device, whtich has msm8974
processor and 2GB memory.
With a memory allocation test program consuming memory, the system
generates swap.
And operating time of swap_write_page() was measured.

--------------------------------------------------
|             |   operating time   | improvement |
|             |  (20 runs average) |             |
--------------------------------------------------
|with patch   |    1087.35 us      |             |
--------------------------------------------------
|without patch|    1061.15 us      |    +2.4%    |
--------------------------------------------------

Each test(with paged_io,with BIO)  result set shows normal distribution
and has equal variance.
I mean the two values are valid result to compare.
I can say operation with paged I/O(without BIO)  is faster 2.4% with
confidence level 95%.

Patches 1~2 are for clean-up.
Patch 3 is for implementation of rw_page operation.
With the rw_page operation, zram can do I/O without allocating a BIO.
It make zram can save time and memory.

karam.lee (3):
  zram: remove bio parameter from zram_bvec_rw().
  zram: change parameter from vaild_io_request()
  zram: implement rw_page operation of zram

 drivers/block/zram/zram_drv.c |   69 +++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 16 deletions(-)

-- 
1.7.9.5

