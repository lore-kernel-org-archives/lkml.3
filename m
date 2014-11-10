Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaKJS4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:56:51 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59839 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaKJS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:56:50 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Krzysztof Konopko <kris@konagma.com>,
        navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] rtl8188eu: Simplify rtw_endofpktfile() in xmit_linux.c
Date: Mon, 10 Nov 2014 18:54:22 +0000
Message-Id: <1415645662-31405-1-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <545F35FB.20100@konagma.com>
References: <545F35FB.20100@konagma.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/checkpatch.pl reports a coding style problem in xmit_linux.c

  WARNING:BRACES: braces {} are not necessary for single statement blocks
  #61852: FILE: rtl8188eu/os_dep/xmit_linux.c:70:

This patch removes unnecessary braces and simplifies the function to a
single return statement.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index d5e41a5..5acf9a9 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -66,13 +66,7 @@ uint _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen)
 
 int rtw_endofpktfile(struct pkt_file *pfile)
 {
-
-	if (pfile->pkt_len == 0) {
-		return true;
-	}
-
-
-	return false;
+	return pfile->pkt_len == 0;
 }
 
 int rtw_os_xmit_resource_alloc(struct adapter *padapter, struct xmit_buf *pxmitbuf, u32 alloc_sz)
-- 
2.1.1

