Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3J1KAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:00:21 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63626 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3J1KAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:00:20 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/2] Allow drivers to tap into tags initialization
Date: Mon, 28 Oct 2013 11:00:07 +0100
Message-Id: <1382954409-30789-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches based upon Axboe's blk-mq/core branch
  git://git.kernel.dk/linux-block.git

These two patches enable a driver to control if tags are initialized by blk-mq
or itself. This allows a driver to map multiple struct blk_mq_tags to multiple
hardware and share tags.

This is for example used by the NVMe, that has a limited number of queues,
shared by multiple request queues.

v1->v2
 * Changed blk_mq_init_tags_shared to blk_mq_tags_get.
 * Moved from EXPORT_SYMBOL_GPL to EXPORT_SYMBOL
 * Moved to using a flag for defining when driver handles tags initialization.

Matias Bjorling (2):
  blk-mq: allow request queues to share tags map
  blk-mq: add maps_tags fn and add usage

 block/blk-mq-tag.c     | 22 +++++++++++++++++++++-
 block/blk-mq.c         | 18 ++++++++++--------
 include/linux/blk-mq.h |  6 ++++++
 3 files changed, 37 insertions(+), 9 deletions(-)

-- 
1.8.3.2

