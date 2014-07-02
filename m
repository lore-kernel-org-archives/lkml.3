Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943AbaGBQz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62105 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbaGBQzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 47/48] staging: rtl8188eu: Remove cmd_seq from struct cmd_priv
Date: Wed,  2 Jul 2014 22:17:43 +0530
Message-Id: <1404319664-8327-47-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Value stored in cmd_seq isn't used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    4 ----
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index be50d84..0841de2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -36,8 +36,6 @@ int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 	sema_init(&(pcmdpriv->terminate_cmdthread_sema), 0);
 
 	_rtw_init_queue(&(pcmdpriv->cmd_queue));
-
-	pcmdpriv->cmd_seq = 1;
 	return _SUCCESS;
 }
 
@@ -217,8 +215,6 @@ _next:
 				ret = cmd_hdl(pcmd->padapter, pcmd->parmbuf);
 				pcmd->res = ret;
 			}
-
-			pcmdpriv->cmd_seq++;
 		} else {
 			pcmd->res = H2C_PARAMETERS_ERROR;
 		}
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index bad84b2..e59d6d4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -47,7 +47,6 @@ struct cmd_priv {
 	struct semaphore cmd_queue_sema;
 	struct semaphore terminate_cmdthread_sema;
 	struct __queue cmd_queue;
-	u8	cmd_seq;
 	u8 cmdthd_running;
 	struct adapter *padapter;
 };
-- 
1.7.10.4

