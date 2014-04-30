Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbaD3J3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:29:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19826 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbaD3J2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:28:54 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-c2-5360c255b1c7
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: [PATCH 5/5 v3] iio: exynos_adc: do a reinit_completion before the
 conversion
Date: Wed, 30 Apr 2014 14:56:55 +0530
Message-id: <1398850015-17761-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSpRt6KCHY4OBMbYuXhzQtzi47yGbR
	vHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MFutnvGZx4PKY3XCRxWPnrLvs
	HvvnrmH3WPLmEKtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZWx++ZS14CdbxbmFzcwNjC9Z
	uxg5OSQETCQ2rZrBBmGLSVy4tx7MFhJYyijx420aTM2Ztk3MXYxcQPHpjBKb/35mgijqZ5Lo
	PRIFYrMJmEkcXLSavYuRg0NEQFZiZrceSD2zwBOgOVteM4PEhQXCJVYsTAIpZxFQldi84CML
	iM0r4Cqx4f0ZRpASCQEFiTmTbEDCnAJuEs1HF7JAbHKVaDp7mAlkpITAIXaJO+1b2CDmCEh8
	m3yIBaJXVmLTAWaIkyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMA4
	OP3vWd8OxpsHrA8xJgONm8gsJZqcD4yjvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXAGMWjstxZguOLzWv2ItMAlbJ5snNT/R9fedv8QrdKeMXH
	By7qXN6FNx7tDXt/daKoqaH7WfnNR6sf/5BVq1A9t5fvb3D6JH7x0yG23vsuL1RX1vP52tJd
	dJRdateWBOF7/3fvWvveNFe/lcvwo2GNQRHLjir/e58+zby+q+bsw0f7H3z8KuSprMRSnJFo
	qMVcVJwIAEaFX2WZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd3QQwnBBqeeK1m8PKRpcXbZQTaL
	5sXr2SxeHfnBZLFk8nxWi3lH3rFYXN41h81ixvl9TBaLtv1ntlg/4zWLA5fH7IaLLB47Z91l
	99g/dw27x5I3h1g9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPG5pdPWQt+slWcW9jM3MD4krWLkZNDQsBE4kzbJmYIW0ziwr31bF2MXBxCAtMZJTb/
	/cwEkhAS6GeS6D0SBWKzCZhJHFy0mr2LkYNDREBWYma3Hkg9s8ATRokfW14zg8SFBcIlVixM
	AilnEVCV2LzgIwuIzSvgKrHh/RlGkBIJAQWJOZNsQMKcAm4SzUcXskBscpVoOnuYaQIj7wJG
	hlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwXH2THoH46oGi0OMAhyMSjy8Alvjg4VYE8uK
	K3MPMUpwMCuJ8GZ0JAQL8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4wBeSVxBsam5ibGpta
	mliYmFmSJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2P0xY6vLO0/5xbO2Dx5I2fFjL/F
	P1X3zn/K+eUOk+g9Zoa0FW86vtTIHX3/eHWx0IydqZKGLGeWcSUFRwue+27kON3v0tPJwW8E
	zsp7n2647FoS+1zd/mr5OqWp05YlPXWVquz9o7FNWJTNecUxI6upbXpZP7O//WrY3dUr6pI+
	o//6t0Nb05YosRRnJBpqMRcVJwIAkLfHk/cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reinit_completion() before the wait_for_completion_timeout in
raw_read() call.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v2:
None
Changes since v1:
None
v0:
This change is a part of the patch reviewed at https://lkml.org/lkml/2013/11/5/92

 drivers/iio/adc/exynos_adc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index eddc58e..010578f 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -151,6 +151,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 		return -EINVAL;
 
 	mutex_lock(&indio_dev->mlock);
+	reinit_completion(&info->completion);
 
 	/* Select the channel to be used and Trigger conversion */
 	if (info->version == ADC_V2) {
-- 
1.7.9.5

