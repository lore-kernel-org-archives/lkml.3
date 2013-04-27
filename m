Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3D0Cyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:54:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65239 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3D0Cyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:54:52 -0400
X-AuditID: cbfee68d-b7f016d000007930-b9-517b3dfa6fbb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] PM: Add pm_ops_ptr() macro
Date: Sat, 27 Apr 2013 11:54:50 +0900
Message-id: <000001ce42f2$96128cc0$c237a640$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5C8o6cbQXPVHyVQgC21Tqr9UQ2BA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zfd1fttWBBs0nbCzmrF/DZvHykKbF
	5YWXWC1mTdnLZHF51xw2i8+9Rxgt7p46ymbRv7CXyYHDY/Gel0weJ2b8ZvHo27KK0ePR4hZG
	jxWrv7N7fN4kF8AWxWWTkpqTWZZapG+XwJWx/5BywUXWivXPMhsYj7N0MXJySAiYSLz/8oER
	whaTuHBvPVsXIxeHkMAyRoktX78ywRSd6XsPlVjEKLHr7ltGCOcXo8TBx4fAqtgE1CS+fDnM
	3sXIwSEioC/R1qIBUsMscJxRYumF9ywgcWEBbYl1H6NAylkEVCW2d81iA7F5BSwlWj98hLIF
	JX5Mvgd2HbOAlsT6nceZIGx5ic1r3jJDHKQgsePsa7CrRQT0JGb+3McOUSMise/FO7DbJARu
	sUss3rWFDWKZgMS3yYfAbpAQkJXYdABqjqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyi
	qQXJBcVJ6UWGesWJucWleel6yfm5mxgh0dm7g/H2AetDjMlA6ycyS4km5wOjO68k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPcv2D/Y9W0K++/X
	l8/ODIwKNfnbffNqRQvrUlMemeQjZSL+Kcv4Ns23fWsl/G1PH9fL+XwK7mfei85+tqthiRBf
	5/J7Wqw3m8VPFzDze/GzMftrXOtb+UfDuKDnVk9jwr5ZnlZfnVZ8jVH+GSts7huUvu4QtzZ/
	wbUr/TteJe0z+XWh3PXwByWW4oxEQy3mouJEAACaW9zkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAd1fttWBBocbLCzmrF/DZvHykKbF
	5YWXWC1mTdnLZHF51xw2i8+9Rxgt7p46ymbRv7CXyYHDY/Gel0weJ2b8ZvHo27KK0ePR4hZG
	jxWrv7N7fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/8h5YKL
	rBXrn2U2MB5n6WLk5JAQMJE40/eeDcIWk7hwbz2QzcUhJLCIUWLX3beMEM4vRomDjw8xgVSx
	CahJfPlymL2LkYNDREBfoq1FA6SGWeA4o8TSC+9ZQOLCAtoS6z5GgZSzCKhKbO+aBbaAV8BS
	ovXDRyhbUOLH5HtgRzALaEms33mcCcKWl9i85i0zxEEKEjvOvmYEsUUE9CRm/tzHDlEjIrHv
	xTvGCYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzj2n0nv
	YFzVYHGIUYCDUYmHV2NRVaAQa2JZcWXuIUYJDmYlEV6FZ0Ah3pTEyqrUovz4otKc1OJDjMlA
	n05klhJNzgempbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRq
	YGzOau/vyW3zv+78YYPC34REX/mQKctE7jr/Tm6v2jtJhNPbOmdWlb4zf7jfhH3v9Jo+PvAW
	+fYnhFunp45PrGTOTBmdRo4r6st/ftA+dN+NbVv7bPcf7oIGKdeOhUz7ldqhfLLmX/gFoRiH
	FW/aNHZXLg5aXFdWwH5760au3+1tf22L68VClFiKMxINtZiLihMBH4/YQ0EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
to be assigned without having an #define xxx NULL for the case that PM is
not enabled.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/linux/pm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..bd50d15 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -55,8 +55,10 @@ struct device;
 
 #ifdef CONFIG_PM
 extern const char power_group_name[];		/* = "power" */
+#define pm_ops_ptr(_ptr)	(_ptr)
 #else
 #define power_group_name	NULL
+#define pm_ops_ptr(_ptr)	NULL
 #endif
 
 typedef struct pm_message {
-- 
1.7.2.5


