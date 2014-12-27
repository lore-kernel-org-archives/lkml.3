Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaL0Usu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:48:50 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62915 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaL0UsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:48:02 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 3/5] staging: lustre: selftest: fix sfw_deactivate_session context imbalance
Date: Sat, 27 Dec 2014 12:46:48 -0800
Message-Id: <1419713210-8198-4-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
References: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse warning about a context imbalance in the
sfw_deactivate_session function by telling sparse that it
should expect the lock to be held on entry and held on exit.

  drivers/staging/lustre/lnet/selftest/framework.c:210:9: warning: context imbalance in 'sfw_deactivate_session' - unexpected unlock

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/framework.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 56b4ef4..5709148 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -194,9 +194,9 @@ sfw_del_session_timer (void)
 	return EBUSY; /* racing with sfw_session_expired() */
 }
 
-/* called with sfw_data.fw_lock held */
 static void
 sfw_deactivate_session (void)
+	__must_hold(&sfw_data.fw_lock)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
 	int	    nactive = 0;
-- 
2.1.4

