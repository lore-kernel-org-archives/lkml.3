Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaIWLnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:43:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53036 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaIWLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:43:42 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-aa-54215cebe0f8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 8/8] Documentation: charger: max14577: Document exported
 sysfs entry
Date: Tue, 23 Sep 2014 13:43:23 +0200
Message-id: <1411472603-11821-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
References: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7qvYxRDDHr2SlvMWb+GzWLjjPWs
	FlMfPmGzmPTkPbPF/CPnWC0mrpzMbNH/ZiGrxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFls
	/t7BZnF51xw2i8+9Rxgt1h65y26x9PpFJosJ09eyWLTuPcJucbqb1eL07hIHUY8189Ywelzu
	62Xy2DnrLrvHyuVf2Dw2r9Dy2LSqk83jzrU9bB4nZvxm8Zh3MtCjb8sqRo/Pm+QCuKO4bFJS
	czLLUov07RK4Mo4c2MNYcIKr4vSjXWwNjF85uhg5OSQETCS+zP3OCGGLSVy4t56ti5GLQ0hg
	KaPEzz8HWSGcPiaJGQv3sYNUsQkYS2xevgSsSkRgIaPEzCUr2UEcZoEprBKPf7eyglQJC0RK
	dJw+ygJiswioSny5+IINxOYVcJd4tfUgM8Q+OYmTxyYD1XNwcAp4SCzc6wgSFgIqefSvm3UC
	I+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFx8XUH49JjVocYBTgYlXh4PdYohAix
	JpYVV+YeYpTgYFYS4X0XphgixJuSWFmVWpQfX1Sak1p8iJGJg1OqgbFAzymL+4C+Tshtzr9d
	UglntthOeLLaU/pVoepmp69hiYzzea7y37wk1mP+7cCfW1JFXM//Gm55LTJtQ630zC2TV1Wk
	rpk85XpW5a81F1T8XC/H5/Gz31/8hyF4auGk6rsl/vHX556ttmy9qZplXt355q7f6xemDkb+
	wStfbnmnL/idU9aKLV+JpTgj0VCLuag4EQB9ce+FaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the 'fast charge timer' setting exported by max14577 driver
through sysfs entry.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-power | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 78c7baca3587..ad4fb90ab23d 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -18,3 +18,17 @@ Description:
 		This file is writeable and can be used to set the assumed
 		battery 'full level'. As batteries age, this value has to be
 		amended over time.
+
+What:		/sys/class/power_supply/max14577-charger/device/fast_charge_timer
+Date:		July 2014
+KernelVersion:	3.18.0
+Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+Description:
+		This entry shows and sets the maximum time the max14577
+		charger operates in fast-charge mode. When the timer expires
+		the device will terminate fast-charge mode (charging current
+		will drop to 0 A) and will trigger interrupt.
+
+		Valid values:
+		- 5, 6 or 7 (hours),
+		- 0: disabled.
-- 
1.9.1

