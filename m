Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815Ab3E2LFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:05:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47604 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:05:01 -0400
X-Spam-Score: -100.8
Message-ID: <51A5E0A9.70605@asianux.com>
Date: Wed, 29 May 2013 19:04:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, josh@joshtriplett.org,
        srivatsa.bhat@linux.vnet.ibm.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: alpha: kernel: typo issue, using '1' instead of '11'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For sending message:

        *(unsigned int *)&cpu->ipc_buffer[0] = len;
        cp1 = (char *) &cpu->ipc_buffer[1];

But for receive message:

                cnt = cpu->ipc_buffer[0] >> 32;
                ...
                       cp1 = (char *) &cpu->ipc_buffer[11];

They are not pairs, it is typo issue of the redundency '1'.

So need use '1' instead of '11'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/alpha/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 7b60834..8beb6b2 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -264,7 +264,7 @@ recv_secondary_console_msg(void)
 		if (cnt <= 0 || cnt >= 80)
 			strcpy(buf, "<<< BOGUS MSG >>>");
 		else {
-			cp1 = (char *) &cpu->ipc_buffer[11];
+			cp1 = (char *) &cpu->ipc_buffer[1];
 			cp2 = buf;
 			strcpy(cp2, cp1);
 			
-- 
1.7.7.6
