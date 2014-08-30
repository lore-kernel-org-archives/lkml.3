Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaH3Vdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:33:31 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35060 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaH3Vda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:33:30 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: hpa@zytor.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/tsc trivial: Changes Fast TSC calibration failed from error to warning
Date: Sat, 30 Aug 2014 17:33:27 -0400
Message-Id: <1409434407-14824-1-git-send-email-alexandre.f.demers@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most users see this message when booting without knowning that it is of 
mostly no importance and that TSC calibration may have succeeded by 
another way.

As explained thoroufly by Paul Bolle in 2012 
(http://lkml.iu.edu//hypermail/linux/kernel/1209.3/00224.html), 
"Fast TSC calibration failed" should not be considered as an error since 
other calibration methods are being tried afterward. At most, 
those send a warning if they fail (not an error). So let's change 
the message from error to warning.

It should also fix bug 75971: fast tsc calibration faild on ubuntu 14.04 LTS

Tested on kernel 3.17-rc2.

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>

---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b6025f9..5a22022 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -617,7 +617,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_warn("Fast TSC calibration failed\n");
 	return 0;
 
 success:
-- 
2.1.0

