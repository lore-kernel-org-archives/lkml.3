Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3EQKST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:18:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38417 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab3EQKSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:18:18 -0400
Date: Fri, 17 May 2013 11:18:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20130517101813.GB14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've queued up some fixes for bugs that were introduced in the merge
window. Please consider pulling, thanks.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to eccaf52fee8305d5207ff110950a82c100e459bc:

  x86, efi: initial the local variable of DataSize to zero (2013-05-14 08:13:05 +0100)

----------------------------------------------------------------
 * Avoid confusing the user by returning -EIO instead of -ENOENT in
   efivarfs if an EFI variable gets deleted from under us and return EOF
   when reading from a zero-length file - Lingzhu Xiang

 * Fix an oops in efivar_update_sysfs_entries() caused by reusing (and
   therefore corrupting) a kzalloc() allocation - Seiji Aguchi

 * Initialise the DataSize argument to GetVariable() otherwise it will
   not be updated with the actual size of the variable on return.
   Discovered on a Acer Aspire V3 BIOS - Lee, Chun-Yi

----------------------------------------------------------------
Lee, Chun-Yi (1):
      x86, efi: initial the local variable of DataSize to zero

Lingzhu Xiang (1):
      efivarfs: Never return ENOENT from firmware again

Seiji Aguchi (1):
      efivar: fix oops in efivar_update_sysfs_entries() caused by memory reuse

 arch/x86/platform/efi/efi.c    |  2 +-
 drivers/firmware/efi/efivars.c |  8 +++-----
 fs/efivarfs/file.c             | 14 ++++++++++++--
 3 files changed, 16 insertions(+), 8 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
