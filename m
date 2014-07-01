Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaGARDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:03:14 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53972 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaGARDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:03:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 0/5] Remove non-standard ioctls
Date: Tue,  1 Jul 2014 22:32:33 +0530
Message-Id: <1404234158-21389-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver implements many WEXT_PRIV (non-standard) ioctl handlers to provide
userspace interface for following functionalities.

* WPS ( Not working )
* Debugging ( Setting/Getting register's value, dumping information)
* P2P mode
* Mesh point MP (Mode)

I suggest we should remove all functionalities which are using non-standard
ioctls, as a result of doing this the driver code complexity will reduce.
And once the driver is switched to use mac80211 framework, we can reimplement
functionalities mentioned above in a standard way.

navin patidar (5):
  staging: rtl8188eu: Remove WEXT_PRIV private ioctl handlers
  staging: rtl8188eu: Remove files rtw_mp_ioctl.[c,h]
  staging: rtl8188eu: Remove usb_osintf.h header file.
  staging: rtl8188eu: Remove mp( mesh point) mode support
  staging: rtl8188eu: Remove P2P support

 drivers/staging/rtl8188eu/Makefile               |    4 -
 drivers/staging/rtl8188eu/core/rtw_ap.c          |    8 -
 drivers/staging/rtl8188eu/core/rtw_cmd.c         |   66 -
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c   |  208 +-
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c   |    2 -
 drivers/staging/rtl8188eu/core/rtw_mlme.c        |   18 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    | 3157 +----------
 drivers/staging/rtl8188eu/core/rtw_mp.c          |  995 ----
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c    | 1430 -----
 drivers/staging/rtl8188eu/core/rtw_p2p.c         | 2015 -------
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c     |   37 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c        |   27 -
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |    9 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c        |    1 -
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c   |   11 -
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c     |   72 -
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c      |  854 ---
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c   |    3 -
 drivers/staging/rtl8188eu/hal/usb_halinit.c      |   60 +-
 drivers/staging/rtl8188eu/include/drv_types.h    |    8 -
 drivers/staging/rtl8188eu/include/ieee80211.h    |   13 -
 drivers/staging/rtl8188eu/include/osdep_intf.h   |    5 +-
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h |    4 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h |    4 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    3 -
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |   12 -
 drivers/staging/rtl8188eu/include/rtw_mp.h       |  495 --
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h |  340 --
 drivers/staging/rtl8188eu/include/rtw_p2p.h      |  135 -
 drivers/staging/rtl8188eu/include/sta_info.h     |   15 -
 drivers/staging/rtl8188eu/include/usb_osintf.h   |   38 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c   | 6403 +++-------------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c      |   37 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |   23 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c    |    1 -
 35 files changed, 941 insertions(+), 15572 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_mp.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_p2p.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_mp.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_p2p.h
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_osintf.h

--
1.7.10.4

