Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbaF1SyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:54:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaF1RtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3.14 008/110] extcon: max14577: Properly handle regmap_irq_get_virq error
Date: Sat, 28 Jun 2014 10:46:05 -0700
Message-Id: <20140628174545.811532837@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 369afd4ba22f5b8de0c9229b6e62b3f9e2207034 upstream.

The regmap_irq_get_virq may return 0 or -EINVAL on error. Fail the probe
in both situations.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-max14577.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -650,7 +650,7 @@ static int max14577_muic_probe(struct pl
 		unsigned int virq = 0;
 
 		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
-		if (!virq)
+		if (virq <= 0)
 			return -EINVAL;
 		muic_irq->virq = virq;
 


