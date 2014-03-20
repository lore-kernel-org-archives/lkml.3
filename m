Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbaCTJsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:48:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45510 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaCTJs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:48:26 -0400
Date: Thu, 20 Mar 2014 02:48:20 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH v6 00/36] mtd: st_spi_fsm: Add new driver
Message-ID: <20140320094820.GJ31517@norris-Latitude-E6410>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 09:20:32AM +0000, Lee Jones wrote:
> This should be the final version (again) :)
> 
> Version 6:
>   Serviced 3 nits picked up by Brian during final review.

I'm really sorry to do this again, but can you *please* read *all* of my
comments? You're missing at least the following diff! I'm fine with an
incremental patch on top of this series.

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index aefd48db7ade..6369636e980a 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -3,7 +3,7 @@
  *
  * Author: Angus Clark <angus.clark@st.com>
  *
- * Copyright (C) 2010-2014 STicroelectronics Limited
+ * Copyright (C) 2010-2014 STMicroelectronics Limited
  *
  * JEDEC probe based on drivers/mtd/devices/m25p80.c
  *
@@ -1730,14 +1730,6 @@ static int stfsm_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 	dev_dbg(fsm->dev, "%s to 0x%08x, len %zd\n", __func__, (u32)to, len);
 
-	*retlen = 0;
-
-	if (!len)
-		return 0;
-
-	if (to + len > mtd->size)
-		return -EINVAL;
-
 	/* Offset within page */
 	page_offs = to % FLASH_PAGESIZE;
 
