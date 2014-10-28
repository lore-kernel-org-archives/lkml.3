Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaJ1Af4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:35:56 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63119 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaJ1Afw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:35:52 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [PATCH 0/3] enable pool shrinking in page unit
Date: Tue, 28 Oct 2014 09:36:42 +0900
Message-Id: <1414456605-26049-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Current shrinking is not page unit, block unit.
But shrinker returns the pool size in page unit,
so it is confused.

And there is no way to control pool size and shrink pool directly.

I have 3 patches:

1. Patch 1/3: make pool be shrinked by page unit
This patch trys to shrink pool in page unit.

2. Patch 2/3: enable debugfs to shrink page directly
This patch enables debugfs to specify shrink amount.

3. Patch 3/3: limit pool size
This patch specifies pool size limit.

This patchset is based on linux-next-20141023.

Gioh Kim (3):
  staging: ion: shrink page-pool by page unit
  staging: ion: debugfs to shrink pool
  staging: ion: limit pool size

 drivers/staging/android/ion/Kconfig           |    8 +++++++
 drivers/staging/android/ion/ion.c             |   31 +++++++------------------
 drivers/staging/android/ion/ion_page_pool.c   |   29 +++++++++++++----------
 drivers/staging/android/ion/ion_system_heap.c |    7 ++++--
 4 files changed, 38 insertions(+), 37 deletions(-)

-- 
1.7.9.5

