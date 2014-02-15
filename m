Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBOD7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 22:59:47 -0500
Received: from nm8-vm9.bullet.mail.gq1.yahoo.com ([98.136.218.232]:37829 "EHLO
	nm8-vm9.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbaBOD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 22:59:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=OPftbdWXFYdEK38T/rTwDfHMDQ7SroXLJSIoNAxHrLSTzokrft1SuhsSPDA9m/dHDRYRmTMhNUiESBXpAhYQzYLd3tuDgj7zDuKnrvt8kxepVGyT1uy26qC0atT1kxxfKJcdP4uX0kcVuXwPLzJeHuvdfqlT5W6DxMXMLx/X7HE=;
X-Yahoo-Newman-Id: 155332.78158.bm@smtp227.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qNgd5jgVM1muZqDIEQEtocUQdXSww54d4RehLamgx60XpZm
 zOYyVgkTaOxHMerDXeP88RxQA_nLqtK.h7uqNa.SjNPA7TQAHGDr0VBzVJxD
 uYzQvo5vgDnoJ646wOf4Lxqx1Txvza4P35Cz2u2WNj7bbmnlrbpUhimXtb2w
 uiymOw3k5K3Uoxx82vt7bl2rJOXSKl72.QWAFgLMEycYYfsbYVxLlORaSx5H
 __ZKWq56QRK97op3QtO27o4Vzba6sNTOz7UCucQxL2FyBa_a3R6rX_xW8egY
 QH3VtUW2movOZwMbzCsCz24EvoiX5lcjavjSk1HJhuJCP.Bw4a8Ul.V0ZWxC
 BPADZttrW__rHkEbMbcAA_Zcsr0h_SVyQHho6xD.gUoY9h6GYYObtokfUKrp
 VxhPUIp7fSMHxenxA_YO52pHo_IgOX61Ub8KvodfkPONF_8nbI_1Q0Fi_8lN
 65Tj7OvHrg6QvLoR1ylPD1nAK74NEZ3r2cqIQLmwngcoINkZDZ6KBJ7QO5TY
 NNjeKBxJXZnpedVnN77KvvQWj8h3yWIZO9BMxQ9A_wiYPTbBjDg--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@130.126.255.116 with plain [98.138.105.21])
        by smtp227.mail.gq1.yahoo.com with SMTP; 15 Feb 2014 03:59:45 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: kcomedilib: replace deprecated simple_strtoul() with kstrtouint()
Date: Fri, 14 Feb 2014 21:59:40 -0600
Message-Id: <1392436780-31184-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since simple_strtoul() has been deprecated, replace it with kstrtouint().
Also, since return code checking for this new function is enforced, add a
check to ensure that the conversion has succeeded.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/kcomedilib/kcomedilib_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 7dc5a18..8923e65 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -41,7 +41,8 @@ struct comedi_device *comedi_open(const char *filename)
 	if (strncmp(filename, "/dev/comedi", 11) != 0)
 		return NULL;
 
-	minor = simple_strtoul(filename + 11, NULL, 0);
+	if (kstrtouint(filename + 11, 0, &minor))
+		return NULL;
 
 	if (minor >= COMEDI_NUM_BOARD_MINORS)
 		return NULL;
-- 
1.8.5.3

