Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3COJUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:20:15 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:40987 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COJUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:20:12 -0400
MIME-Version: 1.0
Date: Fri, 15 Mar 2013 17:20:08 +0800
Message-ID: <CAPgLHd8xSWod=EcL=DuqCBO4LzDXNY7t6L=8zMSPQfEzLNuPvQ@mail.gmail.com>
Subject: [PATCH -next] staging: sep: fix possible memory leak in sep_prepare_input_dma_table()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, devendra.aaru@gmail.com, peterhuewe@gmx.de,
        rpjday@crashcourse.ca, joe@perches.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

'lli_array_ptr' etc. are malloced in sep_prepare_input_dma_table() and should
be freed before leaving from the error handling case, otherwise it will cause
memory leak.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/sep/sep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index f5b7341..6a98a20 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -1986,7 +1986,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 					dma_ctx,
 					sep_lli_entries);
 		if (error)
-			return error;
+			goto end_function_error;
 		lli_table_alloc_addr = *dmatables_region;
 	}
 


