Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3LRVZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:25:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3LRVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 082/118] dm stats: initialize read-only module parameter
Date: Wed, 18 Dec 2013 13:11:59 -0800
Message-Id: <20131218211221.765554472@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 76f5bee5c3b45c617f91243e85547fc8f67bc678 upstream.

The module parameter stats_current_allocated_bytes in dm-mod is
read-only.  This parameter informs the user about memory
consumption.  It is not supposed to be changed by the user.

However, despite being read-only, this parameter can be set on
modprobe or insmod command line:
modprobe dm-mod stats_current_allocated_bytes=12345

The kernel doesn't expect that this variable can be non-zero at module
initialization and if the user sets it, it results in warning.

This patch initializes the variable in the module init routine, so
that user-supplied value is ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -964,6 +964,7 @@ int dm_stats_message(struct mapped_devic
 
 int __init dm_statistics_init(void)
 {
+	shared_memory_amount = 0;
 	dm_stat_need_rcu_barrier = 0;
 	return 0;
 }


