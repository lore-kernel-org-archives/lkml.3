Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3AYK4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:56:35 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36485 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3AYK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:33 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Loop device bug fix
Date: Fri, 25 Jan 2013 18:56:15 +0800
Message-Id: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-3864-0000-0000-000006915DD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix several loop device bugs.

Patch #1 fix non-atomic updating block device size. It also prepares for
a later dead lock patch.

Patch #2 is a trivial clean up about block device.

The rest of the patchset are loop device fix:

	#3 - fix a dead loop
	#4 - fix a race-like problem
	#5 - a little clean up based on #3 and #4
	#6 - fix a user triggable oops
	#7 - avoid loop device size being messed up by parameters from users


Guo Chao (7):
  block: use i_size_write() in bd_set_size()
  block: remove redundant check to bd_openers
  loopdev: fix a dead lock
  loopdev: update block device size in loop_set_status()
  loopdev: move common code into loop_figure_size()
  loopdev: remove an user triggable oops
  loopdev: ignore negative offset when calculate loop device size

 drivers/block/loop.c |   61 ++++++++++++++++++++++++--------------------------
 fs/block_dev.c       |    6 +++--
 2 files changed, 33 insertions(+), 34 deletions(-)

-- 
1.7.9.5

