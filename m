Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3E0Frg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 01:47:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46326 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3E0Frd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 01:47:33 -0400
X-Spam-Score: -100.8
Message-ID: <51A2F342.8060907@asianux.com>
Date: Mon, 27 May 2013 13:46:42 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>, jesper.nilsson@axis.com,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: frv: kernel: using vsnprintf() instead of vsprintf()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since die_if_kernel() is an extern common used function, better always
check the buffer length to avoid memory overflow by a long 'str'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/frv/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 4bff48c..a6d105d 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -523,7 +523,7 @@ void die_if_kernel(const char *str, ...)
 		return;
 
 	va_start(va, str);
-	vsprintf(buffer, str, va);
+	vsnprintf(buffer, sizeof(buffer), str, va);
 	va_end(va);
 
 	console_verbose();
-- 
1.7.7.6
