Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaIEM5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:57:42 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63531 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaIEM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:57:41 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Chao Yu <chao2.yu@samsung.com>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: use notify_free to account all free notifications
Date: Fri,  5 Sep 2014 21:57:08 +0900
Message-Id: <1409921829-12261-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.1.0.134.gb1ae451
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch change the way zram uses `notify_free' stat attr. Currently,
this attr accounts only swap free notifications, iow used only when zram
device is a swap device. The patch preserves the existing behaviour and
additionally makes `notify_free' universal, so it's also used by zram to
account REQ_DISCARDs when zram is not used as a swap device.

Please refer to:
https://lkml.org/lkml/2014/9/3/1115

Please revert 2cbf6f7bea1048ab5 (zram: add num_{discard_req, discarded}
for discard stat) and apply this patch.

Sergey Senozhatsky (1):
  zram: use notify_free to account all free notifications

 Documentation/ABI/testing/sysfs-block-zram | 13 ++++++++-----
 drivers/block/zram/zram_drv.c              |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.1.0.134.gb1ae451

