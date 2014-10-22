Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJVHEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:04:31 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:47262 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJVHEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:04:30 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v4 0/3] zram: add rw_page implementation for zram and clean up unnecessary parameter
Date: Wed, 22 Oct 2014 16:04:11 +0900
Message-Id: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

Recently rw_page block device operation has been added.
This patchset implements rw_page operation for zram block device
and does some clean-up.

Patches 1~2 are for clean-up.
Patch 3 is for implementation of rw_page operation.
With the rw_page operation, zram can do I/O without allocating a BIO.
It make zram can save time and memory.

karam.lee (3):
  zram: remove bio parameter from zram_bvec_rw().
  zram: change parameter from vaild_io_request()
  zram: implement rw_page operation of zram

 drivers/block/zram/zram_drv.c |   70 +++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 16 deletions(-)

-- 
1.7.9.5

