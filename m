Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaJQIBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:01:14 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:50948 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaJQIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:01:13 -0400
Message-ID: <5440CC6D.4050405@synopsys.com>
Date: Fri, 17 Oct 2014 13:29:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc() declaration
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com> <20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com> <CAErSpo4j060imN0SOZM0LUc0hymDZMg4b3PcMhCChsubWfcNGA@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230753C5E7669@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C5E7669@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2014 07:08 PM, Vineet Gupta wrote:
> On Thursday 16 October 2014 05:05 AM, Bjorn Helgaas wrote:
>> > [+cc Harvey, Vineet, linux-sh; arc, sh, and x86 have kgdb_arch_pc()
>> > definitions and could see issues from this]
> Thanks for the heads up !
> 
> I compile tested arc tree (with kgdb) from linux-next of today, which has this
> patch already and things seem to be ok.
> 
> As a hack I reverted the patch and see that kgdb_arch_pc() becomes weak, although
> ARC version was still being pulled in final - it was recored as weak and that
> cause bloat-o-meter to go awry.
> 
> bloat-o-meter vmlinux-with-fix vmlinux-before-fix
> add/remove: 0/1 grow/shrink: 1/0 up/down: 1/-8 (-7)
> function                                     old     new   delta
> vermagic                                      36      37      +1
> kgdb_arch_pc                                 8       -      -8

The ARC definition of kgdb_arch_pc is same as generic one so we might as well drop it.
Can you add the patch below to your series. If not I can add it to ARC changes for
this merge window. Please let me know.

Thx,
-Vineet

---------------------->
>From f01b1db6986924e794eddc038167329d63d1fda9 Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Fri, 17 Oct 2014 13:27:03 +0530
Subject: [PATCH] ARC: kgdb: generic kgdb_arch_pc() suffices

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/kgdb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arc/kernel/kgdb.c b/arch/arc/kernel/kgdb.c
index a2ff5c5d1450..ecf6a7869375 100644
--- a/arch/arc/kernel/kgdb.c
+++ b/arch/arc/kernel/kgdb.c
@@ -158,11 +158,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int
err_code,
 	return -1;
 }

-unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
-{
-	return instruction_pointer(regs);
-}
-
 int kgdb_arch_init(void)
 {
 	single_step_data.armed = 0;
-- 
1.8.3.2
