Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967562Ab3DRQMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:12:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47979 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966792Ab3DRQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:12:17 -0400
Message-ID: <51701B5F.9090203@console-pimps.org>
Date: Thu, 18 Apr 2013 17:12:15 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Subject: [GIT PULL] EFI efivars.c dissection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

As discussed previously, please consider pulling this into a new topic
branch, to potentially merge for v3.10. The changes move all the code in
drivers/firmware/efivars.c into new files under drivers/firmware/efi/
and moves the efivarfs code to fs/efivarfs. This allow us to pick and
choose which EFI support to compile instead of having everything under
one monolithic file. In particular, having the efivarfs code under fs/
allows building an efivarfs.ko module, which means mount(8) can
automatically load it.

It also introduces the new efivar_entry API.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git chainsaw

for you to fetch changes up to a9499fa7cd3fd4824a7202d00c766b269fa3bda6:

  efi: split efisubsystem from efivars (2013-04-17 13:27:06 +0100)

----------------------------------------------------------------
Matt Fleming (5):
      efi: move utf16 string functions to efi.h
      efivars: Keep a private global pointer to efivars
      efivars: efivar_entry API
      efivars: Move pstore code into the new EFI directory
      efivarfs: Move to fs/efivarfs

Tom Gundersen (1):
      efi: split efisubsystem from efivars

 MAINTAINERS                       |   13 +-
 drivers/firmware/Kconfig          |   36 +-
 drivers/firmware/Makefile         |    2 +-
 drivers/firmware/efi/Kconfig      |   39 +
 drivers/firmware/efi/Makefile     |    6 +
 drivers/firmware/efi/efi-pstore.c |  244 +++++
 drivers/firmware/efi/efi.c        |  134 +++
 drivers/firmware/efi/efivars.c    |  617 +++++++++++
 drivers/firmware/efi/vars.c       | 1049 ++++++++++++++++++
 drivers/firmware/efivars.c        | 2171 -------------------------------------
 drivers/firmware/google/gsmi.c    |   30 +-
 fs/Kconfig                        |    1 +
 fs/Makefile                       |    1 +
 fs/efivarfs/Kconfig               |   12 +
 fs/efivarfs/Makefile              |    7 +
 fs/efivarfs/file.c                |  111 ++
 fs/efivarfs/inode.c               |  173 +++
 fs/efivarfs/internal.h            |   22 +
 fs/efivarfs/super.c               |  267 +++++
 include/linux/efi.h               |  134 ++-
 20 files changed, 2835 insertions(+), 2234 deletions(-)
 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/efi-pstore.c
 create mode 100644 drivers/firmware/efi/efi.c
 create mode 100644 drivers/firmware/efi/efivars.c
 create mode 100644 drivers/firmware/efi/vars.c
 delete mode 100644 drivers/firmware/efivars.c
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

-- 
Matt Fleming, Intel Open Source Technology Center
