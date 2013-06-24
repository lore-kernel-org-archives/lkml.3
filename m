Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3FXI7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:59:41 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:32797 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FXI7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:59:39 -0400
Date: Mon, 24 Jun 2013 10:59:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.10-rc7
In-Reply-To: <alpine.DEB.2.00.1306241054001.10792@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1306241057120.10868@ayla.of.borg>
References: <alpine.DEB.2.00.1306241054001.10792@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.10-rc7 to v3.10-rc6[3], the summaries are:
>   - build errors: +51/-11

After filtering out false-positives (v3.10-rc6 had only 72% build coverage):

  + arch/powerpc/kernel/fadump.c: error: 'KEXEC_CORE_NOTE_NAME' undeclared (first use in this function):  => 521:36
  + arch/powerpc/kernel/fadump.c: error: 'crashing_cpu' undeclared (first use in this function):  => 408:2
  + arch/powerpc/kernel/fadump.c: error: 'note_buf_t' undeclared (first use in this function):  => 624:49
  + arch/powerpc/kernel/fadump.c: error: 'vmcoreinfo_max_size' undeclared (first use in this function):  => 874:18
  + arch/powerpc/kernel/fadump.c: error: implicit declaration of function 'crash_save_vmcoreinfo' [-Werror=implicit-function-declaration]:  => 410:2
  + arch/powerpc/kernel/fadump.c: error: implicit declaration of function 'elf_core_copy_kernel_regs' [-Werror=implicit-function-declaration]:  => 520:2
  + arch/powerpc/kernel/fadump.c: error: implicit declaration of function 'paddr_vmcoreinfo_note' [-Werror=implicit-function-declaration]:  => 872:2
  + arch/powerpc/kernel/fadump.c: error: storage size of 'prstatus' isn't known:  => 513:22
  + arch/powerpc/kernel/fadump.c: error: unused variable 'prstatus' [-Werror=unused-variable]:  => 513:22
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ANDCOND' undeclared (first use in this function):  => 161:17, 86:16
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_AVPN' undeclared (first use in this function):  => 160:17, 85:16, 192:16
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_BULK_REMOVE' undeclared (first use in this function):  => 246:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CEDE' undeclared (first use in this function):  => 250:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CPPR' undeclared (first use in this function):  => 257:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ENTER' undeclared (first use in this function):  => 240:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EOI' undeclared (first use in this function):  => 258:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EXACT' undeclared (first use in this function):  => 50:6
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPI' undeclared (first use in this function):  => 259:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPOLL' undeclared (first use in this function):  => 260:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_NOT_FOUND' undeclared (first use in this function):  => 193:27, 87:27
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PARAMETER' undeclared (first use in this function):  => 138:10
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PROTECT' undeclared (first use in this function):  => 244:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PTEG_FULL' undeclared (first use in this function):  => 54:12
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PUT_TCE' undeclared (first use in this function):  => 248:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_REMOVE' undeclared (first use in this function):  => 242:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_RTAS' undeclared (first use in this function):  => 265:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_SUCCESS' undeclared (first use in this function):  => 67:26, 96:26, 211:26, 125:12
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_TOO_HARD' undeclared (first use in this function):  => 224:12
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR' undeclared (first use in this function):  => 256:7
  + arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR_X' undeclared (first use in this function):  => 261:7

All from the powerpc-randconfig police.

> [1] http://kisskb.ellerman.id.au/kisskb/head/6349/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6325/ (86 out of 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
