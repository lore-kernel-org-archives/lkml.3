Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3JKEjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:39:31 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:35858 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3JKEj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:39:29 -0400
MIME-Version: 1.0
Date: Fri, 11 Oct 2013 12:39:28 +0800
Message-ID: <CAPgLHd_Ec7EmzCioPsULjQ0eOoRpx3jHwa-Gr1oTdzqChkX+XQ@mail.gmail.com>
Subject: [PATCH] Staging: crystalhd: use vfree() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: nsankar@broadcom.com, jarod@wilsonet.com, davilla@4pi.com,
        abraham.manu@gmail.com, gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        amarjargal16@gmail.com, dan.carpenter@oracle.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use vfree() instead of kfree() to free vmalloc()
allocated data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/crystalhd/crystalhd_lnx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index b17fbf8..e0c28ed 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -156,7 +156,7 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	if (rc) {
 		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
 			   io->add_cdata_sz, (unsigned int)ua_off);
-		kfree(io->add_cdata);
+		vfree(io->add_cdata);
 		io->add_cdata = NULL;
 		return -ENODATA;
 	}

