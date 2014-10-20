Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaJTMfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:35:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23382 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaJTMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:35:22 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-a6-54450187b378
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/5] mfd: max77693: Map charger device to its own of_node
Date: Mon, 20 Oct 2014 14:34:46 +0200
Message-id: <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xa7rtjK4hBtMalSw2zljPajHpyXtm
	i/lHzrFaTFw5mdni9QtDi7NNb9gt7n89ymix+XsHm8XlXXPYLD73HmG0WHvkLrvF6W5Wi9O7
	Sxx4PXbOusvusXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	WiYsYit4z1ZxbcscpgbG86xdjJwcEgImEgc/nWWBsMUkLtxbz9bFyMUhJLCUUeLA5oUsEE4f
	k8SJllNgHWwCxhKbly8BqxIR2Mckcer5W2YQh1ngKKPE9N63TCBVwgI+Es/ap4N1sAioSlyZ
	uZYZxOYVcJO4vvETM8Q+OYmTxyaD1XAKuEvM397BCGILAdWcuniIeQIj7wJGhlWMoqmlyQXF
	Sem5RnrFibnFpXnpesn5uZsYIQH6dQfj0mNWhxgFOBiVeHh3mLmECLEmlhVX5h5ilOBgVhLh
	dfkPFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC41HOSmop6gPcd47oFh3K+9QgLuTrlbW0wbZjm
	J/3DW4l/eut17+pVzydaOhX+qFvB+PfZpHcn9lvvmLEnO6pMQ5lZe4aPXLT27QTPK0e21Vpp
	79ad7/DwKXNi4PIDJWfPHFKUnbA2Py/Mdb7HIibtp+tqahm/yLvZ2jpNEpj7cum+z2snrl6k
	xFKckWioxVxUnAgA7sdreS4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
child device (the charger) will have its own of_node set. This will be
used by the max77693 charger driver in next patches to obtain battery
configuration from DTS.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77693.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index cf008f45968c..2277a11b6629 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -43,7 +43,10 @@
 
 static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-pmic", },
-	{ .name = "max77693-charger", },
+	{
+		.name = "max77693-charger",
+		.of_compatible = "maxim,max77693-charger",
+	},
 	{ .name = "max77693-muic", },
 	{ .name = "max77693-haptic", },
 	{
-- 
1.9.1

