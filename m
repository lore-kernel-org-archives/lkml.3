Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3AYB4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:56:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38782 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3AYB4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:56:15 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-37-5101e63dd983
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rdunlap@infradead.org
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] extcon: max77693: Fix bug of build error related to INPUT
 subsystem
Date: Fri, 25 Jan 2013 10:56:10 +0900
Message-id: <1359078970-11088-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t8zbV3bZ4yBBl8+m1tc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKWt29iL/jFU/Fq0iKWBsZd3F2MnBwSAiYSTZunM0HY
	YhIX7q1n62Lk4hASWMYocab1FQtM0e8XZ5ggEtMZJT5e2sgMkhAS+M8o8X+BOYjNJqAlsf/F
	DTYQW0RAUmLO9CXMIA3MAucZJVZ8OQY2SVggTOLdjtVANgcHi4CqxNPvPCBhXgFXiVM3bzND
	LJOT+LDnETtIr4TAETaJWffOgyVYBAQkvk0+BNYrISArsekAVL2kxMEVN1gmMAouYGRYxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iRESXFI7GFc2WBxiFOBgVOLhtUhjDBRiTSwrrsw9xCjB
	wawkwusSARTiTUmsrEotyo8vKs1JLT7EmAy0fCKzlGhyPjDw80riDY0NjA0NLQ3NTC1NDUgT
	VhLnZTz1JEBIID2xJDU7NbUgtQhmCxMHp1QDo0GJf7JHjZXs0rUXfrhNnm5pwj6L8crn6C1W
	95nCX978ajzXe9pezsD/3h8kZ372+DRlti9rXo1uTPh3x763wrxS88N2Hyry41n1YIPTb+7/
	aZZ7ebxn7rwmajfp9iLLqP312w/csQ6Ue3Wxfl3vvduvTzRLLrslnpZ0WOnS9zLmdl0RJSH7
	9UosxRmJhlrMRcWJAKVkv69yAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xoK7tM8ZAg3c7jSwu75rDZnFwYRuj
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZy9s3sRf84ql4
	NWkRSwPjLu4uRk4OCQETid8vzjBB2GISF+6tZ+ti5OIQEpjOKPHx0kZmkISQwH9Gif8LzEFs
	NgEtif0vbrCB2CICkhJzpi9hBmlgFjjPKLHiyzEWkISwQJjEux2rgWwODhYBVYmn33lAwrwC
	rhKnbt5mhlgmJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh+4zqR2M
	KxssDjEKcDAq8fBapDEGCrEmlhVX5h5ilOBgVhLhdYkACvGmJFZWpRblxxeV5qQWH2JMBlo+
	kVlKNDkfGFd5JfGGxiZmRpZGZsYm5sbGpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoFx
	N0tpZYslR9rNmLseTQ8YzO9Z2a7wXbN/5v9roSvFSp4VCuk5cme23eo1UJj/WOdwZdm1oiTX
	WQqLlbzDbDvmP11Ss8jgYc1x0/MKX5N3Gfb++7AvjNFVoV5oySbZiQVbwxJWLpu7u/fKDQFf
	1gVZDD/975gdtZrB07aE7bKr2vPN2Sq9X0WUWIozEg21mIuKEwGrsbsPoQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix build error of following log:

drivers/built-in.o: In function `max77693_muic_remove':
extcon-max77693.c:(.text+0x664853): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `max77693_muic_probe':
extcon-max77693.c:(.text+0x664971): undefined reference to `input_allocate_device'
extcon-max77693.c:(.text+0x6649c1): undefined reference to `input_set_capability'
extcon-max77693.c:(.text+0x6649d6): undefined reference to `input_set_capability'
extcon-max77693.c:(.text+0x6649eb): undefined reference to `input_set_capability'
extcon-max77693.c:(.text+0x664a00): undefined reference to `input_set_capability'
extcon-max77693.c:(.text+0x664a15): undefined reference to `input_set_capability'
extcon-max77693.c:(.text+0x664a20): undefined reference to `input_register_device'
drivers/built-in.o: In function `max77693_muic_adc_handler':
extcon-max77693.c:(.text+0x665318): undefined reference to `input_event'
extcon-max77693.c:(.text+0x66532a): undefined reference to `input_event'
make[1]: *** [vmlinux] Error 1

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 07122a9..10df3fa 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -29,7 +29,7 @@ config EXTCON_ADC_JACK
 
 config EXTCON_MAX77693
 	tristate "MAX77693 EXTCON Support"
-	depends on MFD_MAX77693
+	depends on MFD_MAX77693 && INPUT
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	help
-- 
1.8.0

