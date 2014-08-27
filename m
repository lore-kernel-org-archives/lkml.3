Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451AbaH0Pef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:34:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26625 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934491AbaH0PU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:27 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-dc-53fdf738e3c3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/8] mfd: max14577: Map charger device to its own of_node
Date: Wed, 27 Aug 2014 17:20:08 +0200
Message-id: <1409152814-17302-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oW3/8GG0x4I2axccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbP4
	3HuE0WLtkbvsFkuvX2SymDB9LYtF694j7Banu1ktTu8ucRD2WDNvDaPH5b5eJo+ds+6ye6xc
	/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwRXHZpKTmZJalFunbJXBlzL7RwVJw
	mL3i3cuTbA2M89i6GDk5JARMJH53PYSyxSQu3FsPZHNxCAksZZS4uOIsE4TTxySx8sVVRpAq
	NgFjic3Ll4B1iAgsYJK4uC4XxGYWOMMsMXU1B4gtLOAjcaptETuIzSKgKvGydxkziM0r4C4x
	5eBPFohtchInj01mBbE5BTyAai4ALeMAWuYucXce/wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OL
	S/PS9ZLzczcxQoL+6w7GpcesDjEKcDAq8fAqnP4TLMSaWFZcmXuIUYKDWUmEt+zA32Ah3pTE
	yqrUovz4otKc1OJDjEwcnFINjNp/5VezNwnaq4sasRTyXFx2oGpXe/TRFUlbXxU9sdn9db4c
	8/HNf343dlTfNvL9Lsf4Z8aN13Xp9c6OP/wuy07ICPVS+H27I1Zv5Zz+h+v+/DI1yJ19i6uL
	PW/xO5bVgY79f7jSpTL2rTJSnCCwYWLkVOmjvZcrsixnHVyn/NxTvbf4bP/KMiWW4oxEQy3m
	ouJEAMlAK1pYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "maxim,max14577-charger" of_compatible to the mfd_cell so the
MFD child device (the charger) will have its own of_node set. This will
be used by the max14577 charger driver in next patches to obtain battery
configuration from DTS.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max14577.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 4a5e885383f8..6599407b5624 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -35,7 +35,10 @@ static const struct mfd_cell max14577_devs[] = {
 		.name = "max14577-regulator",
 		.of_compatible = "maxim,max14577-regulator",
 	},
-	{ .name = "max14577-charger", },
+	{
+		.name = "max14577-charger",
+		.of_compatible = "maxim,max14577-charger",
+	},
 };
 
 static const struct mfd_cell max77836_devs[] = {
-- 
1.9.1

