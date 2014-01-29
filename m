Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaA2VhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:37:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA2VhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:37:10 -0500
Date: Wed, 29 Jan 2014 22:37:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: josh@joshtriplett.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: nuke remaining occurences of __TIME__/__DATE__
Message-ID: <20140129213709.GA1627@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this series by Josh finishes the removal of __DATE__ and __TIME__ from
the kernel. The last patch adds -Werror=date-time to KBUILD_CFLAGS to
stop these from reappearing. Part of the series went through Greg's
trees during this merge window, which is why this pull request is not based
on v3.13-rc1.

Thanks,
Michal


The following changes since commit ec513b16c480c6cdda1e3d597e611eafca05227b:

  Merge tag 'usb-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2014-01-20 16:13:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git drop-time

Josh Triplett (4):
      mtd: denali: Drop print of build date/time
      net: wireless: brcm80211: Drop debug version with build date/time
      x86: math-emu: Drop already-disabled print of build date
      Makefile: Build with -Werror=date-time if the compiler supports it

 Makefile                                           |    3 +++
 arch/x86/math-emu/errors.c                         |    5 -----
 drivers/mtd/nand/denali_pci.c                      |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    7 -------
 4 files changed, 3 insertions(+), 13 deletions(-)
