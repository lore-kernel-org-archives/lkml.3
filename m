Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3D2JQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:16:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62425 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2JQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:16:04 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-f1-517e3a4afc4c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/5] watchdog: imx2_wdt: use devm_clk_get()
Date: Mon, 29 Apr 2013 18:15:53 +0900
Message-id: <000301ce44ba$266397b0$732ac710$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EuiWxn4z7zvddSUq3ly0Okaz3Mg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zI10vq7pAg1+bBS3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	lnXNZSzYylkx/xB7A+Nj9i5GTg4JAROJRSu/MkPYYhIX7q1nA7GFBJYxSqz47QdTM2XnaqA4
	F1B8EaPEtLPXGCGcX4wSfQcnsIBUsQmoSXz5chhoKgeHiIC+RFuLBkgNs0AHo8SBp0tZQWqE
	BZwk5q/dzwhiswioSnz6toQJxOYVsJSYtXMXI4QtKPFj8j2wmcwCWhLrdx5ngrDlJTaveQt1
	qYLEjrOvwepFBPQkVq3YzwZRIyKx78U7sOMkBPaxS0z/tocFYpmAxLfJh1hAjpMQkJXYdABq
	jqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxgh
	0da3g/HmAetDjMlA6ycyS4km5wOjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjAa/ctf/1LSIPRWQJ32cf4fMjje7ha/2n9yXxqp3q+Nl3otD
	m2SKZe+fZhJd8WjmKYaHynvP9nNN3Hhni1XvjAK3+/pnw3wPftTosT0Q+IXT/WTbI75Xbzdk
	M6jrVuafK7zW7MSfdLVoqdfzCU1eU5ozTmVmOTZJn3ly399WKNj1e5o7T35evxJLcUaioRZz
	UXEiAHV36XrMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV0vq7pAg2mneC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM5Z1zWUs2MpZMf8QewPjY/YuRk4OCQETiSk7V7NB2GIS
	F+6tB7K5OIQEFjFKTDt7jRHC+cUo0XdwAgtIFZuAmsSXL4eBujk4RAT0JdpaNEBqmAU6GCUO
	PF3KClIjLOAkMX/tfkYQm0VAVeLTtyVMIDavgKXErJ27GCFsQYkfk++BzWQW0JJYv/M4E4Qt
	L7F5zVtmiIsUJHacfQ1WLyKgJ7FqxX42iBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJywJGllWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdH8TGoH48oGi0OMAhyMSjy8AZtrA4VYE8uKK3MP
	MUpwMCuJ8Coa1QUK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w0eSVxBsam5gZWRqZWRiZ
	mJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6NthlfQuffq0YY//qa9LHxy4MzE88vD
	62YL6/PL/O9XKRSZ/eKLDrPSlACTU7OP6ujN2WZ6irnjnujblbMP3/Pc4KEX9UGKeYqprP1e
	1ccNSjp3VJ5LhgkrcPwzuH5WedudfeeiTH6UpD3ebJmUvnW7t4LF7dOqkvMNKn5+vOsowH30
	ROx/03NKLMUZiYZazEXFiQB7v1PDKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/imx2_wdt.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index ff90882..0c2b075 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -266,7 +266,7 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(imx2_wdt.base))
 		return PTR_ERR(imx2_wdt.base);
 
-	imx2_wdt.clk = clk_get(&pdev->dev, NULL);
+	imx2_wdt.clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imx2_wdt.clk)) {
 		dev_err(&pdev->dev, "can't get Watchdog clock\n");
 		return PTR_ERR(imx2_wdt.clk);
@@ -291,7 +291,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 
 fail:
 	imx2_wdt_miscdev.parent = NULL;
-	clk_put(imx2_wdt.clk);
 	return ret;
 }
 
@@ -304,8 +303,7 @@ static int __exit imx2_wdt_remove(struct platform_device *pdev)
 
 		dev_crit(imx2_wdt_miscdev.parent,
 			"Device removed: Expect reboot!\n");
-	} else
-		clk_put(imx2_wdt.clk);
+	}
 
 	imx2_wdt_miscdev.parent = NULL;
 	return 0;
-- 
1.7.2.5


