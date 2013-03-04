Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3CDIEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:04:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14323 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab3CDIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:04:48 -0500
X-AuditID: cbfee68d-b7f636d0000009be-b1-5134559fef94
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 18/24] rtc: rtc-pxa: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:04:47 +0900
Message-id: <014b01ce18ae$f0674940$d135dbc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAP71w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfd0FoSaBBg1nGC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmPFgD3PBKfaKsxM/MjYw7mfrYuTkkBAwkbjz/AAzhC0mceHeeqA4F4eQwDJGiY07
	ZjHBFK24fpsdIjGdUWLLjT5mCOcXo8TEO6fB2tkE1CS+fDkMVMXBISKgL9HWogFSwyzQyyhx
	pnc3O0iNkICtxJeHD8CmcgrYSdw/t4oVxBYWcJfonAsxh0VAVeJA+1uwOC9Q/cXZ51ggbEGJ
	H5PvgdnMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxM8N9xkhSkQk9r14xwhyj4TA
	PXaJDS9PsUPsEpD4NvkQC0SvrMQmWEhIShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpa
	kFxQnJReZKhXnJhbXJqXrpecn7uJERKrvTsYbx+wPsSYDLR+IrOUaHI+MNbzSuINjY1NzExM
	TcwtTc1NSRNWEueVuyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxXpEds7Oy5NRIRyHx
	//eu3kiWer5j905hZenr5pvEv1ma2+/08TjytYZXWeDZkgMVzFrdVeuX1BT7rzhzXeP6brHw
	V/E1FX+d2hn21C7OEVRf9/VT0JaLoaoRDj9z3ux2urDBhamXnVlVZcJE2WMGMx2Wb36VInKg
	fPU2kRffv2UkB55d7vFciaU4I9FQi7moOBEAmx2dD+sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd35oSaBBhu3W1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHjwR7mglPsFWcnfmRsYNzP1sXIySEhYCKx
	4vptdghbTOLCvfVAcS4OIYHpjBJbbvQxQzi/GCUm3jnNDFLFJqAm8eXLYaAODg4RAX2JthYN
	kBpmgV5GiTO9u8EmCQnYSnx5+IAJxOYUsJO4f24VK4gtLOAu0TkXYg6LgKrEgfa3YHFeoPqL
	s8+xQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7ogYREBI4mfG+4zQpSISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Ez6R2
	MK5ssDjEKMDBqMTDK/DJOFCINbGsuDL3EKMEB7OSCG+ZhEmgEG9KYmVValF+fFFpTmrxIcZk
	oEcnMkuJJucDk1ReSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCU
	amDcu/Bdm3+2VcnJk3bKudo3LG0OyO34skCtp/H6seO5bNPkJRUfFxd49W+feaM31Mp2h+T5
	VaIsL63nfBQqln9bq7alLjv4ieuBA8d/tk3jXlkgzZz8NPrT8eVzp2yVZVj078qBtI+Nz88F
	Pwss/1Iw+5Dx9vX5gW+XOjk4RHAszFp3/wzLA/lKJZbijERDLeai4kQALcaoX0gDAAA=
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
 drivers/rtc/rtc-pxa.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index b7e46297..72e13da 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -502,18 +502,7 @@ static struct platform_driver pxa_rtc_driver = {
 	},
 };
 
-static int __init pxa_rtc_init(void)
-{
-	return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
-}
-
-static void __exit pxa_rtc_exit(void)
-{
-	platform_driver_unregister(&pxa_rtc_driver);
-}
-
-module_init(pxa_rtc_init);
-module_exit(pxa_rtc_exit);
+module_platform_driver_probe(pxa_rtc_driver, pxa_rtc_probe);
 
 MODULE_AUTHOR("Robert Jarzmik <robert.jarzmik@free.fr>");
 MODULE_DESCRIPTION("PXA27x/PXA3xx Realtime Clock Driver (RTC)");
-- 
1.7.2.5


