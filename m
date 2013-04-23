Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3DWKP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:15:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41924 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab3DWKP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:15:56 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 0/2] EFI runtime services 1:1 mapping
Date: Tue, 23 Apr 2013 12:15:50 +0200
Message-Id: <1366712152-8097-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Ok,

this is a first attempt to establish EFI runtime services regions
mappings into ->trampoline_pgd so that the prior can be used in kexec,
for example.

The more I'm dealing with this, the more I can't shake the idiocy of the
decision to make SetVirtualAddressMap() be callable only once per boot.
And for that decision, we're jumping through hoops in the kernel. Oh
well, one can hack on EFI and hate it at the same time :-).

So this is 64-only for now, it barely works in the sense that I can call
efi.get_time() through the new mappings.

What still is an issue is GetNextVariableName, for example, whose second
and third arg are I/O and, of course, not mapped. I still need to think
about how to do that (map them temporary, have a single mapped page
where I shovel data to and fro or something even better).

Anyway, this is just an RFC to sense the kosher-ness of the general
direction and to get people's opinion early enough.

Thanks for the review.

Borislav Petkov (2):
  x86, cpa: Map in an arbitrary pgd
  x86, efi: Add 1:1 mapping of runtime services

 arch/x86/include/asm/efi.h           |  2 +
 arch/x86/include/asm/pgtable_types.h |  3 +-
 arch/x86/mm/pageattr.c               | 80 ++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi.c          | 84 ++++++++++++++++++++++++++----------
 arch/x86/platform/efi/efi_stub_64.S  | 39 +++++++++++++++++
 5 files changed, 167 insertions(+), 41 deletions(-)

-- 
1.8.2.135.g7b592fa

