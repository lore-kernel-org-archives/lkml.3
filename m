Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3JCI0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:26:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54115 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3JCI0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:26:03 -0400
Date: Thu, 3 Oct 2013 10:25:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Correct RSA MPI dependency
Message-ID: <20131003082556.GB8917@pd.tnic>
References: <CA+r1ZhgsXTZ_x-jzS2OpjryhCExrG0B6nB_Ph4gb9_BJL4zeCA@mail.gmail.com>
 <20131002235615.GA7419@pd.tnic>
 <CA+r1ZhhEL22-8N3McHaHZ9hmsC84mwkgz39O8t9sC967FjM_4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+r1ZhhEL22-8N3McHaHZ9hmsC84mwkgz39O8t9sC967FjM_4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 07:54:01PM -0700, Jim Davis wrote:
> Yes, with the change that configuration file didn't generate a build
> error. Tested-by: jim.epost@gmail.com (if it isn't overkill for for an
> obvious patch!). Thanks.

Of course not. :)

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] crypto: Correct RSA MPI dependency

9e235dcaf4f6 ("Revert "crypto: GnuPG based MPI lib - additional sources
(part 4)") removed the MPI lib extra stuff but left RSA selecting it
while it should select CONFIG_MPILIB instead. Fix it.

Reported-and-tested-by: Jim Davis <jim.epost@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 crypto/asymmetric_keys/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea12559..755f6174585a 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -21,7 +21,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-	select MPILIB_EXTRA
+	select MPILIB
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 
-- 
1.8.4


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
