Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaJaKOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:14:21 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44260 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbaJaKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:14:20 -0400
MIME-Version: 1.0
Date: Fri, 31 Oct 2014 18:14:19 +0800
Message-ID: <CAFNq8R7xYA2GTpWE-5rHr5c-xX0ZONKHX6wSbra2MDo1M2DSHQ@mail.gmail.com>
Subject: [PATCH] Frontswap: fix the condition in BUG_ON
From: Li Haifeng <omycle@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 012a564c7210346b99d12e3d2485542bb090586e Mon Sep 17 00:00:00 2001
From: Haifeng Li <omycle@gmail.com>
Date: Fri, 31 Oct 2014 17:40:44 +0800
Subject: [PATCH] Frontswap: fix the condition in BUG_ON

The largest index of swap device is MAX_SWAPFILES-1. So the type
should be less than MAX_SWAPFILES.

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 mm/frontswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index c30eec5..1b80c05 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -182,7 +182,7 @@ void __frontswap_init(unsigned type, unsigned long *map)
        if (frontswap_ops)
                frontswap_ops->init(type);
        else {
-               BUG_ON(type > MAX_SWAPFILES);
+               BUG_ON(type >= MAX_SWAPFILES);
                set_bit(type, need_init);
        }
 }
-- 
1.9.1
