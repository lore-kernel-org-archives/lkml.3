Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3FRLv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:51:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab3FRLpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 72/93] b43: stop format string leaking into error msgs
Date: Tue, 18 Jun 2013 12:43:20 +0100
Message-Id: <1371555821-12820-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f8fd420..5b349da 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2451,7 +2451,7 @@ static void b43_request_firmware(struct work_struct *work)
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	goto out;
-- 
1.8.1.2

