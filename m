Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967341Ab3E3Cgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:36:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39783 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859Ab3E3CgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:36:25 -0400
X-Spam-Score: -100.8
Message-ID: <51A6BAF6.4010901@asianux.com>
Date: Thu, 30 May 2013 10:35:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tony.luck@intel.com, fenghua.yu@intel.com
CC: linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: ia64: hp: sim: sprintf() memory overflow, need really
 use the default value just as it has already said.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When "strlen(s) > MAX_ROOT_LEN", it has already said to use the default
value, but in fact, it still use the input value.

If happens, next sprintf() for 'fname' in simscsi_queuecommand_lck()
may be memory overflow.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/ia64/hp/sim/simscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 331de72..3a428f1 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -88,8 +88,8 @@ simscsi_setup (char *s)
 	if (strlen(s) > MAX_ROOT_LEN) {
 		printk(KERN_ERR "simscsi_setup: prefix too long---using default %s\n",
 		       simscsi_root);
-	}
-	simscsi_root = s;
+	} else
+		simscsi_root = s;
 	return 1;
 }
 
-- 
1.7.7.6
