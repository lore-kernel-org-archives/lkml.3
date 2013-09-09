Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3IISvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:51:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [ 3.8.y.z extended stable ] Linux 3.8.13.9 stable review
Date: Mon,  9 Sep 2013 11:44:50 -0700
Message-Id: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.9 stable kernel.

This version contains 24 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.9 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/kernel/entry-armv.S                  |  3 ++
 arch/arm/kernel/fiq.c                         | 23 ++++++-----
 arch/powerpc/Kconfig                          |  1 +
 arch/powerpc/include/asm/page.h               | 10 +++++
 arch/powerpc/kernel/lparcfg.c                 | 32 +++++----------
 drivers/base/memory.c                         |  2 +
 drivers/gpu/drm/i915/i915_reg.h               |  2 +-
 drivers/gpu/drm/nouveau/nv40_pm.c             |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c           | 58 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++++
 drivers/net/wireless/ath/ath9k/main.c         |  3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c      |  2 +-
 drivers/tty/hvc/hvsi_lib.c                    |  4 +-
 include/linux/regmap.h                        |  1 +
 kernel/workqueue.c                            |  9 +++++
 mm/slab.h                                     |  2 +
 net/core/scm.c                                |  2 +-
 net/key/af_key.c                              |  1 +
 net/mac80211/ibss.c                           |  1 +
 net/sunrpc/xdr.c                              |  9 +++--
 sound/isa/opti9xx/opti92x-ad1848.c            |  8 +---
 sound/pci/hda/patch_hdmi.c                    |  3 ++
 sound/pci/hda/patch_realtek.c                 |  1 +
 23 files changed, 123 insertions(+), 66 deletions(-)

Al Viro (1):
      lparcfg: don't bother saving pointer to proc_dir_entry

Andrey Vagin (1):
      memcg: check that kmem_cache has memcg_params before accessing it

Andy Lutomirski (1):
      net: Check the correct namespace when spoofing pid over SCM_RIGHTS

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor

Chen Gang (1):
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Johannes Berg (1):
      mac80211: add missing channel context release

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Pali Rohár (1):
      drm/nouveau: fix reclocking on nv40

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Russell King (2):
      ARM: update FIQ support for relocation of vectors
      ARM: Fix FIQ code on VIVT CPUs

Stanislaw Gruszka (1):
      iwl4965: fix rfkill set state regression

Sujith Manoharan (1):
      ath9k: Enable PLL fix only for AR9340/AR9330

Takashi Iwai (3):
      ALSA: hda - Add inverted digital mic fixup for Acer Aspire One
      ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
      ALSA: opti9xx: Fix conflicting driver object name

Tejun Heo (1):
      workqueue: cond_resched() after processing each work item

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems
