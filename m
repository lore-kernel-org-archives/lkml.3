Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaFVIU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:20:57 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36105 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaFVIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:20:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/42] Remove dummy and wrapper functions.
Date: Sun, 22 Jun 2014 13:49:20 +0530
Message-Id: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

navin patidar (42):
  staging: rtl8188eu: Remove dummy function odm_DynamicTxPower()
  staging: rtl8188eu: Remove dummy function CheckFwRsvdPageContent()
  staging: rtl8188eu: Remove dummy rtl8188e_GetHalODMVar() and its
    wrapper
  staging: rtl8188eu: Remove dummy rtl8188e_start_thread() and its
    wrapper
  staging: rtl8188eu: Remove dummy rtl8188e_stop_thread() and its
    wrapper
  staging: rtl8188eu: Remove dummy function Hal_InitChannelPlan()
  staging: rtl8188eu: Remove dummy rtl8188eu_free_xmit_priv() and its
    wrapper
  staging: rtl8188eu: Remove function _rtw_memset()
  staging: rtl8188eu: Remove rtw_mfree2d(), wrapper for kfree()
  staging: rtl8188eu: Remove unused function rtw_list_insert_head()
  staging: rtl8188eu: Remove rtw_list_insert_tail(), wrapper for
    list_add_tail()
  staging: rtl8188eu: Remove function rtw_end_of_queue_search()
  staging: rtl8188eu: Remove rtw_is_list_empty(), wrapper for
    list_emty()
  staging: rtl8188eu: Remove _rtw_init_listhead(), wrapper for
    INIT_LIST_HEAD()
  staging: rtl8188eu: Remove unused function rtw_sleep_schedulable()
  staging: rtl8188eu: Use kstrtoul() for string to long conversion
  staging: rtl8188eu:Remove rtw_zmalloc(), wrapper for kzalloc()
  staging: rtl8188eu: Remove unused function rtw_division64()
  staging: rtl8188eu: Remove unused function rtw_get_time_interval_ms()
  staging: rtl8188eu: osdep_service.h: Remove unused macro, enum and
    variables
  staging: rtl8188eu: Replace rtw_list_delete() with list_del_init()
  staging: rtl8188eu: osdep_service.c: Remove unused macro
  staging: rtl8188eu: Replace _rtw_queue_empty() with list_empty()
  staging: rtl8188eu: Replace _cancel_workitem_sync() with
    cancel_work_sync()
  staging: rtl8188eu: Remove unused inline function _RND512()
  staging: rtl8188eu: Replace _cancel_timer_ex() with del_timer_sync()
  staging: rtl8188eu: Use cpu_to_be32() instead of RTW_PUT_BE32()
  staging: rtl8188eu: Use cpu_to_be16() instead of RTW_PUT_BE16()
  staging: rtl8188eu: Use get_unaligned_be16() instead of
    RTW_GET_BE16()
  staging: rtl8188eu: Remove unused inline function bitshift()
  staging: rtl8188eu: Use get_unaligned_le16() instead of
    RTW_GET_LE16()
  staging: rtl8188eu: Use cpu_to_le16() insted of RTW_PUT_LE16()
  staging: rtl8188eu: osdep_service.h: Remove unused function
    definations
  staging: rtl8188eu: Remove unused inline function _RND256()
  staging: rtl8188eu: Use round_up() instead of _RND128()
  staging: rtl8188eu: Use round_up() instead of _RND8()
  staging: rtl8188eu: Use round_up() instead of _RND4()
  staging: rtl8188eu: osdep_service.h: Remove unused macros
  staging: rtl8188eu: Use round_up() instead of RND4()
  staging: rtl8188eu: Remove function thread_enter()
  staging: rtl8188eu: Remove function flush_signals_thread()
  staging: rtl8188eu: Replace _cancel_timer() with del_timer_sync()

 drivers/staging/rtl8188eu/core/rtw_ap.c           |   52 ++---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |  159 ++++++++--------
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   24 +--
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c    |   33 ++--
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   18 +-
 drivers/staging/rtl8188eu/core/rtw_led.c          |   52 ++---
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |   85 ++++-----
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |  188 +++++++++---------
 drivers/staging/rtl8188eu/core/rtw_mp.c           |   28 +--
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |  142 ++++++--------
 drivers/staging/rtl8188eu/core/rtw_recv.c         |   52 ++---
 drivers/staging/rtl8188eu/core/rtw_security.c     |   34 ++--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |   54 +++---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c    |    8 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |  115 ++++++------
 drivers/staging/rtl8188eu/hal/hal_com.c           |    2 +-
 drivers/staging/rtl8188eu/hal/hal_intf.c          |   29 ---
 drivers/staging/rtl8188eu/hal/odm.c               |   14 --
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c      |   12 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c       |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   21 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c   |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |   24 +--
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    7 +-
 drivers/staging/rtl8188eu/include/hal_intf.h      |   12 --
 drivers/staging/rtl8188eu/include/odm_precomp.h   |    1 -
 drivers/staging/rtl8188eu/include/osdep_service.h |  161 ----------------
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h  |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_xmit.h |    1 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h       |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |  209 +++++++++------------
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c     |    8 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |   18 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |  110 +----------
 drivers/staging/rtl8188eu/os_dep/recv_linux.c     |    4 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    4 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    8 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c     |    4 +-
 41 files changed, 638 insertions(+), 1071 deletions(-)

--
1.7.10.4

