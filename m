Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbaJaIBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:01:20 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:10457 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbaJaIBT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:01:19 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 16:01:13 +0800
Subject: [RFC V2] arm:remove clear_thread_flag(TIF_UPROBE)
Thread-Topic: [RFC V2] arm:remove clear_thread_flag(TIF_UPROBE)
Thread-Index: Ac/03rMWWFkGX/cdRK6lX5CjAvaTsAAALaegAABTt7A=
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1827F@CNBJMBX05.corpusers.net>
References: <1414392371.8884.2.camel@perches.com>
	 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
	 <20141030120127.GC32589@arm.com>
	 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
	 <20141030135749.GE32589@arm.com>
	 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D1827B@CNBJMBX05.corpusers.net>
 <1414741535.8928.2.camel@perches.com>
 <35FD53F367049845BC99AC72306C23D103E010D1827C@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D1827C@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove clear_thread_flag(TIF_UPROBE) in do_work_pending(),
because uprobe_notify_resume() have do this.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/kernel/signal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index bd19834..8aa6f1b 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -592,7 +592,6 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 				}
 				syscall = 0;
 			} else if (thread_flags & _TIF_UPROBE) {
-				clear_thread_flag(TIF_UPROBE);
 				uprobe_notify_resume(regs);
 			} else {
 				clear_thread_flag(TIF_NOTIFY_RESUME);
-- 
2.1.1
