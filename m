Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3K2MKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:10:21 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58801 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab3K2MKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:10:19 -0500
Date: Fri, 29 Nov 2013 12:09:51 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20131129120951.GF11775@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to fdeadb43fdf1e7d5698c027b555c389174548e5a:

  efi-pstore: Make efi-pstore return a unique id (2013-11-29 10:11:06 +0000)

----------------------------------------------------------------
 * Avoid triggering a lockdep warning caused by calling kmemdup() while
   holding a spinlock - Seiji Aguchi

 * EFI framebuffer earlyprintk fix for off-by-one error that caused
   console output to be split over two lines on some machines.

 * Avoid pstore filename collisions by using a timestamp to calculate
   the entry ID, thereby making them unique - Madper Xie

----------------------------------------------------------------
Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Matt Fleming (1):
      x86/efi: Fix earlyprintk off-by-one bug

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the scan is completed

 arch/x86/platform/efi/early_printk.c |   2 +-
 drivers/firmware/efi/efi-pstore.c    | 163 +++++++++++++++++++++++++++++++----
 drivers/firmware/efi/efivars.c       |  12 ++-
 drivers/firmware/efi/vars.c          |  12 ++-
 include/linux/efi.h                  |   4 +
 5 files changed, 170 insertions(+), 23 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
