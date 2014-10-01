Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaJAMGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:06:45 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45432 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaJAMGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:06:43 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/2] efi: Remove conditional in_nmi() runtime locking
Date: Wed,  1 Oct 2014 13:06:38 +0100
Message-Id: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

These two patches should address the concerns raised by Ingo and Peter
in relation to the EFI pull request containing v3.18 material,

  https://lkml.kernel.org/r/20140928202702.GB18635@console-pimps.org

We can drop the in_nmi() checks altogether and just provide normal
locking semantics if we introduce a non-blocking SetVariable() operation
for the particular case of writing pstore data to the EFI backend from
the kdump callback, which aborts in the contended case.

This is currently holding up merging of the v3.18 EFI patches, so please
be timely with comments, if any.

@Linaro guys, I don't think you'll actually care all that much about
these changes since the in_nmi() goo was for x86's benefit, but I'm
Cc'ing you anyway to make sure everything looks OK.

Matt Fleming (2):
  efi: Provide a non-blocking SetVariable() operation
  efi: Delete the in_nmi() conditional runtime locking

 arch/x86/include/asm/efi.h              |  2 --
 drivers/firmware/efi/runtime-wrappers.c | 36 ++++++++++++++++---------
 drivers/firmware/efi/vars.c             | 47 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |  6 +++++
 4 files changed, 76 insertions(+), 15 deletions(-)

-- 
1.9.3

