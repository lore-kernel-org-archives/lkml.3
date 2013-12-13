Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3LMW1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:30 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41896 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LMW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:27 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 050/115] gpu: ion: Fix bug where MAP ioctl was no longer supported
Date: Fri, 13 Dec 2013 14:24:24 -0800
Message-Id: <1386973529-4884-51-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3167c1d..3f22f88 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1086,6 +1086,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	case ION_IOC_SHARE:
+	case ION_IOC_MAP:
 	{
 		struct ion_fd_data data;
 
-- 
1.8.3.2

