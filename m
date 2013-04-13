Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3DMKsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:48:06 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:47682 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3DMKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:46:42 -0400
Subject: [RFC PATCH 2/6] crypto: tcrypt - add async cipher speed tests for
 blowfish
To: linux-crypto@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Sat, 13 Apr 2013 13:46:40 +0300
Message-ID: <20130413104640.10667.27531.stgit@localhost6.localdomain6>
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/tcrypt.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24ea7df..66d254c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1768,6 +1768,21 @@ static int do_test(int m)
 				   speed_template_32_64);
 		break;
 
+	case 509:
+		test_acipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		break;
+
 	case 1000:
 		test_available();
 		break;

