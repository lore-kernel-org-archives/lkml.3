Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaIONXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:23:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63983 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaIONXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:23:44 -0400
Message-ID: <5416E80C.7010705@gmail.com>
Date: Mon, 15 Sep 2014 21:22:20 +0800
From: "eagle.rtlinux" <eagle.rtlinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        eagle.rtlinux@gmail.com
Subject: [PATCH] Infiniband coding mistake fixed.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

The last parameter of get_user_pages should be a array of pointers to 
vmas corresponding to each page. Through this coding mistake can not 
cause some problem now, it is a potential time bomb.

Signed-off-by: Yang Honggang <eagle.rtlinux@gmail.com>
---
  drivers/infiniband/hw/qib/qib_user_pages.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c 
b/drivers/infiniband/hw/qib/qib_user_pages.c
index 2bc1d2b..e93d459 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -69,7 +69,7 @@ static int __qib_get_user_pages(unsigned long 
start_page, size_t num_pages,
          ret = get_user_pages(current, current->mm,
                       start_page + got * PAGE_SIZE,
                       num_pages - got, 1, 1,
-                     p + got, vma);
+                     p + got, vma + got);
          if (ret < 0)
              goto bail_release;
      }
-- 
1.7.10.4

