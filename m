Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaIIICk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:02:40 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44181 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaIIICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:02:37 -0400
Date: Tue, 9 Sep 2014 09:02:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL v2] EFI urgent fixes
Message-ID: <20140909080233.GG18582@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, this is a resend of the EFI urgent pull request from yesterday
with the non-regression-fixing patches dropped as Ingo requested. The
patches fix two regressions introduced during the merge window, and one
introduced in -rc2.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 0ceac9e094b065fe3fec19669740f338d3480498:

  efi/arm64: Fix fdt-related memory reservation (2014-09-09 07:51:09 +0100)

----------------------------------------------------------------
 * Fix early boot regression affecting x86 EFI boot stub when loading
   initrds above 4GB - Yinghai Lu

 * Relocate GOT entries in the x86 EFI boot stub now that we have
   symbols with global visibility - Matt Fleming

 * fdt memory reservation fix for arm64 - Mark Salter

----------------------------------------------------------------
Mark Salter (1):
      efi/arm64: Fix fdt-related memory reservation

Matt Fleming (1):
      x86/efi: Fixup GOT in all boot code paths

Yinghai Lu (1):
      x86/efi: Only load initrd above 4g on second try

 arch/arm64/mm/init.c               |  3 +-
 arch/x86/boot/compressed/eboot.c   | 18 +++++++-----
 arch/x86/boot/compressed/head_32.S | 54 ++++++++++++++++++++++++++----------
 arch/x86/boot/compressed/head_64.S | 56 ++++++++++++++++++++++++++++----------
 drivers/firmware/efi/libstub/fdt.c | 10 ++++++-
 5 files changed, 102 insertions(+), 39 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
