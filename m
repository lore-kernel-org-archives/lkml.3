Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab3FRQOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:14:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab3FRQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:14:31 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 01/26] b43: stop format string leaking into error msgs
Date: Tue, 18 Jun 2013 09:14:41 -0700
Message-Id: <20130618161231.466154808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161231.154881788@linuxfoundation.org>
References: <20130618161231.154881788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2449,7 +2449,7 @@ static void b43_request_firmware(struct
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	goto out;


