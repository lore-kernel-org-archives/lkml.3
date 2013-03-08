Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3CHLA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:00:58 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:59575 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab3CHLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:00:57 -0500
Message-ID: <1362740454.5994.51.camel@x61.thuisdomein>
Subject: [PATCH] RSA: drop "select MPILIB_EXTRA"
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 12:00:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 11:00:54.0925 (UTC) FILETIME=[349CDBD0:01CE1BEC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for RSA public key cryptography was added in v3.7. It added a
select for MPILIB_EXTRA. But that Kconfig symbol was already removed in
v3.6, with commit  9e235dcaf4f63d88a7e9ce5735ba5c2eb2719603 ("Revert
"crypto: GnuPG based MPI lib - additional sources (part 4)""). No one
noticed because all the mpi functionality that was needed was,
apparently, already provided by (indirectly) selecting MPILIB. Anyhow,
this select can be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

 crypto/asymmetric_keys/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea..cce8d3c 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -21,7 +21,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-	select MPILIB_EXTRA
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
-- 
1.7.11.7

