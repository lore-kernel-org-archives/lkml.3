Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3G3Ivp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:51:45 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57747 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3G3Ivl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:51:41 -0400
Date: Tue, 30 Jul 2013 10:51:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        linux-usb@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.11-rc3
In-Reply-To: <alpine.DEB.2.02.1307301048280.23035@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1307301049230.23054@ayla.of.borg>
References: <alpine.DEB.2.02.1307301048280.23035@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.11-rc3 to v3.11-rc2[3], the summaries are:
>   - build errors: +38/-14

  + arch/powerpc/kvm/book3s_emulate.c: error: 'bat' may be used uninitialized in this function [-Werror=uninitialized]:  => 349:2
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
  + arch/powerpc/platforms/pseries/hotplug-memory.c: error: 'SECTION_SIZE_BITS' undeclared (first use in this function):  => 24:31
  + mm/memory_hotplug.c: error: 'PAGES_PER_SECTION' undeclared (first use in this function):  => 1630:46
  + mm/memory_hotplug.c: error: implicit declaration of function '__nr_to_section' [-Werror=implicit-function-declaration]:  => 1635:3
  + mm/memory_hotplug.c: error: implicit declaration of function 'find_memory_block_hinted' [-Werror=implicit-function-declaration]:  => 1642:3
  + mm/memory_hotplug.c: error: implicit declaration of function 'pfn_to_section_nr' [-Werror=implicit-function-declaration]:  => 1631:3
  + mm/memory_hotplug.c: error: implicit declaration of function 'present_section_nr' [-Werror=implicit-function-declaration]:  => 1632:3

powerpc-randconfig

  + drivers/md/dm-cache-policy-mq.c: error: conflicting types for 'remove_mapping':  => 962:13

sparc-allmodconfig, not a regression (was hidden due to a sparc64/sparc32
mixup on kissb), patch submitted

  + error: "usb_add_gadget_udc" [drivers/usb/chipidea/ci_hdrc.ko] undefined!:  => N/A
  + error: "usb_del_gadget_udc" [drivers/usb/chipidea/ci_hdrc.ko] undefined!:  => N/A
  + error: "usb_gadget_map_request" [drivers/usb/chipidea/ci_hdrc.ko] undefined!:  => N/A
  + error: "usb_gadget_unmap_request" [drivers/usb/chipidea/ci_hdrc.ko] undefined!:  => N/A

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6490/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6461/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
