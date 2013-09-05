Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3IEUqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:46:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3IEU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/36] 3.10.11-stable review
Date: Thu,  5 Sep 2013 13:27:29 -0700
Message-Id: <20130905202702.289738686@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.11 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.11-rc1

David Jander <david@protonic.nl>
    regmap: rbtree: Fix overlapping rbnodes.

Fabio Estevam <fabio.estevam@freescale.com>
    imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id

Julien Grall <julien.grall@linaro.org>
    xen/arm: missing put_cpu in xen_percpu_init

Mark Rusk <Mark.Rusk@hp.com>
    drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Wei Hu <wei@aristanetworks.com>
    hwmon: (k10temp) Add support for Fam16h (Kabini)

Graham Williams <gwilli@broadcom.com>
    usb: acm gadget: Null termintate strings table

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix hardware reset flow

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_transport reference leak during NP thread reset

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix trailing ASCII space usage in INQUIRY vendor+model

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: fix rfkill set state regression

Felix Fietkau <nbd@openwrt.org>
    mac80211: add a flag to indicate CCK support for HT clients

Johannes Berg <johannes.berg@intel.com>
    mac80211: add missing channel context release

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Enable PLL fix only for AR9340/AR9330

Helmut Schaa <helmut.schaa@googlemail.com>
    ath9k_htc: Restore skb headroom when returning skb to mac80211

Yinghai Lu <yinghai@kernel.org>
    x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=y and more than 512G RAM

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Imre Deak <imre.deak@intel.com>
    drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz <jakob@vmware.com>
    drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Tejun Heo <tj@kernel.org>
    workqueue: cond_resched() after processing each work item

Andrey Vagin <avagin@openvz.org>
    memcg: check that kmem_cache has memcg_params before accessing it

Russ Anderson <rja@sgi.com>
    drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Svenning Soerensen <sss@secomea.dk>
    IPC: bugfix for msgrcv with msgtyp < 0

Nathan Zimmer <nzimmer@sgi.com>
    timer_list: correct the iterator for timer_list

Kevin Hilman <khilman@linaro.org>
    regmap: Add another missing header for !CONFIG_REGMAP stubs

Hans Verkuil <hverkuil@xs4all.nl>
    SCSI: pm80xx: fix Adaptec 71605H hang

Eugene Surovegin <ebs@ebshome.net>
    powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor

Paul Mackerras <paulus@samba.org>
    powerpc: Work around gcc miscompilation of __pa() on 64-bit

Takashi Iwai <tiwai@suse.de>
    ALSA: opti9xx: Fix conflicting driver object name

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add inverted digital mic fixup for Acer Aspire One

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix readdir cookie incompatibility with NFSv4

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/mc: fix race condition between constructor and request_irq()


-------------

Diffstat:

 Documentation/hwmon/k10temp                      |  1 +
 Makefile                                         |  4 +-
 arch/arm/xen/enlighten.c                         |  1 +
 arch/powerpc/Kconfig                             |  1 +
 arch/powerpc/include/asm/page.h                  | 10 ++++
 arch/powerpc/kernel/lparcfg.c                    | 22 ++++-----
 arch/x86/mm/init.c                               |  4 +-
 drivers/acpi/ec.c                                |  4 ++
 drivers/base/memory.c                            |  2 +
 drivers/base/regmap/regcache-rbtree.c            |  2 +-
 drivers/gpu/drm/i915/i915_reg.h                  |  2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h |  7 +--
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c    |  6 ++-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c    |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c              | 58 ++++++++++++++++--------
 drivers/hwmon/Kconfig                            |  4 +-
 drivers/hwmon/k10temp.c                          |  3 +-
 drivers/misc/hpilo.c                             |  4 +-
 drivers/misc/mei/hw-me.c                         |  8 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c    | 10 ++++
 drivers/net/wireless/ath/ath9k/init.c            |  3 +-
 drivers/net/wireless/ath/ath9k/main.c            |  3 +-
 drivers/net/wireless/ath/carl9170/main.c         |  3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c         |  2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c          |  3 +-
 drivers/scsi/pm8001/pm8001_hwi.c                 |  4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                 |  4 +-
 drivers/staging/imx-drm/imx-drm-core.c           |  1 +
 drivers/target/iscsi/iscsi_target.c              | 17 ++++---
 drivers/target/iscsi/iscsi_target_login.c        |  9 ++--
 drivers/target/target_core_spc.c                 |  9 ++--
 drivers/tty/hvc/hvsi_lib.c                       |  4 +-
 drivers/usb/gadget/f_acm.c                       |  1 +
 fs/jfs/jfs_dtree.c                               | 31 +++++++++----
 include/linux/regmap.h                           |  1 +
 include/net/mac80211.h                           |  1 +
 ipc/msg.c                                        |  5 +-
 kernel/time/timer_list.c                         | 41 ++++++++++-------
 kernel/workqueue.c                               |  9 ++++
 mm/slab.h                                        |  2 +
 net/mac80211/ibss.c                              |  1 +
 net/mac80211/rc80211_minstrel_ht.c               |  3 ++
 net/sunrpc/xdr.c                                 |  9 ++--
 sound/isa/opti9xx/opti92x-ad1848.c               |  8 +---
 sound/pci/hda/patch_hdmi.c                       |  3 ++
 sound/pci/hda/patch_realtek.c                    |  1 +
 50 files changed, 221 insertions(+), 125 deletions(-)


