Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3LSIzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:55:08 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40865 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3LSIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:55:04 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v3=206/8=5D=20drivers=3A=20net=3A=20Mark=20functions=20as=20static=20in=204965-debug=2Ec?=
Date: Thu, 19 Dec 2013 14:24:38 +0530
Message-Id: <b5de1ef19267bbdb0b6f8b36f74b7f59f833cffd.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function il4965_ucode_rx_stats_read(),
il4965_ucode_tx_stats_read() and il4965_ucode_general_stats_read() in
4965-debug.c as static because they are not used outside this file.

Thus, it also removes the following warnings in
wireless/iwlegacy/4965-debug.c:

drivers/net/wireless/iwlegacy/4965-debug.c:59:1: warning: no previous prototype for ‘il4965_ucode_rx_stats_read’ [-Wmissing-prototypes]
drivers/net/wireless/iwlegacy/4965-debug.c:471:1: warning: no previous prototype for ‘il4965_ucode_tx_stats_read’ [-Wmissing-prototypes]
drivers/net/wireless/iwlegacy/4965-debug.c:637:1: warning: no previous prototype for ‘il4965_ucode_general_stats_read’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/wireless/iwlegacy/4965-debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index c8153fc..e0597bf 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -55,7 +55,7 @@ il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	return p;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -467,7 +467,7 @@ il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -633,7 +633,7 @@ il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-- 
1.7.9.5

