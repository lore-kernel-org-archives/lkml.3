Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaDHSIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:08:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaDHSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:08:47 -0400
Date: Tue, 8 Apr 2014 11:11:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] More Staging driver patches for 3.15-rc1
Message-ID: <20140408181116.GA10020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8e0c0832348c7fda1c85d67697cfe4adf077344c:

  Merge tag 'fbdev-main-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux (2014-04-04 21:28:36 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc1

for you to fetch changes up to dda26427bd5252cbea876fe8a80050943c0dc642:

  staging: rtl8723au: The 8723 only has two paths (2014-04-07 12:53:00 -0700)

----------------------------------------------------------------
More staging patches for 3.15-rc1

Here are some more staging patches for 3.15-rc1.  They include a
late-submission of a wireless driver that a bunch of people seem to have
the hardware for now.  As it's stand-alone, it should be fine (now
passes the 0-day random build bot tests.)  There are also some fixes for
the unisys drivers, as they were causing havoc on a number of different
machines.  To resolve all of those issues, we just mark the driver as
BROKEN now, and we can fix it up "properly" over time.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Staging: unisys: mark drivers as BROKEN

Jes Sorensen (1):
      staging: rtl8723au: The 8723 only has two paths

Larry Finger (8):
      staging: r8723au: Add source files for new driver - part 1
      staging: r8723au: Add source files for new driver - part 2
      staging: r8723au: Add source files for new driver - part 3
      staging: r8723au: Add source files for new driver - part 4
      staging: r8723au: Additional source patches
      staging: r8723au: Turn on build of new driver
      staging: r8723au: Fix randconfig build errors
      staging: r8723au: Fix build problem when RFKILL is not selected

Masanari Iida (1):
      staging: unisys: Add missing close parentheses in filexfer.c

Sasha Levin (1):
      Staging: unisys: verify that a control channel exists

 drivers/staging/Kconfig                            |     2 +
 drivers/staging/Makefile                           |     1 +
 drivers/staging/rtl8723au/Kconfig                  |    38 +
 drivers/staging/rtl8723au/Makefile                 |    58 +
 drivers/staging/rtl8723au/TODO                     |    13 +
 drivers/staging/rtl8723au/core/rtw_ap.c            |  2087 ++++
 drivers/staging/rtl8723au/core/rtw_cmd.c           |  1876 +++
 drivers/staging/rtl8723au/core/rtw_efuse.c         |   716 ++
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |  1861 +++
 drivers/staging/rtl8723au/core/rtw_io.c            |   266 +
 drivers/staging/rtl8723au/core/rtw_ioctl_set.c     |   601 +
 drivers/staging/rtl8723au/core/rtw_led.c           |  1899 ++++
 drivers/staging/rtl8723au/core/rtw_mlme.c          |  2500 ++++
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |  9990 ++++++++++++++++
 drivers/staging/rtl8723au/core/rtw_p2p.c           |  4001 +++++++
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |   689 ++
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2471 ++++
 drivers/staging/rtl8723au/core/rtw_security.c      |  1652 +++
 drivers/staging/rtl8723au/core/rtw_sreset.c        |   255 +
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c       |   509 +
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |  1760 +++
 drivers/staging/rtl8723au/core/rtw_xmit.c          |  2460 ++++
 drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c      |    80 +
 drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c   |   136 +
 .../staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c    |  1063 ++
 drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c   |   726 ++
 drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c  |   188 +
 drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c   |   259 +
 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c       |   163 +
 drivers/staging/rtl8723au/hal/hal_com.c            |   881 ++
 drivers/staging/rtl8723au/hal/hal_intf.c           |   420 +
 drivers/staging/rtl8723au/hal/odm.c                |  2090 ++++
 drivers/staging/rtl8723au/hal/odm_HWConfig.c       |   481 +
 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c |   162 +
 drivers/staging/rtl8723au/hal/odm_debug.c          |    24 +
 drivers/staging/rtl8723au/hal/odm_interface.c      |   236 +
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    | 11304 +++++++++++++++++++
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       |   845 ++
 drivers/staging/rtl8723au/hal/rtl8723a_dm.c        |   273 +
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  |  3452 ++++++
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |  1162 ++
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c    |   507 +
 drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c    |    69 +
 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c    |    73 +
 drivers/staging/rtl8723au/hal/rtl8723a_xmit.c      |    52 +
 drivers/staging/rtl8723au/hal/rtl8723au_led.c      |   113 +
 drivers/staging/rtl8723au/hal/rtl8723au_recv.c     |   247 +
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c     |   548 +
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  1834 +++
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |   848 ++
 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h |   230 +
 drivers/staging/rtl8723au/include/Hal8723APhyReg.h |  1078 ++
 drivers/staging/rtl8723au/include/Hal8723PwrSeq.h  |   150 +
 .../staging/rtl8723au/include/Hal8723UHWImg_CE.h   |    29 +
 .../staging/rtl8723au/include/HalDMOutSrc8723A.h   |    64 +
 .../staging/rtl8723au/include/HalHWImg8723A_BB.h   |    44 +
 .../staging/rtl8723au/include/HalHWImg8723A_FW.h   |    28 +
 .../staging/rtl8723au/include/HalHWImg8723A_MAC.h  |    26 +
 .../staging/rtl8723au/include/HalHWImg8723A_RF.h   |    25 +
 drivers/staging/rtl8723au/include/HalPwrSeqCmd.h   |   130 +
 drivers/staging/rtl8723au/include/HalVerDef.h      |   136 +
 drivers/staging/rtl8723au/include/cmd_osdep.h      |    26 +
 drivers/staging/rtl8723au/include/drv_types.h      |   360 +
 drivers/staging/rtl8723au/include/ethernet.h       |    22 +
 drivers/staging/rtl8723au/include/hal_com.h        |   211 +
 drivers/staging/rtl8723au/include/hal_intf.h       |   392 +
 drivers/staging/rtl8723au/include/ieee80211.h      |   603 +
 drivers/staging/rtl8723au/include/ioctl_cfg80211.h |   119 +
 drivers/staging/rtl8723au/include/mlme_osdep.h     |    28 +
 drivers/staging/rtl8723au/include/mp_custom_oid.h  |   342 +
 drivers/staging/rtl8723au/include/odm.h            |  1205 ++
 drivers/staging/rtl8723au/include/odm_HWConfig.h   |   174 +
 .../staging/rtl8723au/include/odm_RegConfig8723A.h |    34 +
 .../staging/rtl8723au/include/odm_RegDefine11AC.h  |    49 +
 .../staging/rtl8723au/include/odm_RegDefine11N.h   |   165 +
 drivers/staging/rtl8723au/include/odm_debug.h      |   139 +
 drivers/staging/rtl8723au/include/odm_interface.h  |   131 +
 drivers/staging/rtl8723au/include/odm_precomp.h    |    54 +
 drivers/staging/rtl8723au/include/odm_reg.h        |   114 +
 drivers/staging/rtl8723au/include/odm_types.h      |    36 +
 drivers/staging/rtl8723au/include/osdep_intf.h     |    46 +
 drivers/staging/rtl8723au/include/osdep_service.h  |   207 +
 drivers/staging/rtl8723au/include/recv_osdep.h     |    45 +
 .../rtl8723au/include/rtl8723a_bt-coexist.h        |  1672 +++
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h   |   160 +
 drivers/staging/rtl8723au/include/rtl8723a_dm.h    |   144 +
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |   575 +
 drivers/staging/rtl8723au/include/rtl8723a_led.h   |    30 +
 drivers/staging/rtl8723au/include/rtl8723a_pg.h    |    98 +
 drivers/staging/rtl8723au/include/rtl8723a_recv.h  |    70 +
 drivers/staging/rtl8723au/include/rtl8723a_rf.h    |    58 +
 drivers/staging/rtl8723au/include/rtl8723a_spec.h  |  2158 ++++
 .../staging/rtl8723au/include/rtl8723a_sreset.h    |    25 +
 drivers/staging/rtl8723au/include/rtl8723a_xmit.h  |   229 +
 drivers/staging/rtl8723au/include/rtw_ap.h         |    55 +
 drivers/staging/rtl8723au/include/rtw_cmd.h        |   835 ++
 drivers/staging/rtl8723au/include/rtw_debug.h      |   192 +
 drivers/staging/rtl8723au/include/rtw_eeprom.h     |   135 +
 drivers/staging/rtl8723au/include/rtw_efuse.h      |   109 +
 drivers/staging/rtl8723au/include/rtw_event.h      |   114 +
 drivers/staging/rtl8723au/include/rtw_ht.h         |    43 +
 drivers/staging/rtl8723au/include/rtw_io.h         |   416 +
 drivers/staging/rtl8723au/include/rtw_ioctl.h      |    26 +
 drivers/staging/rtl8723au/include/rtw_ioctl_set.h  |    39 +
 drivers/staging/rtl8723au/include/rtw_led.h        |   181 +
 drivers/staging/rtl8723au/include/rtw_mlme.h       |   624 +
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |   780 ++
 drivers/staging/rtl8723au/include/rtw_p2p.h        |   158 +
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h    |   265 +
 drivers/staging/rtl8723au/include/rtw_qos.h        |    26 +
 drivers/staging/rtl8723au/include/rtw_recv.h       |   318 +
 drivers/staging/rtl8723au/include/rtw_rf.h         |   113 +
 drivers/staging/rtl8723au/include/rtw_security.h   |   357 +
 drivers/staging/rtl8723au/include/rtw_sreset.h     |    56 +
 drivers/staging/rtl8723au/include/rtw_version.h    |     1 +
 drivers/staging/rtl8723au/include/rtw_xmit.h       |   407 +
 drivers/staging/rtl8723au/include/sta_info.h       |   385 +
 drivers/staging/rtl8723au/include/usb_hal.h        |    20 +
 drivers/staging/rtl8723au/include/usb_ops.h        |    97 +
 drivers/staging/rtl8723au/include/usb_ops_linux.h  |    46 +
 drivers/staging/rtl8723au/include/usb_osintf.h     |    24 +
 drivers/staging/rtl8723au/include/usb_vendor_req.h |    31 +
 drivers/staging/rtl8723au/include/wifi.h           |   707 ++
 drivers/staging/rtl8723au/include/wlan_bssdef.h    |   215 +
 drivers/staging/rtl8723au/include/xmit_osdep.h     |    57 +
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  4532 ++++++++
 drivers/staging/rtl8723au/os_dep/mlme_linux.c      |   187 +
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |   970 ++
 drivers/staging/rtl8723au/os_dep/osdep_service.c   |   175 +
 drivers/staging/rtl8723au/os_dep/recv_linux.c      |   225 +
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |   833 ++
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |   283 +
 drivers/staging/rtl8723au/os_dep/xmit_linux.c      |   195 +
 drivers/staging/unisys/Kconfig                     |     2 +-
 drivers/staging/unisys/visorchipset/filexfer.c     |     2 +-
 .../unisys/visorchipset/visorchipset_main.c        |    18 +
 136 files changed, 89854 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/rtl8723au/Kconfig
 create mode 100644 drivers/staging/rtl8723au/Makefile
 create mode 100644 drivers/staging/rtl8723au/TODO
 create mode 100644 drivers/staging/rtl8723au/core/rtw_ap.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_cmd.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_efuse.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_ieee80211.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_io.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_ioctl_set.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_led.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_mlme.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_mlme_ext.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_p2p.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_pwrctrl.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_recv.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_security.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_sreset.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_sta_mgt.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_wlan_util.c
 create mode 100644 drivers/staging/rtl8723au/core/rtw_xmit.c
 create mode 100644 drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c
 create mode 100644 drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c
 create mode 100644 drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
 create mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c
 create mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c
 create mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c
 create mode 100644 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
 create mode 100644 drivers/staging/rtl8723au/hal/hal_com.c
 create mode 100644 drivers/staging/rtl8723au/hal/hal_intf.c
 create mode 100644 drivers/staging/rtl8723au/hal/odm.c
 create mode 100644 drivers/staging/rtl8723au/hal/odm_HWConfig.c
 create mode 100644 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
 create mode 100644 drivers/staging/rtl8723au/hal/odm_debug.c
 create mode 100644 drivers/staging/rtl8723au/hal/odm_interface.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_dm.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_xmit.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_led.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_recv.c
 create mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
 create mode 100644 drivers/staging/rtl8723au/hal/usb_halinit.c
 create mode 100644 drivers/staging/rtl8723au/hal/usb_ops_linux.c
 create mode 100644 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h
 create mode 100644 drivers/staging/rtl8723au/include/Hal8723APhyReg.h
 create mode 100644 drivers/staging/rtl8723au/include/Hal8723PwrSeq.h
 create mode 100644 drivers/staging/rtl8723au/include/Hal8723UHWImg_CE.h
 create mode 100644 drivers/staging/rtl8723au/include/HalDMOutSrc8723A.h
 create mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_BB.h
 create mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_FW.h
 create mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_MAC.h
 create mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_RF.h
 create mode 100644 drivers/staging/rtl8723au/include/HalPwrSeqCmd.h
 create mode 100644 drivers/staging/rtl8723au/include/HalVerDef.h
 create mode 100644 drivers/staging/rtl8723au/include/cmd_osdep.h
 create mode 100644 drivers/staging/rtl8723au/include/drv_types.h
 create mode 100644 drivers/staging/rtl8723au/include/ethernet.h
 create mode 100644 drivers/staging/rtl8723au/include/hal_com.h
 create mode 100644 drivers/staging/rtl8723au/include/hal_intf.h
 create mode 100644 drivers/staging/rtl8723au/include/ieee80211.h
 create mode 100644 drivers/staging/rtl8723au/include/ioctl_cfg80211.h
 create mode 100644 drivers/staging/rtl8723au/include/mlme_osdep.h
 create mode 100644 drivers/staging/rtl8723au/include/mp_custom_oid.h
 create mode 100644 drivers/staging/rtl8723au/include/odm.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_HWConfig.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_RegConfig8723A.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_RegDefine11AC.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_RegDefine11N.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_debug.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_interface.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_precomp.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_reg.h
 create mode 100644 drivers/staging/rtl8723au/include/odm_types.h
 create mode 100644 drivers/staging/rtl8723au/include/osdep_intf.h
 create mode 100644 drivers/staging/rtl8723au/include/osdep_service.h
 create mode 100644 drivers/staging/rtl8723au/include/recv_osdep.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_cmd.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_dm.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_hal.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_led.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_pg.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_recv.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_rf.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_spec.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_sreset.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_xmit.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_ap.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_cmd.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_debug.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_eeprom.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_efuse.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_event.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_ht.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_io.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_ioctl.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_ioctl_set.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_led.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_mlme.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_mlme_ext.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_p2p.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_pwrctrl.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_qos.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_recv.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_rf.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_security.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_sreset.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_version.h
 create mode 100644 drivers/staging/rtl8723au/include/rtw_xmit.h
 create mode 100644 drivers/staging/rtl8723au/include/sta_info.h
 create mode 100644 drivers/staging/rtl8723au/include/usb_hal.h
 create mode 100644 drivers/staging/rtl8723au/include/usb_ops.h
 create mode 100644 drivers/staging/rtl8723au/include/usb_ops_linux.h
 create mode 100644 drivers/staging/rtl8723au/include/usb_osintf.h
 create mode 100644 drivers/staging/rtl8723au/include/usb_vendor_req.h
 create mode 100644 drivers/staging/rtl8723au/include/wifi.h
 create mode 100644 drivers/staging/rtl8723au/include/wlan_bssdef.h
 create mode 100644 drivers/staging/rtl8723au/include/xmit_osdep.h
 create mode 100644 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/mlme_linux.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/os_intfs.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/osdep_service.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/recv_linux.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/usb_intf.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
 create mode 100644 drivers/staging/rtl8723au/os_dep/xmit_linux.c
