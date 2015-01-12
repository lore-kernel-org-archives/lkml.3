Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbbALRvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:51:55 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56044 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbALRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:51:53 -0500
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 17:51:52 +0000
Message-ID: <CAKv+Gu-svNbDNhHgFfiT0XPBhMNugWzPZiU4yUzkT9tf0OZ_bw@mail.gmail.com>
Subject: [GIT PULL] UEFI updates for arm64
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>,
        Mark Salter <msalter@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
        Geoff Levand <geoff.levand@linaro.org>, Dave Young <dyoung@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Catalin,

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  http://git.linaro.org/people/ard.biesheuvel/linux-arm.git tags/for-3.20

for you to fetch changes up to 9679be103108926cfe9e6fd2f6829cefa77e47b0:

  arm64/efi: remove idmap manipulations from UEFI code (2015-01-12
16:29:32 +0000)

Some patches touch files under drivers/firmware/efi, these have been
acked by Matt
Fleming, and he is aware that this series is being offered for merging
through the
arm64 tree

Regards,
Ard.


----------------------------------------------------------------
UEFI updates for arm64

This series consists of a reimplementation of the virtual remapping of
UEFI Runtime Services in a way that is stable across kexec, including
the required preparatory refactoring and other work to set the stage,
and some cleaning up afterwards to remove boot services memory and
identitity map handling that has now become redundant.

----------------------------------------------------------------
Ard Biesheuvel (8):
      arm64/mm: add explicit struct_mm argument to __create_mapping()
      arm64/mm: add create_pgd_mapping() to create private page tables
      efi: split off remapping code from efi_config_init()
      efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
      arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
      arm64/efi: move SetVirtualAddressMap() to UEFI stub
      arm64/efi: remove free_boot_services() and friends
      arm64/efi: remove idmap manipulations from UEFI code

 arch/arm64/include/asm/efi.h                   |  38 ++-
 arch/arm64/include/asm/mmu.h                   |   5 +-
 arch/arm64/include/asm/pgtable.h               |   5 +
 arch/arm64/kernel/efi.c                        | 369 ++++++++-----------------
 arch/arm64/kernel/setup.c                      |   2 +-
 arch/arm64/mm/mmu.c                            |  60 ++--
 drivers/firmware/efi/efi.c                     |  56 ++--
 drivers/firmware/efi/libstub/arm-stub.c        |  59 ++++
 drivers/firmware/efi/libstub/efi-stub-helper.c |  25 +-
 drivers/firmware/efi/libstub/efistub.h         |   4 +
 drivers/firmware/efi/libstub/fdt.c             |  62 ++++-
 include/linux/efi.h                            |   2 +
 12 files changed, 362 insertions(+), 325 deletions(-)
