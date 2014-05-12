Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaELBxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:53:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34720 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaELBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:22 -0400
Message-Id: <20140512003201.386871159@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 018/143] b43: stop format string leaking into error msgs
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit e0e29b683d6784ef59bbc914eac85a04b650e63c upstream

The module parameter "fwpostfix" is userspace controllable, unfiltered,
and is used to define the firmware filename. b43_do_request_fw() populates
ctx->errors[] on error, containing the firmware filename. b43err()
parses its arguments as a format string. For systems with b43 hardware,
this could lead to a uid-0 to ring-0 escalation.

CVE-2013-2852

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/wireless/b43/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 94dae56..3cf2472 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2257,7 +2257,7 @@ static int b43_request_firmware(struct b43_wldev *dev)
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	err = -ENOENT;
-- 
1.7.12.2.21.g234cd45.dirty



