Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3CDIEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:04:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54782 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3CDIEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:04:32 -0500
X-AuditID: cbfee68d-b7f636d0000009be-5b-513455881c4f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 17/24] rtc: rtc-ps3: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:04:24 +0900
Message-id: <014a01ce18ae$e294c5e0$a7be51a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAPCjA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA92OUJNAg+PfLC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmLHhLkvBcvaKww+6WRoY57N1MXJySAiYSLy+ehLKFpO4cG89kM3FISSwjFHi/fJP
	LDBFd3YuhEpMZ5T4NfEsM4Tzi1FiQnsDK0gVm4CaxJcvh9m7GDk4RAT0JdpaNEBqmAV6GSXO
	9O5mB6kRErCV+PLwAROIzSlgJ3H/3CqwXmEBd4nTbxaC1bAIqEpsO74ErIYXqL7t01xWCFtQ
	4sfke2AXMQtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhKXTsxjhCgRkdj34h0jyD0S
	AvfYJZY8/s4KsUtA4tvkQywQvbISmw4wQzwsKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUV
	o2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkis9u5gvH3A+hBjMtD6icxSosn5wFjPK4k3NDY2
	MTMxNTG3NDU3JU1YSZxX7pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGqTNprG1HzRge
	226bv5GBP1WkWCz00Uyf6uOHn8tv+NyzOM2njHkPz4VvDMVZU+Jnfnux4D+bVHfgz3vvjvaE
	/it4KmfMdyrgyd16k8lFczKKnV9eaWhVuC7xuj4jeZYWxzTXKac8sg5dXeU8SUvkj1oZD7fE
	R4/4owfCStbMm7w15Fj89OthSizFGYmGWsxFxYkAE/rreusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2OUJNAg8efTC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJix4S5LwXL2isMPulkaGOezdTFyckgImEjc
	2bkQyhaTuHBvPZDNxSEkMJ1R4tfEs8wQzi9GiQntDawgVWwCahJfvhxm72Lk4BAR0Jdoa9EA
	qWEW6GWUONO7mx2kRkjAVuLLwwdMIDangJ3E/XOrwHqFBdwlTr9ZCFbDIqAqse34ErAaXqD6
	tk9zWSFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxKUT8xghSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ4Jn
	0jsYVzVYHGIU4GBU4uEV+GQcKMSaWFZcmXuIUYKDWUmEt0zCJFCINyWxsiq1KD++qDQntfgQ
	YzLQoxOZpUST84FJKq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBx
	cEo1MCpqcaWV6jySfD89siTZ5I3Cmb5P7mndvAE/9vSdaDU0c+QQ28cROam1QKLy+4nDBXqH
	fgaFx8/WWhpaePdowtdvPstm5tTOux9xVzh4flyD/7mS9VkRCYmsNzLmJa7reKpwo0VRf8as
	7G3y57RuPTSVFDhfvJZvf2zvwzU/03Y0Kx6y2b9OXImlOCPRUIu5qDgRALdrplZIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ps3.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
index 968133c..846722d 100644
--- a/drivers/rtc/rtc-ps3.c
+++ b/drivers/rtc/rtc-ps3.c
@@ -85,18 +85,7 @@ static struct platform_driver ps3_rtc_driver = {
 	.remove = __exit_p(ps3_rtc_remove),
 };
 
-static int __init ps3_rtc_init(void)
-{
-	return platform_driver_probe(&ps3_rtc_driver, ps3_rtc_probe);
-}
-
-static void __exit ps3_rtc_fini(void)
-{
-	platform_driver_unregister(&ps3_rtc_driver);
-}
-
-module_init(ps3_rtc_init);
-module_exit(ps3_rtc_fini);
+module_platform_driver_probe(ps3_rtc_driver, ps3_rtc_probe);
 
 MODULE_AUTHOR("Sony Corporation");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


