Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3D3FAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:00:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25033 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3D3FAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:00:51 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-0f-517f5002abed
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Date: Tue, 30 Apr 2013 14:00:49 +0900
Message-id: <001001ce455f$aefd0430$0cf70c90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX65Bv3IEgaQ4SbORvrBc8MXPmg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ12mgPpAg89nxSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aLuwkFe9krHl6bztrAOJuti5GTQ0LAROL25eXMELaYxIV764HiXBxCAssY
	JXav7mOEKbq8bgU7RGIRo8TP97+YIZxfjBKX935hAaliE1CT+PLlMFAVB4eIgL5EW4sGSA2z
	wAZGiZP//7KD1AgLOErsPfsbzGYRUJV4+e0b2AZeAUuJPa9WsUDYghI/Jt8Ds5kFtCTW7zzO
	BGHLS2xe8xbqVAWJHWdfg/WKCOhJzP/ykRmiRkRi34t3jCCLJQROsUtsnvyOFWKZgMS3yYdY
	QI6TEJCV2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFRnrFibnF
	pXnpesn5uZsYITHYt4Px5gHrQ4zJQOsnMkuJJucDYzivJN7Q2MzIwtTE1NjI3NKMNGElcV61
	FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzMn859762pSt03NbDTWu36/4gLHLLek+Zf
	/JK+w2B/+BKzXq/DNpLRO4oET23uzj9Y4ZR4obvlSsTD/uU6x7RqW1SM5WSXqM8qWt9ywFX5
	7MP5h10nvZxmWV7n8Ebvl9G0pwasZzen1vc53rot49yb8uVPEbcu49ZjtvUN009PjsmUzZ9+
	/5ASS3FGoqEWc1FxIgD/5VbR1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAV2mgPpAg9b3QhZz1q9hs7i88BKr
	xeVdc9gsbqzbx27xZOEZJotbM16wOrB5XNss5nFixm8Wj53fG9g9+rasYvT4vEkugDWqgdEm
	IzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gCJYWyxJxS
	oFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGi7sJBXvZKx5em87awDibrYuRk0NC
	wETi8roV7BC2mMSFe+uB4lwcQgKLGCV+vv/FDOH8YpS4vPcLC0gVm4CaxJcvh4E6ODhEBPQl
	2lo0QGqYBTYwSpz8/xdskrCAo8Tes7/BbBYBVYmX374xgti8ApYSe16tYoGwBSV+TL4HZjML
	aEms33mcCcKWl9i85i0zxEUKEjvOvgbrFRHQk5j/5SMzRI2IxL4X7xgnMArMQjJqFpJRs5CM
	moWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ah/JrWDcWWDxSFGAQ5GJR7eHUvq
	AoVYE8uKK3MPMUpwMCuJ8EY71gcK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w+eSVxBsa
	m5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2O2h3nwus6V0548u7J/
	5Rkt5m7Z7b82L79zae4K3ejEE9pPtv3iPm20MLlyR8PGDL61t25FMdwRvPtgxord87hn7EwT
	CdxyeHMsS7Z23XOW7dM/5hh8ul3N/4rvSYz/nFz+pJNvZlef2bzgq4i5SV7SkXC5YIVzuYun
	+T8JTL52SM5WWKt0q4CGEktxRqKhFnNRcSIAPxWCRjQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap() to make cleanup paths simpler.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

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


