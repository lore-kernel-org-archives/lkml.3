Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaDHLJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:09:43 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47148 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaDHLJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:09:39 -0400
Date: Tue, 8 Apr 2014 19:09:27 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>, Joe Perches <joe@perches.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?us-ascii?B?PT91cy1hc2NpaT9RPz0zRD0zRnV0Zi04PTNGQj0zRlZNTzhiR2x1SU1T?=
	 =?us-ascii?B?d2VtVnk9M0Y9M0Q/PQ==?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: vt6655: iwctl.c: fix a sparse warning
Message-ID: <20140408110927.GA17308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for correcting my patch format.

Signed-off-by: Jimmy Li <coder.liss@gmail.com>
---
v1 fix a sparse warning.
	(iwctl.c:1846:35: expected restricted gfp_t [usertype] flags)
v2 clear up two unnecessary variable, buf and blen.
v3 fix patch format.
 drivers/staging/vt6655/iwctl.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index ac3fc16..394031b 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1835,19 +1835,14 @@ int iwctl_siwencodeext(struct net_device *dev,
 	size_t seq_len = 0, key_len = 0;
 //
 	// int ii;
-	u8 *buf;
-	size_t blen;
 	u8 key_array[64];
 	int ret = 0;
 
 	PRINT_K("SIOCSIWENCODEEXT...... \n");
 
-	blen = sizeof(*param);
-	buf = kmalloc((int)blen, (int)GFP_KERNEL);
-	if (buf == NULL)
+	param = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
+	if (param == NULL)
 		return -ENOMEM;
-	memset(buf, 0, blen);
-	param = (struct viawget_wpa_param *)buf;
 
 //recover alg_name
 	switch (ext->alg) {
-- 
1.7.9.5

