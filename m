Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3D2JfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:35:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65148 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3D2JfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:35:16 -0400
X-AuditID: cbfee68f-b7f066d000003683-ee-517e3ed3a2e7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Date: Mon, 29 Apr 2013 18:35:15 +0900
Message-id: <000d01ce44bc$da891380$8f9b3a80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvNnE6pmG7KO0SueQxGHKmjzsag==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zY93LdnWBBqt6RC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	mr94FHxhq9hx5BJLA+M91i5GTg4JAROJF0/vMEHYYhIX7q1n62Lk4hASWMYocWXnJEaYos9/
	P7BCJKYzSqxcP5sdwvnFKPFl3iuwUWwCahJfvhwGSnBwiAjoS7S1aIDUMAt0MEoceLoUrEZY
	wFVi6ZuNYFNZBFQlFnScB1vNK2ApcfPMd0YIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkNc
	pCCx4+xrsHoRAT2Jadd2MkLUiEjse/GOEWSxhMAudom2ue9YIZYJSHybfIgF5DgJAVmJTQeg
	5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kR
	Em/9OxjvHrA+xJgMtH4is5Rocj4wXvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwGjG+iDm6NyexhtpHitvHbv75NPJ/LcGj6+VhtbP1VLZrPJ2
	3oTwlXcavq26PCt/V4+OSFH90qS5X12s+89IRpUl9FxTqzZfesGHNU/v3vc6gSuHgtm14204
	XpwtOuK7/bbJ8h2tf19zVvKFP/Rm3tV86vOskjDVM0tMvOacEHE+UnaAYW1PA7MSS3FGoqEW
	c1FxIgD71E9TzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd3LdnWBBtMbBC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM5q/eBR8YavYceQSSwPjPdYuRk4OCQETic9/P0DZYhIX
	7q1n62Lk4hASmM4osXL9bHYI5xejxJd5r8Cq2ATUJL58OQyU4OAQEdCXaGvRAKlhFuhglDjw
	dClYjbCAq8TSNxsZQWwWAVWJBR3nmUBsXgFLiZtnvjNC2IISPybfYwGxmQW0JNbvPM4EYctL
	bF7zlhniIgWJHWdfg9WLCOhJTLu2kxGiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwND+T3sG4qsHiEKMAB6MSD2/A5tpAIdbEsuLK3EOM
	EhzMSiK8KyzrAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5ho8kriDY1NzIwsjcwsjEzM
	zUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcV1goEGs7xfxvQ/XXfR4/e7FnNMuHPHz
	1p2/sup7mkqOV4z/qfNxTvUmmdO5NVuV7jnbJ64q5tums9XSN2qzYd79A7tmS0q9rGiR2Gdy
	/qlUWYjwz3n7f3feTNbMX++bPtVje+b9xhILcfs45reP+1nPbFpWFp9xbPpHL26r1593eOd/
	l62JUGIpzkg01GIuKk4EAGFOs1UqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/mv64x60_wdt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index c7fb878..e4cf980 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -276,7 +276,7 @@ static int mv64x60_wdt_probe(struct platform_device *dev)
 	if (!r)
 		return -ENODEV;
 
-	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
+	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
 
@@ -293,8 +293,6 @@ static int mv64x60_wdt_remove(struct platform_device *dev)
 
 	mv64x60_wdt_handler_disable();
 
-	iounmap(mv64x60_wdt_regs);
-
 	return 0;
 }
 
-- 
1.7.2.5


