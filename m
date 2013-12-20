Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3LTStr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:49:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43313 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3LTSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:15 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-9d-52b490ee6142
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 5/9] ACPI / cpuidle: remove dev->state_count setting
Date: Fri, 20 Dec 2013 19:47:27 +0100
Message-id: <1387565251-7051-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQd13E7YEGTy4IGGxccZ6Vot5n2Ut
	zja9YbfY+fAtm8XlXXPYLD73HmG0mHF+H5PF7+//WC3OnL7E6sDpsWlVJ5vHnWt72DzOz1jI
	6LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGWcbG1jKvjEVtHwbDVbA+Mb1i5GDg4J
	AROJJxvLuxg5gUwxiQv31rN1MXJxCAlMZ5T4OOEWC4TTxSTx63APM0gVm4CVxMT2VYwgtoiA
	qMTl3RPAipgFHjNKzG6aAlYkLOAusfzIQyYQm0VAVeLO5HPsIDYvUPxm/1dGiHWKEt3PJrCB
	2JwCHhKzXy0HqxcCqjnR9Zt5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBIfdM
	egfjqgaLQ4wCHIxKPLwSkVuChFgTy4orcw8xSnAwK4nw3mwDCvGmJFZWpRblxxeV5qQWH2KU
	5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamCc/dvZWykgZZkE299fujdt9B7ukTOYzvi6
	iCvvQ7KJnLBM4h9786oXhyZP+ieeGGJ44m2dpYVG7Icz+11i/wdtWP7u/fcFliqPlzhKL3RV
	CJ1zqcThxxGDkptn+E3eefd1bNG8eurOY43CTOvaVNeSGO0cPUu/7IS2iNkMt1UuX8gqe+QX
	363EUpyRaKjFXFScCABD+9QCNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->state_count is now always equal to drv->state_count and
drv->state_count no longer can change during driver's lifetime so
the default dev->state_count initialization in cpuidle_enable_device()
(called from cpuidle_register_device()) can be used instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_idle.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index c080c99..da8ce91 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -951,8 +951,6 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
 			break;
 	}
 
-	dev->state_count = count;
-
 	if (!count)
 		return -EINVAL;
 
-- 
1.8.2.3

