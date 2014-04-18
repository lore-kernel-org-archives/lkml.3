Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaDRViQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:38:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaDRVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:37:58 -0400
Date: Fri, 18 Apr 2014 14:38:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.15-rc2
Message-ID: <20140418213807.GA3724@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc2

for you to fetch changes up to 33c84bc14c25074ac14644cf7db75a57e9abaf1a:

  staging: r8188eu: Fix case where ethtype was never obtained and always be checked against 0 (2014-04-16 13:07:19 -0700)

----------------------------------------------------------------
staging driver fixes for 3.15-rc2

Here are a few staging driver fixes for issues that have been reported
for 3.15-rc2.

Also dominating the diffstat for the pull request is the removal of the
rtl8187se driver.  It's no longer needed in staging as a "real" driver
for this hardware is now merged in the tree in the "correct" location in
drivers/net/

All of these patches have been tested in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arnd Bergmann (1):
      staging: gs_fpgaboot: remove __TIMESTAMP__ macro

Daeseok Youn (2):
      staging: vme: fix memory leak in vme_user_probe()
      staging: speakup: fix misuse of kstrtol() in handle_goto()

Dan Carpenter (2):
      staging: unisys: use after free in error messages
      Staging: unisys: use after free in list_for_each()

Geert Uytterhoeven (1):
      staging: r8723au: Add missing initialization of change_inx in sort algorithm

Greg Kroah-Hartman (1):
      staging: delete rtl8187se wireless driver

Ian Abbott (1):
      staging: comedi: fix circular locking dependency in comedi_mmap()

Jes Sorensen (1):
      staging: rtl8723au: Fix buffer overflow in rtw_get_wfd_ie()

Larry Finger (3):
      staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
      staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
      staging: r8188eu: Fix case where ethtype was never obtained and always be checked against 0

Paul Bolle (1):
      staging: fpgaboot: clean up Makefile

Richard Weinberger (1):
      staging/rtl8821ae: Fix OOM handling in _rtl_init_deferred_work()

Shuah Khan (2):
      staging/usbip: userspace - fix usbipd SIGSEGV from refresh_exported_devices()
      staging/usbip: fix store_attach() sscanf return value check

Tuomas Tynkkynen (1):
      staging: goldfish: Call free_irq in error path

Wilfried Klaebe (1):
      staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls

 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/comedi/comedi_buf.c                |   37 +-
 drivers/staging/comedi/comedi_fops.c               |   18 +-
 drivers/staging/comedi/comedi_internal.h           |    2 +
 drivers/staging/goldfish/goldfish_audio.c          |    1 +
 drivers/staging/gs_fpgaboot/Makefile               |    2 -
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c          |    1 -
 drivers/staging/rtl8187se/Kconfig                  |   10 -
 drivers/staging/rtl8187se/Makefile                 |   38 -
 drivers/staging/rtl8187se/Module.symvers           |    0
 drivers/staging/rtl8187se/TODO                     |   13 -
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |  189 -
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |   71 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    | 1496 --------
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |  240 --
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.h  |   86 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |  455 ---
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |  740 ----
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |  277 --
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |  203 --
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c | 1486 --------
 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 2711 --------------
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |  567 ---
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |  591 ---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  713 ----
 drivers/staging/rtl8187se/r8180.h                  |  640 ----
 drivers/staging/rtl8187se/r8180_93cx6.h            |   54 -
 drivers/staging/rtl8187se/r8180_core.c             | 3775 --------------------
 drivers/staging/rtl8187se/r8180_dm.c               | 1139 ------
 drivers/staging/rtl8187se/r8180_dm.h               |   23 -
 drivers/staging/rtl8187se/r8180_hw.h               |  588 ---
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   34 -
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |  811 -----
 drivers/staging/rtl8187se/r8180_wx.c               | 1409 --------
 drivers/staging/rtl8187se/r8180_wx.h               |   21 -
 drivers/staging/rtl8187se/r8185b_init.c            | 1464 --------
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   19 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   74 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |   13 +-
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |   46 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |    2 +-
 drivers/staging/rtl8723au/core/rtw_p2p.c           |    4 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |    4 +-
 drivers/staging/rtl8821ae/base.c                   |   10 +-
 drivers/staging/speakup/main.c                     |   18 +-
 drivers/staging/unisys/uislib/uislib.c             |    4 +-
 drivers/staging/unisys/visorchipset/visorchipset.h |    4 +-
 .../unisys/visorchipset/visorchipset_main.c        |    8 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     |    7 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    2 +-
 drivers/staging/vme/devices/vme_user.c             |    9 +-
 52 files changed, 154 insertions(+), 19978 deletions(-)
 delete mode 100644 drivers/staging/rtl8187se/Kconfig
 delete mode 100644 drivers/staging/rtl8187se/Makefile
 delete mode 100644 drivers/staging/rtl8187se/Module.symvers
 delete mode 100644 drivers/staging/rtl8187se/TODO
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/dot11d.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/dot11d.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
 delete mode 100644 drivers/staging/rtl8187se/r8180.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_93cx6.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_core.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_dm.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_dm.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_hw.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8225.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8225z2.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_wx.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_wx.h
 delete mode 100644 drivers/staging/rtl8187se/r8185b_init.c
