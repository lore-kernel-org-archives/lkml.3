Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaGKOMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:12:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaGKOEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:35 -0400
X-AuditID: cbfee61a-f79e46d00000134f-71-53bfeef1133e
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 01/21] leds: make brightness type consistent across
 whole subsystem
Date: Fri, 11 Jul 2014 16:04:04 +0200
Message-id: <1405087464-13762-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd2P7/YHGxzdbG6xccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8a7GwfYCmaxV6w7uZW5gfEDaxcjB4eEgInEtJ96XYyc
	QKaYxIV769lAbCGB6YwSC654djFyAdntTBLLNu1iB0mwCRhK/HzxmgnEFhEol+h5/4wNpIhZ
	YDWjxJ2tX1lBEsICMRLrn55jBrFZBFQl7j+4CDaVV8BD4tePbewQixUk5kyyAQlzCnhKHOy/
	CbXYQ+Lh2hPsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDq5nUjsYVzZYHGIU
	4GBU4uFVWL8vWIg1say4MvcQowQHs5II79U3+4OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5o
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MBatWdcdxLZN+OdqQaNFj1hevShV2MMvrGRxby17YMil
	07P/Mm+6ZFJQyqQ042/YlQhXU7E9JvbOKr2y1eF7Ty1kv7je6txJo6/t2uvaS02bXX4cEXEI
	tt9c9EXTO6aMZ8bkdsnG3V3CrZufvzHya2qsuxp+fXGNe2L0Al+pCUZxa0Ivvf67XYmlOCPR
	UIu5qDgRAKZXCG0qAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentations states that brightness units type is enum led_brightness
and this is the type used by the led API functions. Adjust the type
of brightness variables in the struct led_classdev accordingly.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 include/linux/leds.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index e436864..995f933 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -31,8 +31,8 @@ enum led_brightness {
 
 struct led_classdev {
 	const char		*name;
-	int			 brightness;
-	int			 max_brightness;
+	enum led_brightness	 brightness;
+	enum led_brightness	 max_brightness;
 	int			 flags;
 
 	/* Lower 16 bits reflect status */
-- 
1.7.9.5

