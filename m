Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3KYCjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 21:39:11 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43422 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3KYCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 21:39:08 -0500
Message-ID: <5292B8D1.5050407@gmail.com>
Date: Mon, 25 Nov 2013 10:41:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] arch: hexagon: include: asm: use 'affinity' instead of
 'locdis' for __vmintop_affinity() in "hexagon_vm.h"
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com>
In-Reply-To: <5292B8A0.7020409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All __vmintop_*() use  __vmintop(*, ...), so __vmintop_affinity() need
use __vmintop(vm_affinity, ...).


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/include/asm/hexagon_vm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/hexagon/include/asm/hexagon_vm.h b/arch/hexagon/include/asm/hexagon_vm.h
index e1e0470..3ea99c1 100644
--- a/arch/hexagon/include/asm/hexagon_vm.h
+++ b/arch/hexagon/include/asm/hexagon_vm.h
@@ -161,7 +161,7 @@ static inline long __vmintop_locdis(long i)
 
 static inline long __vmintop_affinity(long i, long cpu)
 {
-	return __vmintop(locdis, i, cpu, 0, 0);
+	return __vmintop(vm_affinity, i, cpu, 0, 0);
 }
 
 static inline long __vmintop_get(void)
-- 
1.7.7.6
