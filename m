Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3ICOKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:10:19 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54673 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3ICOKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:10:16 -0400
From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, kernel@savoirfairelinux.com,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Subject: [PATCH] x86, tsc: downgrade fast calibration failure message
Date: Tue,  3 Sep 2013 10:09:55 -0400
Message-Id: <1378217395-1241-1-git-send-email-jerome.oufella@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Paul Bolle in https://lkml.org/lkml/2012/9/24/221, the
fast TSC calibration method may fail on some machines and result in an
error level message that does not reflect the severity of the case.

Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
---
This patch lost momentum and wordsmithing the message was evoked in
subsequent posts but imho reducing the level does the job just fine.
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6ff4924..e518724 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -380,7 +380,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:
-- 
1.8.1.4

