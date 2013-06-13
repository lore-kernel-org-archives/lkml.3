Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3FMNqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:46:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44845 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab3FMNqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:46:50 -0400
Date: Thu, 13 Jun 2013 14:46:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.11
Message-ID: <20130613134646.GU31198@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to d3768d885c6ccbf8a137276843177d76c49033a7:

  x86, efi: retry ExitBootServices() on failure (2013-06-11 07:51:54 +0100)

----------------------------------------------------------------
 * Only pass memory regions that are marked as required for runtime to
   SetVirtualAddressMap() - Matthew Garrett

 * A small cleanup to get rid of all the void * casting that is
   prevalent in the EFI code - Borislav Petkov

 * Handle the case where ExitBootServices() wants us to call it a second
   time because some of the firmware signal handlers have changed the
   memory map - Zach Bobroff

----------------------------------------------------------------
Borislav Petkov (1):
      efi: Convert runtime services function ptrs

Matthew Garrett (1):
      UEFI: Don't pass boot services regions to SetVirtualAddressMap()

Zach Bobroff (1):
      x86, efi: retry ExitBootServices() on failure

 arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
 arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
 arch/x86/platform/efi/efi.c      |  7 +++++++
 include/linux/efi.h              | 28 ++++++++++++++--------------
 4 files changed, 52 insertions(+), 31 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
