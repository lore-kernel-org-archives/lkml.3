Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbaFNWJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:09:49 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:49468 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbaFNWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:09:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0IAFXHnFNXQyDr/2dsb2JhbABagw2BKallBQEBAQEBAQUBmSSBAxd1hGAjgRo3iEYBzzQXhWOJEx2ELQSaQ4swiCiBfoFEOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 1/1] drivers/crypto/nx/nx-842.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sun, 15 Jun 2014 00:09:55 +0200
Message-Id: <1402783795-12331-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/crypto/nx/nx-842.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 502edf0..923c4b6 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -350,7 +350,7 @@ int nx842_compress(const unsigned char *in, unsigned int inlen,
 	 * the alignment is guaranteed.
 	*/
 	inbuf = (unsigned long)in;
-	if (!IS_ALIGNED(inbuf, PAGE_SIZE) || inlen != PAGE_SIZE)
+	if (!PAGE_ALIGNED(inbuf) || inlen != PAGE_SIZE)
 		return -EINVAL;
 
 	rcu_read_lock();
@@ -545,7 +545,7 @@ int nx842_decompress(const unsigned char *in, unsigned int inlen,
 
 	/* Ensure page alignment and size */
 	outbuf = (unsigned long)out;
-	if (!IS_ALIGNED(outbuf, PAGE_SIZE) || *outlen != PAGE_SIZE)
+	if (!PAGE_ALIGNED(outbuf) || *outlen != PAGE_SIZE)
 		return -EINVAL;
 
 	rcu_read_lock();
-- 
1.8.4.5

