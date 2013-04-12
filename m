Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3DLRvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:51:41 -0400
Received: from mout.gmx.net ([212.227.17.21]:51002 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab3DLRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:51:40 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/bG1Y1ERXbwxyNSYeIfowzppbQu6VtaS1VYqVcfN
	Lv//iP/NUGIM3/
Message-ID: <516849A9.1070206@gmx.de>
Date: Fri, 12 Apr 2013 19:51:37 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: build error with latest git kernel for a user mode linux build
References: <51681FAA.7030108@gmx.de> <CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com> <516843C4.5030104@gmx.de> <CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
In-Reply-To: <CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 07:41 PM, richard -rw- weinberger wrote:
> You .config build perfectly fine here.
> Have you tried a "make mrproper"?
ick - I forgot to un-apply your patch you sent to me related to the trinity-madvise UML problem - compiles fine now again

but this now seems not to work any longer :

$ cat devel/stub_pte_fix.diff 
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index b30f34a..db2d885 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
 generic-y += trace_clock.h
+header-y += mman.h
diff --git a/arch/um/include/asm/mman.h b/arch/um/include/asm/mman.h
new file mode 100644
index 0000000..d8fb362
--- /dev/null
+++ b/arch/um/include/asm/mman.h
@@ -0,0 +1,10 @@
+#ifndef __UM_MMAN_H__
...

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
