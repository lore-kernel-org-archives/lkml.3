Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbbAFJj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:39:59 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:57651 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbbAFJjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
References: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 6 Jan 2015 10:39:51 +0100
X-Google-Sender-Auth: zGOdlir64eRRRRsD8J0Xe7MKrdQ
Message-ID: <CAMuHMdXXw_GiaDrtwmBSExwyYQe2t2io5j3V0fCawAc64-tXrA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Pratik Patel <pratikp@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 10:36 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.19-rc3[1] to v3.19-rc2[3], the summaries are:
>   - build errors: +64/-9

  + /home/kisskb/slave/src/arch/arm/mm/dma-mapping.c: error:
'VM_ARM_DMA_CONSISTENT' undeclared (first use in this function):  =>
1200:4, 1281:29, 1410:4
  + /home/kisskb/slave/src/arch/arm/mm/dma-mapping.c: error:
'atomic_pool' undeclared (first use in this function):  => 1264:31
  + /home/kisskb/slave/src/arch/arm/mm/dma-mapping.c: error: implicit
declaration of function '__in_atomic_pool'
[-Werror=implicit-function-declaration]:  => 1274:2
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_BUFFERABLE' undeclared here (not in a function):  => 81:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_DEV_CACHED' undeclared here (not in a function):  => 117:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_DEV_NONSHARED' undeclared here (not in a function):  =>
108:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_DEV_SHARED' undeclared here (not in a function):  => 103:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_DEV_WC' undeclared here (not in a function):  => 113:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'L_PTE_MT_MASK'
undeclared here (not in a function):  => 76:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_MINICACHE' undeclared here (not in a function):  => 94:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_UNCACHED' undeclared here (not in a function):  => 77:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_WRITEALLOC' undeclared here (not in a function):  => 99:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_WRITEBACK' undeclared here (not in a function):  => 89:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'L_PTE_MT_WRITETHROUGH' undeclared here (not in a function):  => 85:10
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'L_PTE_RDONLY'
undeclared here (not in a function):  => 61:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'L_PTE_SHARED'
undeclared here (not in a function):  => 71:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'L_PTE_USER'
undeclared here (not in a function):  => 56:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'L_PTE_XN'
undeclared here (not in a function):  => 66:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'PMD_SECT_AP_READ' undeclared here (not in a function):  => 153:13
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'PMD_SECT_AP_WRITE' undeclared here (not in a function):  => 153:32
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PMD_SECT_S'
undeclared here (not in a function):  => 175:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PMD_SECT_XN'
undeclared here (not in a function):  => 170:11
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PMD_SIZE'
undeclared (first use in this function):  => 279:22
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PTRS_PER_PGD'
undeclared (first use in this function):  => 319:23
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PTRS_PER_PMD'
undeclared (first use in this function):  => 278:18
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'PTRS_PER_PTE'
undeclared (first use in this function):  => 266:18
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: 'SECTION_SIZE'
undeclared (first use in this function):  => 285:7
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
'USER_PGTABLES_CEILING' undeclared (first use in this function):  =>
223:13, 311:23
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[0].mask'):  => 153:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[1].mask'):  => 157:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[1].val'):  => 158:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[2].mask'):  => 161:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[2].val'):  => 162:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[3].mask'):  => 165:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[3].val'):  => 166:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[4].mask'):  => 170:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[4].val'):  => 171:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[5].mask'):  => 175:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: (near
initialization for 'section_bits[5].val'):  => 176:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: implicit
declaration of function 'pmd_large'
[-Werror=implicit-function-declaration]:  => 280:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: implicit
declaration of function 'pmd_none'
[-Werror=implicit-function-declaration]:  => 280:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: implicit
declaration of function 'pmd_present'
[-Werror=implicit-function-declaration]:  => 280:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: implicit
declaration of function 'pte_offset_kernel'
[-Werror=implicit-function-declaration]:  => 262:2
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: initializer
element is not constant:  => 158:3, 162:3, 176:3, 170:3, 157:3, 175:3,
161:3, 153:3, 171:3, 165:3, 166:3
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: invalid operands
to binary * (have 'unsigned int' and 'const struct prot_bits *'):  =>
279:20
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: invalid operands
to binary / (have 'const struct prot_bits *' and 'long unsigned int'):
 => 311:45
  + /home/kisskb/slave/src/arch/arm/mm/dump.c: error: invalid operands
to binary | (have 'const struct prot_bits *' and 'const struct
prot_bits *'):  => 165:30, 153:30, 166:30, 157:30, 161:30
  + /home/kisskb/slave/src/arch/arm/mm/init.c: error: 'SECTION_SIZE'
undeclared (first use in this function):  => 733:2
  + /home/kisskb/slave/src/arch/arm/mm/init.c: error: 'pmdval_t'
undeclared here (not in a function):  => 633:12
  + /home/kisskb/slave/src/arch/arm/mm/init.c: error: expected
declaration specifiers or '...' before 'pmdval_t':  => 678:7, 677:55
  + /home/kisskb/slave/src/arch/arm/mm/init.c: error: implicit
declaration of function 'section_update'
[-Werror=implicit-function-declaration]:  => 733:2
  + /home/kisskb/slave/src/arch/arm/mm/init.c: error: unknown type
name 'pmdval_t':  => 625:2, 623:2, 624:2

arm-randconfig (CONFIG_ARM_PTDUMP is broken?)

  + /home/kisskb/slave/src/drivers/coresight/coresight-etb10.c: error:
implicit declaration of function 'of_get_coresight_platform_data'
[-Werror=implicit-function-declaration]:  => 430:3
  + /home/kisskb/slave/src/drivers/coresight/coresight-funnel.c:
error: implicit declaration of function
'of_get_coresight_platform_data'
[-Werror=implicit-function-declaration]:  => 189:3
  + /home/kisskb/slave/src/drivers/coresight/coresight-replicator.c:
error: implicit declaration of function
'of_get_coresight_platform_data'
[-Werror=implicit-function-declaration]:  => 72:3
  + /home/kisskb/slave/src/drivers/coresight/coresight-tmc.c: error:
implicit declaration of function 'of_get_coresight_platform_data'
[-Werror=implicit-function-declaration]:  => 625:3
  + /home/kisskb/slave/src/drivers/coresight/coresight-tpiu.c: error:
implicit declaration of function 'of_get_coresight_platform_data'
[-Werror=implicit-function-declaration]:  => 131:3

arm-randconfig

  + /home/kisskb/slave/src/arch/sh/mm/cache-sh4.c: error:
'cached_to_uncached' undeclared (first use in this function):  =>
99:17
  + /home/kisskb/slave/src/arch/sh/mm/cache-sh4.c: error: implicit
declaration of function 'cpu_context'
[-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + /home/kisskb/slave/src/kernel/bounds.c: error: -mcall-aixdesc must
be big endian:  => 1:0
  + /home/kisskb/slave/src/scripts/mod/devicetable-offsets.c: error:
-mcall-aixdesc must be big endian:  => 1:0
  + /home/kisskb/slave/src/scripts/mod/empty.c: error: -mcall-aixdesc
must be big endian:  => 1:0
  + <stdin>: error: -mcall-aixdesc must be big endian:  => 1:0

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8277/ (255 out of 262 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8257/ (all 262 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
