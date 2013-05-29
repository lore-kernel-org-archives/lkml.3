Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496Ab3E2JoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:44:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35443 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205Ab3E2JoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:44:08 -0400
X-Spam-Score: -100.8
Message-ID: <51A5CDB4.9000204@asianux.com>
Date: Wed, 29 May 2013 17:43:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>, anton.vorontsov@linaro.org,
        Richard Kuo <rkuo@codeaurora.org>, jesper.nilsson@axis.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: blackfin: kernel: sprintf(), need avoid NUL for '%s'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When it is kernel symbol, the 'modname' will be NUL, and the 'symname'
contents the valid name.

So for sprintf(), need avoid NUL for '%s'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/blackfin/kernel/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index c36efa0..11f98bb 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -51,7 +51,7 @@ void decode_address(char *buf, unsigned long address)
 		if (!modname)
 			modname = delim = "";
 		sprintf(buf, "{ %s%s%s%s + 0x%lx }",
-			delim, modname, delim, symname,
+			delim, modname ? : "kernel", delim, symname,
 			(unsigned long)offset);
 		return;
 	}
-- 
1.7.7.6
