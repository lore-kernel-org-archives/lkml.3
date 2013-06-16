Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3FPWQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46421 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab3FPWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kees Cook" <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.723438988@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [70/83] b43: stop format string leaking into error msgs
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit e0e29b683d6784ef59bbc914eac85a04b650e63c upstream.

The module parameter "fwpostfix" is userspace controllable, unfiltered,
and is used to define the firmware filename. b43_do_request_fw() populates
ctx->errors[] on error, containing the firmware filename. b43err()
parses its arguments as a format string. For systems with b43 hardware,
this could lead to a uid-0 to ring-0 escalation.

CVE-2013-2852

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2421,7 +2421,7 @@ static int b43_request_firmware(struct b
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	err = -ENOENT;

