Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab3D3PZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:25:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37930 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932632Ab3D3PZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:25:21 -0400
Message-ID: <517FE259.60304@console-pimps.org>
Date: Tue, 30 Apr 2013 16:25:13 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EFI fixes for tip/x86/efi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This pull includes fixes for the merge window material currently sitting
in tip/x86/efi. The three patches from me fix bugs in the pstore code
paths and the two from Dan are the results of his static analysis tool,
including a fix for a locking bug.

The changes are based on my efi-for-tip2 branch. If you would like it
based on something else, just let me know.

The following changes since commit a614e1923d5389d01f3545ee4a90e39a04d0c90d:

  Merge tag 'v3.9' into efi-for-tip2 (2013-04-30 11:42:13 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi-for-tip-fixes

for you to fetch changes up to 7b2dd6d2c4db3912771bfcfd7ac7264011a3c831:

  efi: remove "kfree(NULL)" (2013-04-30 16:03:18 +0100)

----------------------------------------------------------------
Dan Carpenter (2):
      efi: locking fix in efivar_entry_set_safe()
      efi: remove "kfree(NULL)"

Matt Fleming (3):
      efi, pstore: Initialise 'entry' before iterating
      efi, pstore: Remove entry from list when erasing
      efi, pstore: Read data from variable store before memcpy()

 drivers/firmware/efi/efi-pstore.c |   10 +++++--
 drivers/firmware/efi/efivars.c    |    4 +--
 drivers/firmware/efi/vars.c       |   53 ++++++++++++++++++++-----------------
 include/linux/efi.h               |    3 ++-
 4 files changed, 39 insertions(+), 31 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
