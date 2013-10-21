Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3JUJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:21:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39502 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab3JUIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "=?UTF-8?Q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>,
        "Kees Cook" <keescook@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.793239747@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 056/149] HID: picolcd_core: validate output report details
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 1e87a2456b0227ca4ab881e19a11bb99d164e792 upstream.

A HID device could send a malicious output report that would cause the
picolcd HID driver to trigger a NULL dereference during attr file writing.

[jkosina@suse.cz: changed

	report->maxfield < 1

to

	report->maxfield != 1

as suggested by Bruno].

CVE-2013-2899

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Bruno Prémont <bonbons@linux-vserver.org>
Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-picolcd_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1424,7 +1424,7 @@ static ssize_t picolcd_operation_mode_st
 		buf += 10;
 		cnt -= 10;
 	}
-	if (!report)
+	if (!report || report->maxfield != 1)
 		return -EINVAL;
 
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))

