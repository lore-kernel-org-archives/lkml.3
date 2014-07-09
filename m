Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbaGITL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:11:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62163 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbaGITLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:11:25 -0400
From: James A Shackleford <shack@linux.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 3/3] staging: rtl8712: remove #define _workitem struct work_struct
Date: Wed,  9 Jul 2014 15:10:47 -0400
Message-Id: <1404933047-23071-3-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404933047-23071-2-git-send-email-shack@linux.com>
References: <1404933047-23071-1-git-send-email-shack@linux.com>
 <1404933047-23071-2-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_workitem is just a #define for work_struct.  Remove the #define and
use struct work_struct directly instead.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/drv_types.h       | 2 +-
 drivers/staging/rtl8712/osdep_service.h   | 1 -
 drivers/staging/rtl8712/rtl871x_led.h     | 2 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.h | 4 ++--
 drivers/staging/rtl8712/rtl871x_xmit.h    | 6 +++---
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 0168745..3d0a98b 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -173,7 +173,7 @@ struct _adapter {
 	struct net_device_stats stats;
 	struct iw_statistics iwstats;
 	int pid; /*process id from UI*/
-	_workitem wkFilterRxFF0;
+	struct work_struct wkFilterRxFF0;
 	u8 blnEnableRxFF0Filter;
 	spinlock_t lockRxFF0Filter;
 	const struct firmware *fw;
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 43795e7..c80f006 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -50,7 +50,6 @@ struct	__queue	{
 #define _pkt struct sk_buff
 #define _buffer unsigned char
 #define thread_exit() complete_and_exit(NULL, 0)
-#define _workitem struct work_struct
 
 #define _init_queue(pqueue)				\
 	do {						\
diff --git a/drivers/staging/rtl8712/rtl871x_led.h b/drivers/staging/rtl8712/rtl871x_led.h
index 1a90c7f..eb61205 100644
--- a/drivers/staging/rtl8712/rtl871x_led.h
+++ b/drivers/staging/rtl8712/rtl871x_led.h
@@ -99,7 +99,7 @@ struct LED_871x {
 						   * either LED_ON or OFF.*/
 
 	struct timer_list	BlinkTimer; /* Timer object for led blinking.*/
-	_workitem		BlinkWorkItem; /* Workitem used by BlinkTimer */
+	struct work_struct	BlinkWorkItem; /* Workitem used by BlinkTimer */
 };
 
 struct led_priv {
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.h b/drivers/staging/rtl8712/rtl871x_pwrctrl.h
index 70ff924f..0526ba0 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.h
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.h
@@ -107,8 +107,8 @@ struct	pwrctrl_priv {
 	uint ImrContent;	/* used to store original imr. */
 	uint bSleep; /* sleep -> active is different from active -> sleep. */
 
-	_workitem SetPSModeWorkItem;
-	_workitem rpwm_workitem;
+	struct work_struct SetPSModeWorkItem;
+	struct work_struct rpwm_workitem;
 	struct timer_list rpwm_check_timer;
 	u8	rpwm_retry;
 	uint	bSetPSModeWorkItemInProgress;
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index ee90698..a9633c3 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -233,9 +233,9 @@ struct	xmit_priv {
 	u8	hwxmit_entry;
 	u8	txirp_cnt;
 	struct tasklet_struct xmit_tasklet;
-	_workitem xmit_pipe4_reset_wi;
-	_workitem xmit_pipe6_reset_wi;
-	_workitem xmit_piped_reset_wi;
+	struct work_struct xmit_pipe4_reset_wi;
+	struct work_struct xmit_pipe6_reset_wi;
+	struct work_struct xmit_piped_reset_wi;
 	/*per AC pending irp*/
 	int beq_cnt;
 	int bkq_cnt;
-- 
1.9.1

