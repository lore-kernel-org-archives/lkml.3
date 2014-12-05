Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaLEEdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:33:51 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:64699 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaLEEdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:33:49 -0500
From: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soeren.brinkmann@gmail.com>
Subject: [PATCH] staging: vt6655: Declare vnt_init() static
Date: Thu,  4 Dec 2014 20:33:41 -0800
Message-Id: <1417754021-32125-1-git-send-email-soeren.brinkmann@gmail.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
  drivers/staging/vt6655/device_main.c:1672:5: warning: symbol 'vnt_init' was not declared. Should it be static?

Signed-off-by: Sören Brinkmann <soeren.brinkmann@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 83e4162c0094..a3f5cd84259a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1669,7 +1669,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 	.reset_tsf		= vnt_reset_tsf,
 };
 
-int vnt_init(struct vnt_private *priv)
+static int vnt_init(struct vnt_private *priv)
 {
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyCurrentNetAddr);
 
-- 
2.1.3

