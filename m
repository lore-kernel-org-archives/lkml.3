Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaFDQyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:54:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48106 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFDQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:54:01 -0400
Date: Wed, 4 Jun 2014 17:53:58 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140604164955.GA3059@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Here are two commits I've queued up from Dave. The first fixes the efi
earlyprintk code and the second fixes a bug where we were exporting the
EFI runtime mappings for use by kexec-tools, despite the fact that those
mappings were not persistent across kexec reboot.

The following changes since commit 47514c996fac5e6f13ef3a4c5e23f1c5cffabb7b:

  efi: Pass correct file handle to efi_file_{read,close} (2014-04-10 21:20:03 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a3530e8fe980f756b823d451fe9243f26db95fa5:

  x86/efi: Do not export efi runtime map in case old map (2014-06-02 12:21:59 +0100)

----------------------------------------------------------------
 * Fix earlyprintk=efi,keep support by switching to an ioremap() mapping
   of the framebuffer when early_ioremap() is no longer available and
   dropping __init from functions that may be invoked after
   free_initmem() - Dave Young

 * We shouldn't be exporting the EFI runtime map in sysfs if not using
   the new 1:1 EFI mapping code since in that case the mappings are not
   static across a kexec reboot - Dave Young

----------------------------------------------------------------
Dave Young (2):
      x86/efi: earlyprintk=efi,keep fix
      x86/efi: Do not export efi runtime map in case old map

 arch/x86/platform/efi/early_printk.c | 83 +++++++++++++++++++++++++++---------
 arch/x86/platform/efi/efi.c          |  3 ++
 2 files changed, 67 insertions(+), 19 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
