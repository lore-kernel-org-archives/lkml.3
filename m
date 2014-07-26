Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaGZTC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:02:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaGZTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Derrick Pallas <pallas@meraki.com>
Subject: [PATCH 3.4 01/23] crypto: testmgr - update LZO compression test vectors
Date: Sat, 26 Jul 2014 12:02:01 -0700
Message-Id: <20140726190149.767938696@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>

commit 0ec7382036922be063b515b2a3f1d6f7a607392c upstream.

Update the LZO compression test vectors according to the latest compressor
version.

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Cc: Derrick Pallas <pallas@meraki.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/testmgr.h |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -14558,38 +14558,40 @@ static struct pcomp_testvec zlib_decomp_
 static struct comp_testvec lzo_comp_tv_template[] = {
 	{
 		.inlen	= 70,
-		.outlen	= 46,
+		.outlen	= 57,
 		.input	= "Join us now and share the software "
 			"Join us now and share the software ",
 		.output	= "\x00\x0d\x4a\x6f\x69\x6e\x20\x75"
-			"\x73\x20\x6e\x6f\x77\x20\x61\x6e"
-			"\x64\x20\x73\x68\x61\x72\x65\x20"
-			"\x74\x68\x65\x20\x73\x6f\x66\x74"
-			"\x77\x70\x01\x01\x4a\x6f\x69\x6e"
-			"\x3d\x88\x00\x11\x00\x00",
+			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
+			  "\x64\x20\x73\x68\x61\x72\x65\x20"
+			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
+			  "\x77\x70\x01\x32\x88\x00\x0c\x65"
+			  "\x20\x74\x68\x65\x20\x73\x6f\x66"
+			  "\x74\x77\x61\x72\x65\x20\x11\x00"
+			  "\x00",
 	}, {
 		.inlen	= 159,
-		.outlen	= 133,
+		.outlen	= 131,
 		.input	= "This document describes a compression method based on the LZO "
 			"compression algorithm.  This document defines the application of "
 			"the LZO algorithm used in UBIFS.",
-		.output	= "\x00\x2b\x54\x68\x69\x73\x20\x64"
+		.output	= "\x00\x2c\x54\x68\x69\x73\x20\x64"
 			  "\x6f\x63\x75\x6d\x65\x6e\x74\x20"
 			  "\x64\x65\x73\x63\x72\x69\x62\x65"
 			  "\x73\x20\x61\x20\x63\x6f\x6d\x70"
 			  "\x72\x65\x73\x73\x69\x6f\x6e\x20"
 			  "\x6d\x65\x74\x68\x6f\x64\x20\x62"
 			  "\x61\x73\x65\x64\x20\x6f\x6e\x20"
-			  "\x74\x68\x65\x20\x4c\x5a\x4f\x2b"
-			  "\x8c\x00\x0d\x61\x6c\x67\x6f\x72"
-			  "\x69\x74\x68\x6d\x2e\x20\x20\x54"
-			  "\x68\x69\x73\x2a\x54\x01\x02\x66"
-			  "\x69\x6e\x65\x73\x94\x06\x05\x61"
-			  "\x70\x70\x6c\x69\x63\x61\x74\x76"
-			  "\x0a\x6f\x66\x88\x02\x60\x09\x27"
-			  "\xf0\x00\x0c\x20\x75\x73\x65\x64"
-			  "\x20\x69\x6e\x20\x55\x42\x49\x46"
-			  "\x53\x2e\x11\x00\x00",
+			  "\x74\x68\x65\x20\x4c\x5a\x4f\x20"
+			  "\x2a\x8c\x00\x09\x61\x6c\x67\x6f"
+			  "\x72\x69\x74\x68\x6d\x2e\x20\x20"
+			  "\x2e\x54\x01\x03\x66\x69\x6e\x65"
+			  "\x73\x20\x74\x06\x05\x61\x70\x70"
+			  "\x6c\x69\x63\x61\x74\x76\x0a\x6f"
+			  "\x66\x88\x02\x60\x09\x27\xf0\x00"
+			  "\x0c\x20\x75\x73\x65\x64\x20\x69"
+			  "\x6e\x20\x55\x42\x49\x46\x53\x2e"
+			  "\x11\x00\x00",
 	},
 };
 


