Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaJTQVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:21:03 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36796 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaJTQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <5440CC6D.4050405@synopsys.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo4j060imN0SOZM0LUc0hymDZMg4b3PcMhCChsubWfcNGA@mail.gmail.com>
 <C2D7FE5348E1B147BCA15975FBA230753C5E7669@IN01WEMBXA.internal.synopsys.com> <5440CC6D.4050405@synopsys.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 Oct 2014 10:20:39 -0600
Message-ID: <CAErSpo5R=K=h_YWCyGMxGqPpWWbyk4MP0n2Wz+bXtwju6mXmLg@mail.gmail.com>
Subject: Re: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc() declaration
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 1:59 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On Thursday 16 October 2014 07:08 PM, Vineet Gupta wrote:
>> On Thursday 16 October 2014 05:05 AM, Bjorn Helgaas wrote:
>>> > [+cc Harvey, Vineet, linux-sh; arc, sh, and x86 have kgdb_arch_pc()
>>> > definitions and could see issues from this]
>> Thanks for the heads up !
>>
>> I compile tested arc tree (with kgdb) from linux-next of today, which has this
>> patch already and things seem to be ok.
>>
>> As a hack I reverted the patch and see that kgdb_arch_pc() becomes weak, although
>> ARC version was still being pulled in final - it was recored as weak and that
>> cause bloat-o-meter to go awry.
>>
>> bloat-o-meter vmlinux-with-fix vmlinux-before-fix
>> add/remove: 0/1 grow/shrink: 1/0 up/down: 1/-8 (-7)
>> function                                     old     new   delta
>> vermagic                                      36      37      +1
>> kgdb_arch_pc                                 8       -      -8
>
> The ARC definition of kgdb_arch_pc is same as generic one so we might as well drop it.
> Can you add the patch below to your series. If not I can add it to ARC changes for
> this merge window. Please let me know.

I added the patch below to my series.  The merge window just closed,
but I'll try to merge these as fixes before v3.18.  Thanks!

Bjorn

> ---------------------->
> From f01b1db6986924e794eddc038167329d63d1fda9 Mon Sep 17 00:00:00 2001
> From: Vineet Gupta <vgupta@synopsys.com>
> Date: Fri, 17 Oct 2014 13:27:03 +0530
> Subject: [PATCH] ARC: kgdb: generic kgdb_arch_pc() suffices
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/kernel/kgdb.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/arch/arc/kernel/kgdb.c b/arch/arc/kernel/kgdb.c
> index a2ff5c5d1450..ecf6a7869375 100644
> --- a/arch/arc/kernel/kgdb.c
> +++ b/arch/arc/kernel/kgdb.c
> @@ -158,11 +158,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int
> err_code,
>         return -1;
>  }
>
> -unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
> -{
> -       return instruction_pointer(regs);
> -}
> -
>  int kgdb_arch_init(void)
>  {
>         single_step_data.armed = 0;
> --
> 1.8.3.2
