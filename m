Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3FBM4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:56:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56312 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3FBMz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:55:59 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/4] EFI 1:1 mapping
Date: Sun,  2 Jun 2013 14:56:06 +0200
Message-Id: <1370177770-26661-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

this one is 64-bit only for now and it has been tested only in kvm with
OVMF.

Keeping in mind the ihnerent efi b0rkedness left and right, I'd like to
be very cautious and conservative with this and not hurry anything until
it has been actually very well tested on a variety of baremetal boxes.

Please take a closer look and let me know.

Thanks.

Borislav Petkov (4):
  efi: Convert runtime services function ptrs
  x86, cpa: Map in an arbitrary pgd
  x86, efi: Add an efi= kernel command line parameter
  x86, efi: Map runtime services 1:1

 arch/x86/boot/compressed/eboot.c     |   2 +-
 arch/x86/include/asm/efi.h           |  30 +++---
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               |  80 ++++++++++++----
 arch/x86/platform/efi/efi.c          | 177 +++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi_stub_64.S  |  48 ++++++++++
 include/linux/efi.h                  |  28 +++---
 7 files changed, 290 insertions(+), 78 deletions(-)

-- 
1.8.3.rc1.25.g423ecb0

