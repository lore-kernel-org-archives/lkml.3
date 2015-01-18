Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbARCFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 21:05:02 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43257 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbARCE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 21:04:56 -0500
From: mathieu.poirier@linaro.org
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 1/4] staging: vt6655: correcting function declaration sparse error
Date: Sat, 17 Jan 2015 19:04:23 -0700
Message-Id: <1421546666-21461-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
  LD      drivers/staging/vt6655/built-in.o
  CHECK   drivers/staging/vt6655/device_main.c
drivers/staging/vt6655/device_main.c:1672:5: warning: symbol 'vnt_init' was not declared. Should it be static?
  CC [M]  drivers/staging/vt6655/device_main.o

Function @vnt_init is only called by @vt6655_probe, in turn is declared "static".
As sparse suggest, @vnt_init should very likely be declared static as well.  At
least nothing in the file indicate that it should be otherwise.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
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
1.9.1

