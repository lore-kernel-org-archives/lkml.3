Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3JGKsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:48:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46751 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3JGKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:48:17 -0400
X-Spam-Score: -100.8
Message-ID: <52529133.4040200@asianux.com>
Date: Mon, 07 Oct 2013 18:47:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel/irq/proc.c: set MAX_NAMELEN 11 instead of 10 and
 use "%u" instead of "%d" for printing 'irq'
References: <52502E14.5040507@asianux.com> <1380987671.2081.122.camel@joe-AO722> <52503441.2030009@asianux.com> <CAFLxGvy0+9tu5PF2kKrUyVRobixtLaSs_u_b9zwFj64YvQrxgw@mail.gmail.com> <52504373.8070606@asianux.com> <52504718.30303@asianux.com> <52505048.8000604@nod.at> <5250B0E3.3070500@asianux.com> <52518850.6050303@asianux.com>
In-Reply-To: <52518850.6050303@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theoretically, the maximize size of "%u" is 11 (10 + '\0'), so need set
MAX_NAMELEN 11 instead of 10, and also 'irq' is unsigned int, so need
use "%u" instead of "%d".

In real world, it may not cause issue, but still recommend to fix the
'theoretical' bugs (especially original definition already considered
about 'theoretical' using).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/irq/proc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 36f6ee1..efda701 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -305,7 +305,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #undef MAX_NAMELEN
 
-#define MAX_NAMELEN 10
+#define MAX_NAMELEN 11
 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
@@ -315,7 +315,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 		return;
 
 	memset(name, 0, MAX_NAMELEN);
-	sprintf(name, "%d", irq);
+	sprintf(name, "%u", irq);
 
 	/* create /proc/irq/1234 */
 	desc->dir = proc_mkdir(name, root_irq_dir);
-- 
1.7.7.6
