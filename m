Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3E1Dzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52486 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758801Ab3E1DyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matthew Garrett" <matthew.garrett@nebula.com>,
        "Shuah Khan" <shuah.khan@hp.com>, "Takashi Iwai" <tiwai@suse.de>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.939493237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [22/94] hp_accel: Ignore the error from lis3lv02d_poweron() at resume
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

commit 7783819920ca52fc582a2782f654fe6ed373f465 upstream.

The error in lis3lv02_poweron() is harmless in the resume path, so
we should ignore it. It is inline with the other usages of lis3lv02_poweron()
and matches the 3.0 code for this routine. This patch is in suse git and
might have missed making it into the mainline.
opensuse - commit id: 66ccdac87c322cf7af12bddba8c805af640b1cff

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -362,7 +362,8 @@ static int lis3lv02d_suspend(struct acpi
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	return lis3lv02d_poweron(&lis3_dev);
+	lis3lv02d_poweron(&lis3_dev);
+	return 0;
 }
 #else
 #define lis3lv02d_suspend NULL

