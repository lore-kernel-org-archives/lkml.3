Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaDHM1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbaDHM1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:27:35 -0400
Date: Tue, 8 Apr 2014 14:27:31 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] hw_random: Move UML_RANDOM at the last position
Message-ID: <20140408142731.48c9f92f@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML_RANDOM is the only hardware random number generator option which
does not depend on HW_RANDOM. Having it in the middle of the other
options breaks the alignment in "make menuconfig". Move it at the last
position to avoid that.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- linux-3.15-rc0.orig/drivers/char/hw_random/Kconfig	2014-04-08 13:12:21.590656248 +0200
+++ linux-3.15-rc0/drivers/char/hw_random/Kconfig	2014-04-08 13:12:50.845233756 +0200
@@ -275,21 +275,6 @@ config HW_RANDOM_PPC4XX
 
 	 If unsure, say N.
 
-config UML_RANDOM
-	depends on UML
-	tristate "Hardware random number generator"
-	help
-	  This option enables UML's "hardware" random number generator.  It
-	  attaches itself to the host's /dev/random, supplying as much entropy
-	  as the host has, rather than the small amount the UML gets from its
-	  own drivers.  It registers itself as a standard hardware random number
-	  generator, major 10, minor 183, and the canonical device name is
-	  /dev/hwrng.
-	  The way to make use of this is to install the rng-tools package
-	  (check your distro, or download from
-	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
-	  /dev/hwrng and injects the entropy into /dev/random.
-
 config HW_RANDOM_PSERIES
 	tristate "pSeries HW Random Number Generator support"
 	depends on HW_RANDOM && PPC64 && IBMVIO
@@ -352,3 +337,18 @@ config HW_RANDOM_MSM
 	  module will be called msm-rng.
 
 	  If unsure, say Y.
+
+config UML_RANDOM
+	depends on UML
+	tristate "Hardware random number generator"
+	help
+	  This option enables UML's "hardware" random number generator.  It
+	  attaches itself to the host's /dev/random, supplying as much entropy
+	  as the host has, rather than the small amount the UML gets from its
+	  own drivers.  It registers itself as a standard hardware random number
+	  generator, major 10, minor 183, and the canonical device name is
+	  /dev/hwrng.
+	  The way to make use of this is to install the rng-tools package
+	  (check your distro, or download from
+	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
+	  /dev/hwrng and injects the entropy into /dev/random.


-- 
Jean Delvare
SUSE L3 Support
