Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3DZQa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:30:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43240 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab3DZQa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:30:26 -0400
Date: Fri, 26 Apr 2013 17:30:22 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Michel Lespinasse <walken@google.com>
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20130426163022.GC23038@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Linus,

I've got a small patch that fixes a crash for the Google folks and their
EFI SMI driver, which was caused by dereferencing a garbage pointer.

Please consider pulling.

The following changes since commit f697036b93aa7345d4cbb3c854a76456c0ddac45:

  efi: Check EFI revision in setup_efi_vars (2013-04-24 16:19:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 45432323ef7038a91599959173700fdb8a0adb2f:

  efivars: only check for duplicates on the registered list (2013-04-26 16:50:01 +0100)

----------------------------------------------------------------
 * Last minute bugfix for the efivars code. The google EFI SMI driver
   maintains its own list of EFI variables but the efivars core was
   directly accessing a different (and in this case, uninitialised) list
   resulting in a crash.

----------------------------------------------------------------
Matt Fleming (1):
      efivars: only check for duplicates on the registered list

 drivers/firmware/efivars.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
