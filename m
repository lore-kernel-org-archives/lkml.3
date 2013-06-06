Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3FFQKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:10:53 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48558 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FFQKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:10:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] Bugfixes and minor improvements for zram
Date: Fri,  7 Jun 2013 00:07:21 +0800
Message-Id: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found some issues in zram by code inspection, so generate this set
of patches for bugfixes and minor code improvements.
The first six patches are bugfixes, and should target the mainline
and even stable trees. The last 4 patches are code cleanup and
performance optimization, but not sure whether Greg is kind enough
to accept them:)

Great thanks to Minchan and Jerome for code review!

V2->V3:
1) reorder patches so bugfixes go first
2) rewrite valid_io_request()
3) enhance comments and commit messages

Jiang Liu (10):
  zram: avoid invalid memory access in zram_exit()
  zram: use zram->lock to protect zram_free_page() in swap free notify
    path
  zram: destroy all devices on error recovery path in zram_init()
  zram: avoid double free in function zram_bvec_write()
  zram: avoid access beyond the zram device
  zram: protect sysfs handler from invalid memory access
  zram: simplify and optimize dev_to_zram()
  zram: kill unused zram_get_num_devices()
  zram: optimize memory operations with clear_page()/copy_page()
  zram: use atomic64_xxx() to replace zram_stat64_xxx()

 drivers/staging/zram/zram_drv.c   | 109 +++++++++++++++++---------------------
 drivers/staging/zram/zram_drv.h   |  26 ++++-----
 drivers/staging/zram/zram_sysfs.c |  36 ++++---------
 3 files changed, 73 insertions(+), 98 deletions(-)

-- 
1.8.1.2

