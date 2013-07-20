Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3GTUJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:09:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3GTUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:09:41 -0400
Date: Sat, 20 Jul 2013 13:09:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.11-rc2
Message-ID: <20130720200950.GA11542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.11-rc2

for you to fetch changes up to 78077256bc08348d587e318957ceb41fe4d4afae:

  Merge tag 'iio-fixes-for-3.11a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2013-07-16 22:41:38 -0700)

----------------------------------------------------------------

Staging tree fixes for 3.11-rc2

Here are a few iio driver fixes for 3.11-rc2.  They are still spread
across drivers/iio and drivers/staging/iio so they are coming in through
this tree.

I've also removed the drivers/staging/csr/ driver as the developers who
originally sent it to me have moved on to other companies, and CSR still
will not send us the specs for the device, making the driver pretty much
obsolete and impossible to fix up.  Deleting it now prevents people from
sending in lots of tiny codingsyle fixes that will never go anywhere.

It also helps to offset the large lustre filesystem merge that happened
in 3.11-rc1 in the overall 3.11.0 diffstat. :)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexandre Belloni (2):
      iio: Fix iio_channel_has_info
      iio: inkern: fix iio_convert_raw_to_processed_unlocked

Greg Kroah-Hartman (2):
      staging: csr: remove driver
      Merge tag 'iio-fixes-for-3.11a' of git://git.kernel.org/.../jic23/iio into staging-linus

Jacek Anaszewski (1):
      iio: lps331ap: Fix wrong in_pressure_scale output value

Jonathan Cameron (1):
      iio:trigger: device_unregister->device_del to avoid double free

Marek Vasut (2):
      iio: mxs-lradc: Fix misuse of iio->trig
      iio: mxs-lradc: Remove useless check in read_raw

Peter Meerwald (1):
      iio staging: fix lis3l02dq, read error handling

Wei Yongjun (3):
      iio: dac: ad7303: fix error return code in ad7303_probe()
      iio: ti_am335x_adc: add missing .driver_module to struct iio_info
      staging:iio:ad7291: add missing .driver_module to struct iio_info

 drivers/iio/adc/ti_am335x_adc.c                    |    1 +
 drivers/iio/dac/ad7303.c                           |    4 +-
 drivers/iio/industrialio-trigger.c                 |    2 +-
 drivers/iio/inkern.c                               |    2 +-
 drivers/iio/pressure/st_pressure_core.c            |    6 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/csr/Kconfig                        |    9 -
 drivers/staging/csr/LICENSE.txt                    |   39 -
 drivers/staging/csr/Makefile                       |   73 -
 drivers/staging/csr/bh.c                           |  404 --
 drivers/staging/csr/csr_framework_ext.c            |   40 -
 drivers/staging/csr/csr_framework_ext.h            |   35 -
 drivers/staging/csr/csr_framework_ext_types.h      |   30 -
 drivers/staging/csr/csr_log.h                      |  223 -
 drivers/staging/csr/csr_log_configure.h            |   39 -
 drivers/staging/csr/csr_log_text.h                 |  124 -
 drivers/staging/csr/csr_macro.h                    |   39 -
 drivers/staging/csr/csr_msg_transport.h            |   17 -
 drivers/staging/csr/csr_msgconv.c                  |  291 -
 drivers/staging/csr/csr_msgconv.h                  |   78 -
 drivers/staging/csr/csr_prim_defs.h                |   55 -
 drivers/staging/csr/csr_result.h                   |   17 -
 drivers/staging/csr/csr_sched.h                    |   85 -
 drivers/staging/csr/csr_sdio.h                     |  723 ---
 .../staging/csr/csr_serialize_primitive_types.c    |  100 -
 drivers/staging/csr/csr_time.c                     |   33 -
 drivers/staging/csr/csr_time.h                     |   76 -
 drivers/staging/csr/csr_util.c                     |   15 -
 drivers/staging/csr/csr_wifi_common.h              |  101 -
 drivers/staging/csr/csr_wifi_fsm.h                 |  240 -
 drivers/staging/csr/csr_wifi_fsm_event.h           |   42 -
 drivers/staging/csr/csr_wifi_fsm_types.h           |  430 --
 drivers/staging/csr/csr_wifi_hip_card.h            |  114 -
 drivers/staging/csr/csr_wifi_hip_card_sdio.c       | 4001 ------------
 drivers/staging/csr/csr_wifi_hip_card_sdio.h       |  694 ---
 drivers/staging/csr/csr_wifi_hip_card_sdio_intr.c  | 2595 --------
 drivers/staging/csr/csr_wifi_hip_card_sdio_mem.c   | 1713 -----
 drivers/staging/csr/csr_wifi_hip_chiphelper.c      |  793 ---
 drivers/staging/csr/csr_wifi_hip_chiphelper.h      |  407 --
 .../staging/csr/csr_wifi_hip_chiphelper_private.h  |  200 -
 drivers/staging/csr/csr_wifi_hip_conversions.h     |   73 -
 drivers/staging/csr/csr_wifi_hip_download.c        |  819 ---
 drivers/staging/csr/csr_wifi_hip_dump.c            |  837 ---
 drivers/staging/csr/csr_wifi_hip_packing.c         | 4804 ---------------
 drivers/staging/csr/csr_wifi_hip_send.c            |  415 --
 drivers/staging/csr/csr_wifi_hip_signals.c         | 1313 ----
 drivers/staging/csr/csr_wifi_hip_signals.h         |  128 -
 drivers/staging/csr/csr_wifi_hip_sigs.h            | 1417 -----
 drivers/staging/csr/csr_wifi_hip_ta_sampling.c     |  541 --
 drivers/staging/csr/csr_wifi_hip_ta_sampling.h     |   66 -
 drivers/staging/csr/csr_wifi_hip_udi.c             |  173 -
 drivers/staging/csr/csr_wifi_hip_unifi.h           |  871 ---
 .../staging/csr/csr_wifi_hip_unifi_signal_names.c  |   41 -
 drivers/staging/csr/csr_wifi_hip_unifi_udi.h       |   52 -
 drivers/staging/csr/csr_wifi_hip_unifihw.h         |   59 -
 drivers/staging/csr/csr_wifi_hip_unifiversion.h    |   30 -
 drivers/staging/csr/csr_wifi_hip_xbv.c             | 1076 ----
 drivers/staging/csr/csr_wifi_hip_xbv.h             |  119 -
 drivers/staging/csr/csr_wifi_hostio_prim.h         |   18 -
 drivers/staging/csr/csr_wifi_lib.h                 |  103 -
 drivers/staging/csr/csr_wifi_msgconv.h             |   49 -
 .../staging/csr/csr_wifi_nme_ap_converter_init.c   |   90 -
 .../staging/csr/csr_wifi_nme_ap_converter_init.h   |   41 -
 .../csr/csr_wifi_nme_ap_free_downstream_contents.c |   84 -
 .../csr/csr_wifi_nme_ap_free_upstream_contents.c   |   39 -
 drivers/staging/csr/csr_wifi_nme_ap_lib.h          |  495 --
 drivers/staging/csr/csr_wifi_nme_ap_prim.h         |  494 --
 drivers/staging/csr/csr_wifi_nme_ap_sef.c          |   30 -
 drivers/staging/csr/csr_wifi_nme_ap_sef.h          |   21 -
 drivers/staging/csr/csr_wifi_nme_ap_serialize.c    |  909 ---
 drivers/staging/csr/csr_wifi_nme_ap_serialize.h    |   94 -
 drivers/staging/csr/csr_wifi_nme_converter_init.h  |   38 -
 drivers/staging/csr/csr_wifi_nme_lib.h             |  991 ---
 drivers/staging/csr/csr_wifi_nme_prim.h            | 1657 -----
 drivers/staging/csr/csr_wifi_nme_serialize.h       |  166 -
 drivers/staging/csr/csr_wifi_nme_task.h            |   27 -
 drivers/staging/csr/csr_wifi_private_common.h      |   81 -
 drivers/staging/csr/csr_wifi_result.h              |   27 -
 .../staging/csr/csr_wifi_router_converter_init.c   |   82 -
 .../staging/csr/csr_wifi_router_converter_init.h   |   34 -
 .../csr/csr_wifi_router_ctrl_converter_init.c      |  134 -
 .../csr/csr_wifi_router_ctrl_converter_init.h      |   34 -
 ...csr_wifi_router_ctrl_free_downstream_contents.c |  108 -
 .../csr_wifi_router_ctrl_free_upstream_contents.c  |   87 -
 drivers/staging/csr/csr_wifi_router_ctrl_lib.h     | 2082 -------
 drivers/staging/csr/csr_wifi_router_ctrl_prim.h    | 2113 -------
 drivers/staging/csr/csr_wifi_router_ctrl_sef.c     |   46 -
 drivers/staging/csr/csr_wifi_router_ctrl_sef.h     |   51 -
 .../staging/csr/csr_wifi_router_ctrl_serialize.c   | 2591 --------
 .../staging/csr/csr_wifi_router_ctrl_serialize.h   |  333 -
 .../csr/csr_wifi_router_free_downstream_contents.c |   53 -
 .../csr/csr_wifi_router_free_upstream_contents.c   |   47 -
 drivers/staging/csr/csr_wifi_router_lib.h          |  417 --
 drivers/staging/csr/csr_wifi_router_prim.h         |  421 --
 drivers/staging/csr/csr_wifi_router_sef.c          |   19 -
 drivers/staging/csr/csr_wifi_router_sef.h          |   25 -
 drivers/staging/csr/csr_wifi_router_serialize.c    |  418 --
 drivers/staging/csr/csr_wifi_router_serialize.h    |   67 -
 drivers/staging/csr/csr_wifi_router_task.h         |   25 -
 drivers/staging/csr/csr_wifi_router_transport.c    |  199 -
 .../csr/csr_wifi_serialize_primitive_types.c       |  256 -
 drivers/staging/csr/csr_wifi_sme_ap_lib.h          |  774 ---
 drivers/staging/csr/csr_wifi_sme_ap_prim.h         | 1030 ----
 drivers/staging/csr/csr_wifi_sme_converter_init.c  |  201 -
 drivers/staging/csr/csr_wifi_sme_converter_init.h  |   34 -
 .../csr/csr_wifi_sme_free_downstream_contents.c    |  187 -
 .../csr/csr_wifi_sme_free_upstream_contents.c      |  275 -
 drivers/staging/csr/csr_wifi_sme_lib.h             | 4303 -------------
 drivers/staging/csr/csr_wifi_sme_prim.h            | 6510 --------------------
 drivers/staging/csr/csr_wifi_sme_sef.c             |   85 -
 drivers/staging/csr/csr_wifi_sme_sef.h             |  142 -
 drivers/staging/csr/csr_wifi_sme_serialize.c       | 5809 -----------------
 drivers/staging/csr/csr_wifi_sme_serialize.h       |  666 --
 drivers/staging/csr/csr_wifi_sme_task.h            |   25 -
 drivers/staging/csr/csr_wifi_vif_utils.h           |   27 -
 drivers/staging/csr/data_tx.c                      |   54 -
 drivers/staging/csr/drv.c                          | 2193 -------
 drivers/staging/csr/firmware.c                     |  396 --
 drivers/staging/csr/inet.c                         |  104 -
 drivers/staging/csr/init_hw.c                      |  108 -
 drivers/staging/csr/io.c                           | 1098 ----
 drivers/staging/csr/mlme.c                         |  433 --
 drivers/staging/csr/monitor.c                      |  384 --
 drivers/staging/csr/netdev.c                       | 3307 ----------
 drivers/staging/csr/os.c                           |  477 --
 drivers/staging/csr/putest.c                       |  685 --
 drivers/staging/csr/sdio_events.c                  |  134 -
 drivers/staging/csr/sdio_mmc.c                     | 1288 ----
 drivers/staging/csr/sdio_stubs.c                   |   82 -
 drivers/staging/csr/sme_blocking.c                 | 1466 -----
 drivers/staging/csr/sme_mgt.c                      | 1012 ---
 drivers/staging/csr/sme_native.c                   |  566 --
 drivers/staging/csr/sme_sys.c                      | 3260 ----------
 drivers/staging/csr/sme_userspace.c                |  315 -
 drivers/staging/csr/sme_userspace.h                |   38 -
 drivers/staging/csr/sme_wext.c                     | 3327 ----------
 drivers/staging/csr/ul_int.c                       |  528 --
 drivers/staging/csr/unifi_clients.h                |  129 -
 drivers/staging/csr/unifi_config.h                 |   34 -
 drivers/staging/csr/unifi_dbg.c                    |  110 -
 drivers/staging/csr/unifi_event.c                  |  692 ---
 drivers/staging/csr/unifi_native.h                 |  257 -
 drivers/staging/csr/unifi_os.h                     |  122 -
 drivers/staging/csr/unifi_pdu_processing.c         | 3729 -----------
 drivers/staging/csr/unifi_priv.h                   | 1136 ----
 drivers/staging/csr/unifi_sme.c                    | 1225 ----
 drivers/staging/csr/unifi_sme.h                    |  245 -
 drivers/staging/csr/unifi_wext.h                   |  108 -
 drivers/staging/csr/unifiio.h                      |  398 --
 drivers/staging/csr/wext_events.c                  |  283 -
 drivers/staging/iio/accel/lis3l02dq_core.c         |    2 +
 drivers/staging/iio/adc/ad7291.c                   |    1 +
 drivers/staging/iio/adc/mxs-lradc.c                |   18 +-
 include/linux/iio/iio.h                            |    4 +-
 155 files changed, 22 insertions(+), 91617 deletions(-)
 delete mode 100644 drivers/staging/csr/Kconfig
 delete mode 100644 drivers/staging/csr/LICENSE.txt
 delete mode 100644 drivers/staging/csr/Makefile
 delete mode 100644 drivers/staging/csr/bh.c
 delete mode 100644 drivers/staging/csr/csr_framework_ext.c
 delete mode 100644 drivers/staging/csr/csr_framework_ext.h
 delete mode 100644 drivers/staging/csr/csr_framework_ext_types.h
 delete mode 100644 drivers/staging/csr/csr_log.h
 delete mode 100644 drivers/staging/csr/csr_log_configure.h
 delete mode 100644 drivers/staging/csr/csr_log_text.h
 delete mode 100644 drivers/staging/csr/csr_macro.h
 delete mode 100644 drivers/staging/csr/csr_msg_transport.h
 delete mode 100644 drivers/staging/csr/csr_msgconv.c
 delete mode 100644 drivers/staging/csr/csr_msgconv.h
 delete mode 100644 drivers/staging/csr/csr_prim_defs.h
 delete mode 100644 drivers/staging/csr/csr_result.h
 delete mode 100644 drivers/staging/csr/csr_sched.h
 delete mode 100644 drivers/staging/csr/csr_sdio.h
 delete mode 100644 drivers/staging/csr/csr_serialize_primitive_types.c
 delete mode 100644 drivers/staging/csr/csr_time.c
 delete mode 100644 drivers/staging/csr/csr_time.h
 delete mode 100644 drivers/staging/csr/csr_util.c
 delete mode 100644 drivers/staging/csr/csr_wifi_common.h
 delete mode 100644 drivers/staging/csr/csr_wifi_fsm.h
 delete mode 100644 drivers/staging/csr/csr_wifi_fsm_event.h
 delete mode 100644 drivers/staging/csr/csr_wifi_fsm_types.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_card.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_card_sdio.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_card_sdio.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_card_sdio_intr.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_card_sdio_mem.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_chiphelper.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_chiphelper.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_chiphelper_private.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_conversions.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_download.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_dump.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_packing.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_send.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_signals.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_signals.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_sigs.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_ta_sampling.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_ta_sampling.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_udi.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_unifi.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_unifi_signal_names.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_unifi_udi.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_unifihw.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_unifiversion.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_xbv.c
 delete mode 100644 drivers/staging/csr/csr_wifi_hip_xbv.h
 delete mode 100644 drivers/staging/csr/csr_wifi_hostio_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_msgconv.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_converter_init.c
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_converter_init.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_free_downstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_free_upstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_sef.c
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_sef.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_serialize.c
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_ap_serialize.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_converter_init.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_serialize.h
 delete mode 100644 drivers/staging/csr/csr_wifi_nme_task.h
 delete mode 100644 drivers/staging/csr/csr_wifi_private_common.h
 delete mode 100644 drivers/staging/csr/csr_wifi_result.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_converter_init.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_converter_init.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_converter_init.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_converter_init.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_free_downstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_free_upstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_sef.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_sef.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_serialize.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_ctrl_serialize.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_free_downstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_free_upstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_sef.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_sef.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_serialize.c
 delete mode 100644 drivers/staging/csr/csr_wifi_router_serialize.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_task.h
 delete mode 100644 drivers/staging/csr/csr_wifi_router_transport.c
 delete mode 100644 drivers/staging/csr/csr_wifi_serialize_primitive_types.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_ap_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_ap_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_converter_init.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_converter_init.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_free_downstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_free_upstream_contents.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_lib.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_prim.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_sef.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_sef.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_serialize.c
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_serialize.h
 delete mode 100644 drivers/staging/csr/csr_wifi_sme_task.h
 delete mode 100644 drivers/staging/csr/csr_wifi_vif_utils.h
 delete mode 100644 drivers/staging/csr/data_tx.c
 delete mode 100644 drivers/staging/csr/drv.c
 delete mode 100644 drivers/staging/csr/firmware.c
 delete mode 100644 drivers/staging/csr/inet.c
 delete mode 100644 drivers/staging/csr/init_hw.c
 delete mode 100644 drivers/staging/csr/io.c
 delete mode 100644 drivers/staging/csr/mlme.c
 delete mode 100644 drivers/staging/csr/monitor.c
 delete mode 100644 drivers/staging/csr/netdev.c
 delete mode 100644 drivers/staging/csr/os.c
 delete mode 100644 drivers/staging/csr/putest.c
 delete mode 100644 drivers/staging/csr/sdio_events.c
 delete mode 100644 drivers/staging/csr/sdio_mmc.c
 delete mode 100644 drivers/staging/csr/sdio_stubs.c
 delete mode 100644 drivers/staging/csr/sme_blocking.c
 delete mode 100644 drivers/staging/csr/sme_mgt.c
 delete mode 100644 drivers/staging/csr/sme_native.c
 delete mode 100644 drivers/staging/csr/sme_sys.c
 delete mode 100644 drivers/staging/csr/sme_userspace.c
 delete mode 100644 drivers/staging/csr/sme_userspace.h
 delete mode 100644 drivers/staging/csr/sme_wext.c
 delete mode 100644 drivers/staging/csr/ul_int.c
 delete mode 100644 drivers/staging/csr/unifi_clients.h
 delete mode 100644 drivers/staging/csr/unifi_config.h
 delete mode 100644 drivers/staging/csr/unifi_dbg.c
 delete mode 100644 drivers/staging/csr/unifi_event.c
 delete mode 100644 drivers/staging/csr/unifi_native.h
 delete mode 100644 drivers/staging/csr/unifi_os.h
 delete mode 100644 drivers/staging/csr/unifi_pdu_processing.c
 delete mode 100644 drivers/staging/csr/unifi_priv.h
 delete mode 100644 drivers/staging/csr/unifi_sme.c
 delete mode 100644 drivers/staging/csr/unifi_sme.h
 delete mode 100644 drivers/staging/csr/unifi_wext.h
 delete mode 100644 drivers/staging/csr/unifiio.h
 delete mode 100644 drivers/staging/csr/wext_events.c
