Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaF1SXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:23:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaF1RvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3.15 003/139] extcon: max8997: Fix NULL pointer exception on missing pdata
Date: Sat, 28 Jun 2014 10:46:04 -0700
Message-Id: <20140628174605.515716152@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit dfee4111febf3d9ef3a640b2cd6205c75f4e7e3d upstream.

Fix NULL pointer exception when platform data is not supplied. The
driver dereferenced pdata pointer where it could be NULL.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 810d601f07c
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -715,7 +715,7 @@ static int max8997_muic_probe(struct pla
 		goto err_irq;
 	}
 
-	if (pdata->muic_pdata) {
+	if (pdata && pdata->muic_pdata) {
 		struct max8997_muic_platform_data *muic_pdata
 			= pdata->muic_pdata;
 


