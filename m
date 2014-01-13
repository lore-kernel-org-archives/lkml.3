Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaAMLTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:19:19 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43182 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAMLTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:17 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/7] zram bug fix and lock redesign
Date: Mon, 13 Jan 2014 20:18:55 +0900
Message-Id: <1389611942-15544-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes a bug fix and clean up patchset
to resolve lock mess.
Finally, last patch enhances write path significantly.

Minchan Kim (7):
  zram: fix race between reset and flushing pending work
  zram: delay pending free request in read path
  zram: remove unnecessary free
  zram: use atomic operation for stat
  zram: introduce zram->tb_lock
  zram: remove workqueue for freeing removed pending slot
  zram: remove unnecessary lock

 drivers/block/zram/zram_drv.c | 126 +++++++++++++++---------------------------
 drivers/block/zram/zram_drv.h |  27 ++-------
 2 files changed, 51 insertions(+), 102 deletions(-)

-- 
1.8.4.3

