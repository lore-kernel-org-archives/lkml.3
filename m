Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3H3K2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:28:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13461 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3H3K2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:28:00 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-fc-522073a79f70
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] intel_idle: mark some functions with __init tag
Date: Fri, 30 Aug 2013 12:27:45 +0200
Message-id: <2017492.SHLf7BQHGW@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd3lxQpBBjcPilnM+yxrsfPhWzaL
	y7vmsFl87j3CaNG/sJfJgdVj06pONo871/aweTxa3MLo8XmTXABLFJdNSmpOZllqkb5dAlfG
	p9nTWAvaOCvW/vnA3MB4k72LkYNDQsBEYums0i5GTiBTTOLCvfVsXYxcHEICixglznw+zA7h
	tDBJHLp+mBGkik3ASmJi+yowW0RAXmLTzk4WkCJmgV5GiaOzLjODJIQFXCRen3zKCmKzCKhK
	rP+9nhFkG6+ApsTN00kgYVEBT4lPk5aClfMKCEr8mHyPBcRmBpq5b/9UVghbS2L9zuNMExj5
	ZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgoPymfQOxlUNFocYBTgY
	lXh4G6bKBwmxJpYVV+YeYpTgYFYS4a1IVQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQ
	SCA9sSQ1OzW1ILUIJsvEwSnVwBjy86km7y6VyNbTjZy6L+MduM5mT64r/raseo5HumBFdW3n
	hQQvE+lmkXlzXY9+ucF97veH6pjZR+dNvNYa2ys4ceKHsuuHnU4cnLfy0Fv/SSuFogIiNpWu
	2vFDw0PDYl7cp6+s4hvCFinKJQn8MXJ602HMEdqpwHk72KrIyS2+w4fFe4LgKSWW4oxEQy3m
	ouJEADT0JzxGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_idle_probe() and intel_idle_cpuidle_driver_init() can be marked
with __init tag as they are only called from intel_idle_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 53b24f1..33e599e 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -490,7 +490,7 @@ MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
 /*
  * intel_idle_probe()
  */
-static int intel_idle_probe(void)
+static int __init intel_idle_probe(void)
 {
 	unsigned int eax, ebx, ecx;
 	const struct x86_cpu_id *id;
@@ -558,7 +558,7 @@ static void intel_idle_cpuidle_devices_uninit(void)
  * intel_idle_cpuidle_driver_init()
  * allocate, initialize cpuidle_states
  */
-static int intel_idle_cpuidle_driver_init(void)
+static int __init intel_idle_cpuidle_driver_init(void)
 {
 	int cstate;
 	struct cpuidle_driver *drv = &intel_idle_driver;
-- 
1.8.2.3


