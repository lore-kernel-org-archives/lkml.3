Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3EQW2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:28:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3EQVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/102] 3.9.3-stable review
Date: Fri, 17 May 2013 14:35:15 -0700
Message-Id: <20130517213244.277411019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.3 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 19 21:30:33 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.3-rc1

Andy Grover <agrover@redhat.com>
    target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio

Eric W. Biederman <ebiederm@xmission.com>
    audit: Make testing for a valid loginuid explicit.

Helge Deller <deller@gmx.de>
    parisc: make default cross compiler search more robust (v3)

Mike Frysinger <vapier@gentoo.org>
    parisc: fix NATIVE set up in build

John David Anglin <dave.anglin@bell.net>
    parisc: use long branch in fork_like macro

John David Anglin <dave.anglin@bell.net>
    parisc: fix SMP races when updating PTE and TLB entries in entry.S

John David Anglin <dave.anglin@bell.net>
    parisc: only re-enable interrupts if we need to schedule or deliver signals when returning to userspace

Oleg Nesterov <oleg@redhat.com>
    usermodehelper: check subprocess_info->path != NULL

Dave Airlie <airlied@redhat.com>
    drm/radeon: restore nomodeset operation (v2)

Kees Cook <keescook@chromium.org>
    drm/radeon: check incoming cliprects pointer

Axel Lin <axel.lin@ingics.com>
    ASoC: da7213: Fix setting dmic_samplephase and dmic_clk_rate

Benjamin LaHaise <bcrl@kvack.org>
    ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Chen Gang <gang.chen@asianux.com>
    drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Restart transaction even when the IBF flag set

Nicholas Bellinger <nab@linux-iscsi.org>
    target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression

Joern Engel <joern@logfs.org>
    target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

Shlomo Pongratz <shlomop@mellanox.com>
    iscsi-target: Fix processing of OOO commands

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: fix ffmpeg regression

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: use lowest requested max performance

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: remove idle time and duration from sample and calculations

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Inderpal Singh <inderpal.singh@linaro.org>
    ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

Geert Uytterhoeven <geert@linux-m68k.org>
    VSOCK: Drop bogus __init annotation from vsock_init_tables()

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: fix for deadlock when using automatic split-brain-recovery

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix memory leak

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set

Guenter Roeck <linux@roeck-us.net>
    watchdog: Fix race condition in registration code

Tomoya MORINAGA <tomoya.rohm@gmail.com>
    pch_dma: Use GFP_ATOMIC because called from interrupt context

Cong Wang <amwang@redhat.com>
    xfrm6: release dev before returning error

Amerigo Wang <amwang@redhat.com>
    ipv6,gre: do not leak info to user-space

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

Konstantin Khlebnikov <khlebnikov@openvz.org>
    net: frag, fix race conditions in LRU list maintenance

stephen hemminger <stephen@networkplumber.org>
    virtio: don't expose u16 in userspace api

Daniel Borkmann <dborkman@redhat.com>
    packet: tpacket_v3: do not trigger bug() on wrong header status

holger@eitzenberger.org <holger@eitzenberger.org>
    asix: fix BUG in receive path when lowering MTU

stephen hemminger <stephen@networkplumber.org>
    bridge: fix race with topology change timer

Bjørn Mork <bjorn@mork.no>
    net: vlan,ethtool: netdev_features_t is more than 32 bit

Patrick McHardy <kaber@trash.net>
    net: use netdev_features_t in skb_needs_linearize()

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: act_ipt forward compat with xtables

Matthew Whitehead <tedheadster@gmail.com>
    3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Yuchung Cheng <ycheng@google.com>
    tcp: reset timer after any SYNACK retransmit

Chen Gang <gang.chen@asianux.com>
    net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W

Gao feng <gaofeng@cn.fujitsu.com>
    net: tun: release the reference of tun device in tun_recvmsg

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix naming of MTD partitions for FPGA bitfiles

Eric Dumazet <edumazet@google.com>
    tcp: force a dst refcount when prequeue packet

Jani Nikula <jani.nikula@intel.com>
    drm/i915: clear the stolen fb before resuming

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: don't check modeset locks in panic handler

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/mm: fix dump table BUG

Christopher Harvey <charvey@matrox.com>
    drm/mgag200: Fix framebuffer base address programming

Christopher Harvey <charvey@matrox.com>
    drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: workaround connection regression on passive channel

Thommy Jakobsson <thommyj@gmail.com>
    B43: Handle DMA RX descriptor underrun

Chris Metcalf <cmetcalf@tilera.com>
    tile: support new Tilera hypervisor

Daniel Drake <dsd@laptop.org>
    mwifiex: fix setting of multicast filter

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix memory leak issue when driver unload

Bing Zhao <bzhao@marvell.com>
    mwifiex: clear is_suspended flag when interrupt is received early

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix key allocation error handling for powersave keys

Anton Blanchard <anton@au1.ibm.com>
    powerpc/kexec: Fix kexec when using VMX optimised memcpy

Robert Jennings <rcj@linux.vnet.ibm.com>
    powerpc: Bring all threads online prior to migration/hibernation

Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
    ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/microcode: Add local mutex to fix physical CPU hot-add deadlock

Lachlan McIlroy <lmcilroy@redhat.com>
    ext4: limit group search loop for non-extent files

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix leaks of filter preds

Thomas Gleixner <tglx@linutronix.de>
    tick: Cleanup NOHZ per cpu data on cpu down

Tirupathi Reddy <tirupath@codeaurora.org>
    timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

John Stultz <john.stultz@linaro.org>
    time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons

Jeff Layton <jlayton@redhat.com>
    audit: vfs: fix audit_inode call in O_CREAT case of do_last

Anton Blanchard <anton@samba.org>
    audit: Syscall rules are not applied to existing processes on non-x86

James Bottomley <JBottomley@Parallels.com>
    SCSI: sd: fix array cache flushing bug causing performance problems

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Li Zefan <lizefan@huawei.com>
    shm: fix null pointer deref when userspace specifies invalid hugepage size

Alexander van Heukelum <heukelum@fastmail.fm>
    x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)

Shuah Khan <shuah.khan@hp.com>
    hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Jeff Layton <jlayton@redhat.com>
    nfsd: fix oops when legacy_recdir_name_error is passed a -ENOENT error

J. Bruce Fields <bfields@redhat.com>
    nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Stanislaw Gruszka <sgruszka@redhat.com>
    sched: Avoid prev->stime underflow

Stanislaw Gruszka <sgruszka@redhat.com>
    Revert "math64: New div64_u64_rem helper"

Stanislaw Gruszka <sgruszka@redhat.com>
    sched: Do not account bogus utime

Stanislaw Gruszka <sgruszka@redhat.com>
    sched: Avoid cputime scaling overflow

Frederic Weisbecker <fweisbec@gmail.com>
    sched: Lower chances of cputime scaling overflow

Frederic Weisbecker <fweisbec@gmail.com>
    math64: New div64_u64_rem helper

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    dm cache: fix error return code in cache_create

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    dm snapshot: fix error return code in snapshot_ctr

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: avoid a possible __vmalloc deadlock

Mike Snitzer <snitzer@redhat.com>
    dm stripe: fix regression in stripe_width calculation

Mike Snitzer <snitzer@redhat.com>
    dm table: fix write same support

Viresh Kumar <viresh.kumar@linaro.org>
    DMA: OF: Check properties value before running be32_to_cpup() on it

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix 3.9 regression of EAPD init on Conexant codecs

Wang YanQing <udknight@gmail.com>
    ALSA: HDA: Fix Oops caused by dereference NULL pointer

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda - Don't set up active streams twice"

Bob Moore <robert.moore@intel.com>
    ACPICA: Fix possible buffer overflow during a field unit read operation

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    HID: reintroduce fix-up for certain Sony RF receivers

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulator: emulate SALC

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulator: emulate XLAT

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulator: emulate AAM

Gleb Natapov <gleb@redhat.com>
    KVM: VMX: fix halt emulation while emulating invalid guest sate


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/include/asm/cmpxchg.h               |   8 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h |   1 +
 arch/arm/mach-exynos/pmu.c                   |   5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |   4 +-
 arch/parisc/Makefile                         |  23 ++--
 arch/parisc/kernel/entry.S                   | 172 +++++++++++++++------------
 arch/powerpc/include/asm/rtas.h              |   2 +
 arch/powerpc/kernel/machine_kexec_64.c       |   4 +
 arch/powerpc/kernel/rtas.c                   | 113 ++++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c     |  22 ++++
 arch/tile/Kconfig                            |  14 ++-
 arch/tile/include/hv/hypervisor.h            |  27 ++++-
 arch/tile/kernel/head_32.S                   |   2 +-
 arch/tile/kernel/head_64.S                   |  12 +-
 arch/x86/Kconfig                             |   1 -
 arch/x86/include/asm/syscalls.h              |   4 +-
 arch/x86/kernel/microcode_intel_early.c      |   5 +-
 arch/x86/kernel/vm86_32.c                    |  38 +++---
 arch/x86/kvm/emulate.c                       |  42 ++++++-
 arch/x86/kvm/vmx.c                           |   6 +
 arch/x86/xen/enlighten.c                     |  15 +++
 drivers/acpi/acpica/exfldio.c                |  14 ++-
 drivers/acpi/ec.c                            |   4 +-
 drivers/block/drbd/drbd_main.c               |   1 +
 drivers/block/drbd/drbd_receiver.c           |   5 +-
 drivers/char/ipmi/ipmi_bt_sm.c               |   4 +-
 drivers/char/ipmi/ipmi_devintf.c             |  14 ++-
 drivers/cpufreq/intel_pstate.c               |  67 +++--------
 drivers/dma/of-dma.c                         |   8 +-
 drivers/dma/pch_dma.c                        |   2 +-
 drivers/gpu/drm/drm_crtc.c                   |   4 +
 drivers/gpu/drm/drm_mm.c                     |  34 +++---
 drivers/gpu/drm/i915/intel_fb.c              |  16 ++-
 drivers/gpu/drm/mgag200/mgag200_mode.c       |  69 +++++++----
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c          |  12 +-
 drivers/hid/hid-core.c                       |   1 +
 drivers/md/dm-bufio.c                        |  24 +++-
 drivers/md/dm-cache-target.c                 |   1 +
 drivers/md/dm-snap.c                         |   1 +
 drivers/md/dm-stripe.c                       |  11 +-
 drivers/md/dm-table.c                        |   2 +-
 drivers/net/ethernet/3com/3c509.c            |   2 +
 drivers/net/ethernet/3com/3c59x.c            |  27 +++--
 drivers/net/ethernet/sfc/mcdi.c              |   2 +-
 drivers/net/ethernet/tile/tilegx.c           |   2 +-
 drivers/net/macvlan.c                        |   7 +-
 drivers/net/tun.c                            |   7 +-
 drivers/net/usb/asix_common.c                |   3 +
 drivers/net/wireless/ath/ath9k/main.c        |   6 +-
 drivers/net/wireless/b43/dma.c               |  19 +++
 drivers/net/wireless/b43/dma.h               |   4 +-
 drivers/net/wireless/b43/main.c              |  43 +++----
 drivers/net/wireless/iwlegacy/4965-mac.c     |   3 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |   3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |   1 +
 drivers/net/wireless/mwifiex/main.c          |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  21 +---
 drivers/platform/x86/hp_accel.c              |   3 +-
 drivers/rtc/Kconfig                          |   2 -
 drivers/rtc/rtc-pcf2123.c                    |   1 +
 drivers/scsi/sd.c                            |  20 ++++
 drivers/scsi/sd.h                            |   1 +
 drivers/target/iscsi/iscsi_target_erl1.c     |   7 +-
 drivers/target/target_core_file.c            |  10 +-
 drivers/target/target_core_iblock.c          |   2 +
 drivers/target/target_core_transport.c       |  11 +-
 drivers/watchdog/watchdog_dev.c              |   3 +-
 fs/ext4/mballoc.c                            |   6 +-
 fs/namei.c                                   |   2 +-
 fs/nfsd/nfs4proc.c                           |  15 ++-
 fs/nfsd/nfs4recover.c                        |  12 +-
 include/linux/audit.h                        |   7 +-
 include/linux/kref.h                         |  33 +++++
 include/linux/time.h                         |   4 -
 include/net/inet_frag.h                      |   5 +-
 include/net/sock.h                           |  12 ++
 include/net/tcp.h                            |   1 +
 include/uapi/linux/audit.h                   |   1 +
 include/uapi/linux/if_cablemodem.h           |  12 +-
 include/uapi/linux/virtio_net.h              |   2 +-
 ipc/shm.c                                    |   8 +-
 kernel/auditfilter.c                         |  31 ++++-
 kernel/auditsc.c                             |   5 +-
 kernel/kmod.c                                |   5 +
 kernel/sched/cputime.c                       |  70 +++++++++--
 kernel/time/Kconfig                          |   5 -
 kernel/time/tick-sched.c                     |   2 +-
 kernel/timer.c                               |   2 +-
 kernel/trace/trace_events_filter.c           |   4 +
 mm/mmap.c                                    |   8 +-
 net/8021q/vlan_dev.c                         |   2 +-
 net/bridge/br_stp_timer.c                    |   2 +-
 net/core/dev.c                               |   2 +-
 net/core/ethtool.c                           |   2 +-
 net/core/sock.c                              |  12 --
 net/ipv4/inet_fragment.c                     |   1 +
 net/ipv4/tcp_minisocks.c                     |   7 +-
 net/ipv6/ip6_gre.c                           |   2 +
 net/ipv6/tcp_ipv6.c                          |  12 ++
 net/ipv6/udp.c                               |  13 +-
 net/ipv6/udp_impl.h                          |   2 +
 net/ipv6/udplite.c                           |   2 +-
 net/ipv6/xfrm6_policy.c                      |   4 +-
 net/mac802154/mac802154.h                    |   2 +-
 net/packet/af_packet.c                       |  53 ++++-----
 net/sched/act_ipt.c                          |  33 ++++-
 net/vmw_vsock/af_vsock.c                     |   2 +-
 sound/pci/hda/hda_codec.c                    |   7 +-
 sound/pci/hda/patch_conexant.c               |  17 ++-
 sound/soc/codecs/da7213.c                    |   8 +-
 sound/soc/codecs/wm8994.c                    |   1 +
 113 files changed, 1011 insertions(+), 458 deletions(-)


