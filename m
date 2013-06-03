Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab3FCPop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:44:45 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49391 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:44:44 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 0/8] small bugfixes and code improvements for zram
Date: Mon,  3 Jun 2013 23:42:12 +0800
Message-Id: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to fix issues in zram found by code inspection.
There is still one more issue left: should we repalce zram_stat64_xxx()
with atomic64_xxx()?

Jiang Liu (8):
  zram: simplify and optimize zram_to_dev()
  zram: avoid invalid memory access in zram_exit()
  zram: use zram->lock to protect zram_free_page() in swap free notify
    path
  zram: destroy all devices on error recovery path in zram_init()
  zram: avoid double free in error recovery path of zram_bvec_write()
  zram: avoid access beyond the zram device
  zram: optimize memory operations with clear_page()/copy_page()
  zram: protect sysfs handler from invalid memory access

 drivers/staging/zram/zram_drv.c   | 41 +++++++++++++++++++++++++--------------
 drivers/staging/zram/zram_sysfs.c | 15 ++++----------
 2 files changed, 30 insertions(+), 26 deletions(-)

-- 
1.8.1.2

