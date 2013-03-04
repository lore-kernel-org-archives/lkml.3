Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3CDICU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:02:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32515 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CDICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:02:18 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-d3-51345509e8e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 12/24] rtc: rtc-msm6242: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:02:17 +0900
Message-id: <014501ce18ae$96f88a90$c4e99fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAKUZg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfV3OUJNAg50zTS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOPmyh62giaPiS+dFtgbGn2xdjJwcEgImEt0vzrNC2GISF+6tB4pzcQgJLGOUWDn9
	BWMXIwdE0dlIiPh0RolF089DFf1ilLjaeoMdpJtNQE3iy5fD7CANIgL6Em0tGiA1zAK9jBJn
	eneD1QgJ2Ep8efiACcTmFLCTuH9uFdhmYQFviSVnzzOC2CwCqhLHlr8Gq+EFqj/esxPKFpT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zBCHqks8+qsLEhYRMJK492MWO0SJiMS+F+8YQe6RELjF
	LjHr33w2iF0CEt8mH2KB6JWV2HSAGRIQkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqm
	FiQXFCelFxnpFSfmFpfmpesl5+duYoREat8OxpsHrA8xJgOtn8gsJZqcD4z0vJJ4Q2NjEzMT
	UxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgLMu6KrE06c1pq45p
	bAG3urRb3Zx/7rJ5GPm0L0H2bqPywiXi3hXK/v0St5Wm6ud8UpJdza/Kd+HM/cJJU34k6P94
	HyeQteT0dJ+nU18XHHrCGz/F7Outm+9442LNuFhPCP9X3fzt7LHZWyfu9z4trRZ7We7i+lfl
	cyctLdOU4tSb721nc9HqgxJLcUaioRZzUXEiAP0fDCnqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3OUJNAg5ddhhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpx82cNW0MRR8aXzIlsD40+2LkYODgkBE4nu
	s5FdjJxAppjEhXvrgcJcHEIC0xklFk0/D+X8YpS42nqDHaSKTUBN4suXw+wgzSIC+hJtLRog
	NcwCvYwSZ3p3g9UICdhKfHn4gAnE5hSwk7h/bhUriC0s4C2x5Ox5RhCbRUBV4tjy12A1vED1
	x3t2QtmCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4mh1iUd/dUHCIgJGEvd+zGKHKBGR2Pfi
	HeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnAaeSe9g
	XNVgcYhRgINRiYdX4JNxoBBrYllxZe4hRgkOZiUR3jIJk0Ah3pTEyqrUovz4otKc1OJDjMlA
	j05klhJNzgemqLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnV
	wGgQWnVGttItcZ5OzXvxvmmNLgbNbAvTXrawWP9T+KOj8WxZuoCW7Yf6FfXs5vaB3l6Gd09m
	+XMwzvU2ujh1vWHO9oOZiyzZvvvtlRGZeej9pM0h6VOr1/VcZ6+cO/VWTtOUNMPc1C3GNUxt
	PraP/35X91pcMnsJ1ymWRUr6Hyb5BDZ3pcSXK7EUZyQaajEXFScCAIKFWu9HAwAA
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
 drivers/rtc/rtc-msm6242.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index fcb113c..3ac1e8e 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -252,18 +252,7 @@ static struct platform_driver msm6242_rtc_driver = {
 	.remove	= __exit_p(msm6242_rtc_remove),
 };
 
-static int __init msm6242_rtc_init(void)
-{
-	return platform_driver_probe(&msm6242_rtc_driver, msm6242_rtc_probe);
-}
-
-static void __exit msm6242_rtc_fini(void)
-{
-	platform_driver_unregister(&msm6242_rtc_driver);
-}
-
-module_init(msm6242_rtc_init);
-module_exit(msm6242_rtc_fini);
+module_platform_driver_probe(msm6242_rtc_driver, msm6242_rtc_probe);
 
 MODULE_AUTHOR("Geert Uytterhoeven <geert@linux-m68k.org>");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


