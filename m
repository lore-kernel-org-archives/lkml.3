Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbbAUPHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:07:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37919 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbbAUPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:07:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-17-54bfc0013bf9
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com (open list:REAL TIME CLOCK (...))
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] rtc: s5m: terminate s5m_rtc_id array with empty element
Date: Wed, 21 Jan 2015 18:06:49 +0300
Message-id: <1421852809-29733-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xy7qMB/aHGNz5Lmex7dcjNoslF6+y
	W1zeNYfNYn9nB6MDi8eeiSfZPPq2rGL0mD7vJ5PH501yASxRXDYpqTmZZalF+nYJXBmTrt9n
	KuhjrVh39Q97A+NCli5GTg4JAROJljUTmCBsMYkL99azgdhCAksZJfZ+zYKw+5gkVr8vArHZ
	BPQk/s3aDlTDxSEi0Mko8WP/a0aQBLOAjsTGa61gg4QFPCTWfTjN3MXIwcEioCrxcm0qiMkr
	4CbxudENYpWcxMY7K1gnMHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRHi+a87GJce
	szrEKMDBqMTDK+GzP0SINbGsuDL3EKMEB7OSCK/1FqAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xgaOd74zv/pknJoVsf94lTJjb/UdTf3D8yJ2H2vKEOgX3rPwzoaSA37nzj/487/zQtKEicer
	Whd+Wz63es9Z28V1agERGVOjFi/rKYjLfvp3c2Op4lSGlf6HvhxctE993ROrpzNrv0zYH+ns
	ckDe2l6hZJHIVvX+WYfs7l/vS4j0iVrwoeHbVBYlluKMREMt5qLiRAAApvIr2gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of platform_device_id elements should be terminated
with empty element.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/rtc/rtc-s5m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b5e7c46..89ac1d5 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -832,6 +832,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc",		S5M8767X },
 	{ "s2mps14-rtc",	S2MPS14X },
+	{ },
 };
 
 static struct platform_driver s5m_rtc_driver = {
-- 
2.2.1

