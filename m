Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313Ab3GCTM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:12:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633Ab3GCTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:22 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=YtFCEED1JyoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8J0nrezdu6oA:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=zv9_9hqRWm8A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rBP_B_Mwj8d44jpc:21 a=eeWMQ1HzXaLUy5Mz:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184105.322485777@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [112/141] b43: stop format string leaking into error msgs
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0112-b43-stop-format-string-leaking-into-error-msgs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e0e29b683d6784ef59bbc914eac85a04b650e63c ]

The module parameter "fwpostfix" is userspace controllable, unfiltered,
and is used to define the firmware filename. b43_do_request_fw() populates
ctx->errors[] on error, containing the firmware filename. b43err()
parses its arguments as a format string. For systems with b43 hardware,
this could lead to a uid-0 to ring-0 escalation.

CVE-2013-2852

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 54ecf96..f2e4426 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2423,7 +2423,7 @@ static void b43_request_firmware(struct work_struct *work)
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	goto out;
-- 
1.7.10.4


