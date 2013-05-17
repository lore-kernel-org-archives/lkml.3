Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3EQVua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab3EQVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/33] 3.0.79-stable review
Date: Fri, 17 May 2013 14:49:44 -0700
Message-Id: <20130517214916.821259930@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.79 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 19 21:47:48 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.79-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.79-rc1

Oleg Nesterov <oleg@redhat.com>
    usermodehelper: check subprocess_info->path != NULL

Kees Cook <keescook@chromium.org>
    drm/radeon: check incoming cliprects pointer

Benjamin LaHaise <bcrl@kvack.org>
    ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Chen Gang <gang.chen@asianux.com>
    drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Restart transaction even when the IBF flag set

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: fix for deadlock when using automatic split-brain-recovery

Francois Romieu <romieu@fr.zoreil.com>
    r8169: fix vlan tag read ordering.

Tomoya MORINAGA <tomoya.rohm@gmail.com>
    pch_dma: Use GFP_ATOMIC because called from interrupt context

Cong Wang <amwang@redhat.com>
    xfrm6: release dev before returning error

Eric Dumazet <edumazet@google.com>
    ipv6: do not clear pinet6 field

Jiri Pirko <jiri@resnulli.us>
    macvlan: fix passthru mode race between dev removal and rx path

Josh Boyer <jwboyer@redhat.com>
    if_cablemodem.h: Add parenthesis around ioctl macros

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    3c59x: fix PCI resource management

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    3c59x: fix freeing nonexistent resource on driver unload

stephen hemminger <stephen@networkplumber.org>
    bridge: fix race with topology change timer

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: act_ipt forward compat with xtables

Matthew Whitehead <tedheadster@gmail.com>
    3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Eric Dumazet <edumazet@google.com>
    tcp: force a dst refcount when prequeue packet

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/mm: fix dump table BUG

Daniel Drake <dsd@laptop.org>
    mwifiex: fix setting of multicast filter

Bing Zhao <bzhao@marvell.com>
    mwifiex: clear is_suspended flag when interrupt is received early

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix key allocation error handling for powersave keys

Lachlan McIlroy <lmcilroy@redhat.com>
    ext4: limit group search loop for non-extent files

Thomas Gleixner <tglx@linutronix.de>
    tick: Cleanup NOHZ per cpu data on cpu down

Tirupathi Reddy <tirupath@codeaurora.org>
    timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

James Bottomley <JBottomley@Parallels.com>
    SCSI: sd: fix array cache flushing bug causing performance problems

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    dm snapshot: fix error return code in snapshot_ctr

Bob Moore <robert.moore@intel.com>
    ACPICA: Fix possible buffer overflow during a field unit read operation

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Gleb Natapov <gleb@redhat.com>
    KVM: VMX: fix halt emulation while emulating invalid guest sate


-------------

Diffstat:

 Makefile                                     |  4 ++--
 arch/arm/mach-omap2/board-rx51-peripherals.c |  4 ++--
 arch/x86/kvm/vmx.c                           |  6 +++++
 arch/x86/xen/enlighten.c                     | 15 ++++++++++++
 drivers/acpi/acpica/exfldio.c                | 14 +++++++++++-
 drivers/acpi/ec.c                            |  4 +---
 drivers/block/drbd/drbd_receiver.c           |  1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |  4 ++--
 drivers/char/ipmi/ipmi_devintf.c             | 14 +++++++++++-
 drivers/dma/pch_dma.c                        |  2 +-
 drivers/gpu/drm/drm_mm.c                     | 34 +++++++++++++++-------------
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |  2 +-
 drivers/md/dm-snap.c                         |  1 +
 drivers/net/3c509.c                          |  2 ++
 drivers/net/3c59x.c                          | 27 +++++++++++-----------
 drivers/net/macvlan.c                        |  7 +++---
 drivers/net/r8169.c                          | 13 +++++------
 drivers/net/wireless/ath/ath9k/main.c        |  6 ++++-
 drivers/net/wireless/mwifiex/cmdevt.c        |  1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 21 +++++------------
 drivers/rtc/rtc-pcf2123.c                    |  1 +
 drivers/scsi/sd.c                            | 20 ++++++++++++++++
 drivers/scsi/sd.h                            |  1 +
 fs/ext4/mballoc.c                            |  6 ++++-
 include/linux/if_cablemodem.h                | 12 +++++-----
 include/linux/rculist.h                      | 17 ++++++++++++++
 include/net/sock.h                           | 12 ++++++++++
 include/net/tcp.h                            |  1 +
 kernel/kmod.c                                |  5 ++++
 kernel/time/tick-sched.c                     |  2 +-
 kernel/timer.c                               |  2 +-
 net/bridge/br_stp_timer.c                    |  2 +-
 net/core/sock.c                              | 12 ----------
 net/ipv6/tcp_ipv6.c                          | 12 ++++++++++
 net/ipv6/udp.c                               | 13 ++++++++++-
 net/ipv6/udp_impl.h                          |  2 ++
 net/ipv6/udplite.c                           |  2 +-
 net/ipv6/xfrm6_policy.c                      |  4 +++-
 net/sched/act_ipt.c                          | 33 ++++++++++++++++++++++++---
 sound/soc/codecs/wm8994.c                    |  1 +
 40 files changed, 245 insertions(+), 97 deletions(-)


