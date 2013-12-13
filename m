Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3LMWez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:34:55 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35557 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3LMW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:53 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 067/115] gpu: ion: Remove __GFP_NO_KSWAPD
Date: Fri, 13 Dec 2013 14:24:41 -0800
Message-Id: <1386973529-4884-68-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

It no longer exists.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index d4f0a56..344f753 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -27,8 +27,8 @@
 #include "ion_priv.h"
 
 static unsigned int high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO |
-					    __GFP_NOWARN | __GFP_NORETRY |
-					    __GFP_NO_KSWAPD) & ~__GFP_WAIT;
+					    __GFP_NOWARN | __GFP_NORETRY) &
+					   ~__GFP_WAIT;
 static unsigned int low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO |
 					 __GFP_NOWARN);
 static const unsigned int orders[] = {8, 4, 0};
-- 
1.8.3.2

