Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3IVWp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:45:29 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:51393 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3IVWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:26 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 00/18] ARM EFI stub common code
Date: Sun, 22 Sep 2013 15:45:24 -0700
Message-Id: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the common/x86 portion of the ARM EFI stub
patchset broken out.  These changes support the addition
of EFI stub support for the ARM and ARM64 architectures.
The common code that is now shared in efi-stub-helper.c
is based on code in the x86 stub that has been generalized
to support other architectures.



(Previously these changes were submitted as part of
the "EFI stub for ARM" patch series that included the
common/x86 changes as well as the ARM changes.)


Changes since V4:
* Fix relocate_kernel() on x86/x86_64 by adding alignment parameter.
  The alignment was previously read from the setup_header structure
  passed to relocate_kernel was was missed when converting to passing
  all values as parameters.
* Undo comment reformatting in efi-stub-helper.c
* Fix incorrect comment in eboot.c (obsolete, based on older intermediate
  version.
* Include HPA's patch for command line conversion.

Changes since V3:
* Made relocate_kernel() a shared function.
* Made command line unicode to ASCII conversion ASCII
  a shared function
* Updated efi_get_memory_map() to return descriptor version,
  and updated x86 stub to use it to retrieve final memory map.
* removed min_address argument of efi_low_alloc(), as it is
  no longer used.
* Squashed very tiny patch moving EFI_READ_CHUNK_SIZE into
  related patch.


Changes since v2:
* EFI bugfix "correct call to free_pages" that patch series
  depends on now in mainline
* remove unnecessary zimage_size variable from relocate_kernel()
* correct return types on EFI functions - should be efi_status_t, not int.

Changes since V1:
* Broke up changes to x86 and common code into more patches.
  10 more patches in this series.

H. Peter Anvin (1):
  Do proper conversion from UTF-16 to UTF-8

Roy Franz (17):
  EFI stub documentation updates
  Add proper definitions for some EFI function pointers.
  Move common EFI stub code from x86 arch code to common location
  Add system table pointer argument to shared functions.
  Rename memory allocation/free functions
  Enforce minimum alignment of 1 page on allocations.
  Move relocate_kernel() to shared file.
  Generalize relocate_kernel() for use by other architectures.
  Move unicode to ASCII conversion to shared function.
  Rename __get_map() to efi_get_memory_map()
  generalize efi_get_memory_map()
  use efi_get_memory_map() to get final map for x86
  Allow efi_free() to be called with size of 0, and do nothing in that
    case.
  Generalize handle_ramdisks() and rename to handle_cmdline_files().
  Renames in handle_cmdline_files() to complete generalization.
  Fix types in EFI calls to match EFI function definitions.
  resolve warnings found on ARM compile

 Documentation/efi-stub.txt             |   65 +++
 Documentation/x86/efi-stub.txt         |   65 ---
 arch/x86/Kconfig                       |    2 +-
 arch/x86/boot/compressed/eboot.c       |  579 ++-------------------------
 arch/x86/boot/compressed/eboot.h       |    9 -
 drivers/firmware/efi/efi-stub-helper.c |  679 ++++++++++++++++++++++++++++++++
 include/linux/efi.h                    |   50 ++-
 7 files changed, 817 insertions(+), 632 deletions(-)
 create mode 100644 Documentation/efi-stub.txt
 delete mode 100644 Documentation/x86/efi-stub.txt
 create mode 100644 drivers/firmware/efi/efi-stub-helper.c

-- 
1.7.10.4

