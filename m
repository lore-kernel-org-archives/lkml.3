Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3BFLW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:22:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3BFLWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:22:53 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-bc-51123d0c7a2c
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] rtc: core: Prevent repeated calling of alarm_irq_enable().
Date: Wed, 06 Feb 2013 20:22:45 +0900
Message-id: <1360149765-19565-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t8zbV0eW6FAgyWLpCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGj01TGAv2sFVMvveHsYFxBWsXIyeHhICJxILmqywQtpjEhXvr
	2UBsIYFljBIrtrB3MXKA1Xw/rt/FyAUUXsQocXTffxYIZymTxKfGj2ANbAI6Ev/33WQHsUUE
	FCQ29z4DW8As0Mko0TSlBmSQsIC3xL572SBhFgFVievf/4OV8wp4SJxpnsIIsUtBYs4kG4hz
	9rBJrG6UhSgXkPg2+RALRImsxKYDzBAlkhIHV9xgmcAouICRYRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGSChJ7WBc2WBxiFGAg1GJh/eGnmCgEGtiWXFl7iFGCQ5mJRHeWAWhQCHelMTK
	qtSi/Pii0pzU4kOMyUDLJzJLiSbnA8M8ryTe0NjA2NDQ0tDM1NLUgDRhJXFexlNPAoQE0hNL
	UrNTUwtSi2C2MHFwSjUwbr3b0mC26VnNXdZNH13OR7z2KAyaVlv6q3hbWsKVLVfTLlr2/FDX
	aO+9qXOjdvqxFSxe3z6VRanx/n+wRmlLe2pLrexkrVeFTbNNfTXDuQxtAxcxPH14fi7Px2lL
	Iix2uUQvnP95+qEb0fNYJzGsMH5fKxT0InZFi5djMpNJ3Zp6k4KDL6PPKbEUZyQaajEXFScC
	ADo4nnRpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xgC6PrVCgwes+IYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WPTFMaCPWwVk+/9YWxg
	XMHaxcjBISFgIvH9uH4XIyeQKSZx4d56ti5GLg4hgUWMEkf3/WeBcJYySXxq/MgGUsUmoCPx
	f99NdhBbREBBYnPvM1YQm1mgk1GiaUoNyFBhAW+JffeyQcIsAqoS17//ByvnFfCQONM8hRFi
	r4LEnEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtZnUjsYVzZYHGIU4GBU
	4uG9oScYKMSaWFZcmXuIUYKDWUmEN1ZBKFCINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cBI
	yiuJNzQ2MTOyNDIzNjE3NiZNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjHtWLGKY3Txf
	4/Hesw8NTV8cyvJZtHDWgV++oo5bT4ve92aKOL24zdGi1KA0eNME/qwdcdrsFsvb66K+zHqV
	737CSmvR30sncnMabr1YNedITcR8s++2F/9xKCyaZy/Xn7D7qd7y0NWnCrgnPLy9voxPKmNT
	ewDrHmdl57nZJ2aUaW75uXpiRZYSS3FGoqEWc1FxIgDQ9P50mgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes repeated execution of disabling alarm in
rtc_alarm_irq_enable() of rtc core interface. It made useless
call even all alarm had been disabled from rtc_timer_remove().
We'd better to skip disabling alarm when timer queue is empty.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/rtc/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 9592b93..11cfb76 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -428,7 +428,7 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 			rtc_timer_remove(rtc, &rtc->aie_timer);
 	}
 
-	if (err)
+	if (err || !rtc->timerqueue.next)
 		/* nothing */;
 	else if (!rtc->ops)
 		err = -ENODEV;
-- 
1.7.9.5

