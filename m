Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaARJuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 04:50:44 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50581 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaARJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 04:50:40 -0500
Message-ID: <52DA4E6A.1000308@gmail.com>
Date: Sat, 18 Jan 2014 17:50:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        bergwolf@gmail.com, jinshan.xiong@intel.com, oleg.drokin@intel.com,
        jacques-charles.lafoucriere@cea.fr
CC: devel@driverdev.osuosl.org, linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, not all compilers assumes the structures within a pack
region also need be packed (e.g. metag), so need add a pack explicitly
to satisfy all compilers.

The related error (under metag with allmodconfig):

    CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
  drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
  drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
  drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here

And originally, all related code used "__attribute__((packed))", so
still use it instead of '__packed'.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre/lustre_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 6b6c0240..0828b31 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -345,7 +345,7 @@ struct lov_user_md_v3 {	   /* LOV EA user data (host-endian) */
 					   * lmm_objects, use when writing */
 		__u16 lmm_layout_gen;     /* layout generation number
 					   * used when reading */
-	};
+	} __attribute__((packed));
 	char  lmm_pool_name[LOV_MAXPOOLNAME]; /* pool name */
 	struct lov_user_ost_data_v1 lmm_objects[0]; /* per-stripe data */
 } __attribute__((packed));
-- 
1.7.11.7
