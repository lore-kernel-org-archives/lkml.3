Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3AKVGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:06:44 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50543 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3AKVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:06:43 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, fengguang.wu@intel.com
Subject: [PATCHSET] block: improve tracepoints, take#2
Date: Fri, 11 Jan 2013 13:06:32 -0800
Message-Id: <1357938397-5413-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

This is the second take.  Changes from the first take[L] are

* writeback_dirty_buffer TP was botched.  It made build fail when
  CONFIG_BLOCK is not set (reported by Fengguang) and I somehow lost
  its actual triggering in mark_buffer_dirty() while splitting
  patches.  Made it a block TP instead so that it can share TP
  definition with block_touch_buffer and restored the triggering from
  mark_buffer_dirty().

This patchset fixes/improves bio_complete TP so that block layer
proper triggers for all completing bios instead of stackign drivers
triggering them manually and adds more buffer / block / writeback TPs.
These improve visibility in general and are already in use in google.

This patchset contains the following five patches.

0001-block-add-missing-block_bio_complete-tracepoint.patch
0002-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
0003-buffer-make-touch_buffer-an-exported-function.patch
0004-block-add-block_-touch-dirty-_buffer-tracepoint.patch
0005-writeback-add-more-tracepoints.patch

It's based on top of v3.8-rc2 and also available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-tps

diffstat follows.  Thanks.

 block/blk-core.c                 |    5 -
 drivers/md/dm.c                  |    1
 drivers/md/raid5.c               |   11 ---
 fs/bio.c                         |    2
 fs/buffer.c                      |   10 +++
 fs/fs-writeback.c                |   16 ++++-
 include/linux/blktrace_api.h     |    1
 include/linux/buffer_head.h      |    2
 include/trace/events/block.h     |  104 +++++++++++++++++++++++++++++-----
 include/trace/events/writeback.h |  116 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/blktrace.c          |   28 ++++++++-
 mm/page-writeback.c              |    2
 12 files changed, 263 insertions(+), 35 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1419141
