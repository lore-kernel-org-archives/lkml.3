Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaEZQRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:17:31 -0400
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:33018 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637AbaEZQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:17:30 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 12:17:30 EDT
From: Joel Porquet <joel@porquet.org>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joel Porquet <joel@porquet.org>
Subject: [PATCH] staging: silicom/bypasslib/bp_ioctl.h: Fix erroneous global variable definitions
Date: Mon, 26 May 2014 18:07:38 +0200
Message-Id: <1401120458-931-1-git-send-email-joel@porquet.org>
X-Mailer: git-send-email 1.9.3
X-Ovh-Tracer-Id: 7417428586925944950
X-Ovh-Remote: 132.227.92.188 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, this header was defining two new typedefs, CMND_TYPE and
CMND_TYPE_SD, following this type of declaration:

typedef enum {
	...
} CMND_TYPE;

A previous commit (785086556a573f07747b3633732a9dbd7e45728f) tried to
fix warnings that were pointed out by checkpatch.pl, concerning not
adding new typedefs. But this commit only removed the 'typedef' keyword,
thus transforming both the typedefs into two the definition of global
variables. For example:

enum {
	...
} CMND_TYPE;

As noticed by the Sparse tool, this patch removes those erroneous global
variable definitions, and just leaves anonymous enum type definitions:

enum {
	...
};

Signed-off-by: Joel Porquet <joel@porquet.org>
---
Only test by compilation.
 drivers/staging/silicom/bypasslib/bp_ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bp_ioctl.h b/drivers/staging/silicom/bypasslib/bp_ioctl.h
index bf47f78..a13932a 100644
--- a/drivers/staging/silicom/bypasslib/bp_ioctl.h
+++ b/drivers/staging/silicom/bypasslib/bp_ioctl.h
@@ -101,7 +101,7 @@ enum {
 	SET_BP_WAIT_AT_PWUP,
 	GET_BP_HW_RESET,
 	SET_BP_HW_RESET,
-} CMND_TYPE;
+};
 
 enum {
 	IF_SCAN_SD,
@@ -154,7 +154,7 @@ enum {
 	GET_BP_HW_RESET_SD,
 	SET_BP_HW_RESET_SD,
 
-} CMND_TYPE_SD;
+};
 
 #define SIOCGIFBYPASS (SIOCDEVPRIVATE+10)
 
-- 
1.9.3

