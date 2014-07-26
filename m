Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaGZTC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:02:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaGZTCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/56] 3.10.50-stable review
Date: Sat, 26 Jul 2014 12:01:53 -0700
Message-Id: <20140726190200.061512159@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.50 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jul 28 19:01:50 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.50-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.50-rc1

Anton Kolesov <Anton.Kolesov@synopsys.com>
    ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Mateusz Guzik <mguzik@redhat.com>
    sched: Fix possible divide by zero in avg_atom() calculation

Peter Zijlstra <peterz@infradead.org>
    locking/mutex: Disable optimistic spinning on some architectures

Takashi Iwai <tiwai@suse.de>
    PM / sleep: Fix request_firmware() error at resume

Mike Snitzer <snitzer@redhat.com>
    dm cache metadata: do not allow the data block size to change

Mike Snitzer <snitzer@redhat.com>
    dm thin metadata: do not allow the data block size to change

John Stultz <john.stultz@linaro.org>
    alarmtimer: Fix bug where relative alarm timers were treated as absolute

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: avoid leaking edid data

Jason Wang <jasowang@redhat.com>
    drm/qxl: return IRQ_NONE if it was not our irq

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: set default bl level to something reasonable

Tomasz Figa <t.figa@samsung.com>
    irqchip: gic: Fix core ID calculation when topology is read from DT

Matthias Brugger <matthias.bgg@gmail.com>
    irqchip: gic: Add support for cortex a7 compatible string

Martin Lau <kafai@fb.com>
    ring-buffer: Fix polling on trace_pipe

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix Tx timeout issue

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
    perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Eric Dumazet <edumazet@google.com>
    ipv4: fix buffer overflow in ip_options_compile()

Ben Hutchings <ben@decadent.org.uk>
    dns_resolver: Null-terminate the right string

Manuel Schölling <manuel.schoelling@gmx.de>
    dns_resolver: assure that dns_query() result is null-terminated

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    sunvnet: clean up objects created in vnet_new() on vnet_exit()

Christoph Schulz <develop@kristov.de>
    net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix information leaks in ulpevent layer

Jon Paul Maloy <jon.maloy@ericsson.com>
    tipc: clear 'next'-pointer of message fragments before reassembly

Suresh Reddy <Suresh.Reddy@emulex.com>
    be2net: set EQ DB clear-intr bit in be_open()

Ben Pfaff <blp@nicira.com>
    netlink: Fix handling of error from netlink_dump().

Thomas Fitzsimmons <fitzsim@fitzsim.org>
    net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: fix operation in 10 Mbit/s mode

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    appletalk: Fix socket referencing in skb

Yuchung Cheng <ycheng@google.com>
    tcp: fix false undo corner cases

dingtianhong <dingtianhong@huawei.com>
    igmp: fix the problem when mc leave group

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add two Sierra Wireless/Netgear devices

Bernd Wachter <bernd.wachter@jolla.com>
    net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Edward Allcutt <edward.allcutt@openmarket.com>
    ipv4: icmp: Fix pMTU handling for rare case

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix divide by zero when pushing during tcp-repair

Eric Dumazet <edumazet@google.com>
    bnx2x: fix possible panic under memory stress

Eric Dumazet <edumazet@google.com>
    net: fix sparse warning in sk_dst_set()

Eric Dumazet <edumazet@google.com>
    ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix

Eric Dumazet <edumazet@google.com>
    ipv4: fix dst race in sk_dst_get()

Li RongQing <roy.qing.li@gmail.com>
    8021q: fix a potential memory leak

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: check proc_dointvec result in proc_sctp_do_auth

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Dmitry Popov <ixaphire@qrator.net>
    ip_tunnel: fix ip_tunnel_lookup

Hugh Dickins <hughd@google.com>
    shmem: fix splicing from a hole while it's punched

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole, not taking i_mutex

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole while it's punched

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: don't enable CTS to self

Stefan Assmann <sassmann@kpanic.de>
    igb: do a reset on SR-IOV re-init if device is down

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adt7470) Fix writes to temperature limit registers

Axel Lin <axel.lin@ingics.com>
    hwmon: (da9052) Don't use dash in the name attribute

Axel Lin <axel.lin@ingics.com>
    hwmon: (da9055) Don't use dash in the name attribute

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix graph tracer with stack tracer on other archs

Miklos Szeredi <mszeredi@suse.cz>
    fuse: handle large user and group ID

Loic Poulain <loic.poulain@intel.com>
    Bluetooth: Ignore H5 non-link packets in non-active state

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: util: Fix a bug in the KVP code

Hans de Goede <hdegoede@redhat.com>
    media: gspca_pac7302: Add new usb-id for Genius i-Look 317

Gavin Guo <gavin.guo@canonical.com>
    usb: Check if port status is equal to RxDetect


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arc/include/uapi/asm/ptrace.h              |   1 +
 arch/arc/kernel/ptrace.c                        |   4 +
 arch/arm/Kconfig                                |   1 +
 arch/arm64/Kconfig                              |   1 +
 arch/powerpc/Kconfig                            |   1 +
 arch/sparc/Kconfig                              |   1 +
 arch/x86/Kconfig                                |   1 +
 arch/x86/kernel/cpu/perf_event_intel.c          |   9 ++
 drivers/bluetooth/hci_h5.c                      |   1 +
 drivers/gpu/drm/qxl/qxl_irq.c                   |   3 +
 drivers/gpu/drm/radeon/atombios_encoders.c      |  10 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   5 +
 drivers/hv/hv_kvp.c                             |  14 ++-
 drivers/hv/hv_util.c                            |   2 +-
 drivers/hwmon/adt7470.c                         |   6 +-
 drivers/hwmon/da9052-hwmon.c                    |   2 +-
 drivers/hwmon/da9055-hwmon.c                    |   2 +-
 drivers/irqchip/irq-gic.c                       |   6 +-
 drivers/md/dm-cache-metadata.c                  |   9 ++
 drivers/md/dm-thin-metadata.c                   |   9 ++
 drivers/media/usb/gspca/pac7302.c               |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c       |   2 +
 drivers/net/ethernet/marvell/mvneta.c           |   4 +-
 drivers/net/ethernet/sun/sunvnet.c              |  20 +++-
 drivers/net/ppp/pppoe.c                         |   2 +-
 drivers/net/usb/qmi_wwan.c                      |   3 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 ---
 drivers/net/wireless/mwifiex/main.c             |   1 +
 drivers/usb/core/hub.c                          |  19 ++++
 fs/fuse/inode.c                                 |  20 +++-
 include/net/sock.h                              |  16 ++--
 kernel/Kconfig.locks                            |   5 +-
 kernel/power/process.c                          |   1 +
 kernel/sched/debug.c                            |   2 +-
 kernel/time/alarmtimer.c                        |  20 +++-
 kernel/trace/ftrace.c                           |   4 +-
 kernel/trace/ring_buffer.c                      |   4 -
 kernel/trace/trace.c                            |  12 ++-
 mm/shmem.c                                      | 104 +++++++++++++++++---
 net/8021q/vlan_core.c                           |   5 +-
 net/appletalk/ddp.c                             |   3 -
 net/core/dst.c                                  |  16 +++-
 net/dns_resolver/dns_query.c                    |   4 +-
 net/ipv4/icmp.c                                 |   2 -
 net/ipv4/igmp.c                                 |  10 +-
 net/ipv4/ip_options.c                           |   4 +
 net/ipv4/ip_tunnel.c                            |  12 ++-
 net/ipv4/route.c                                |  15 +--
 net/ipv4/tcp.c                                  |   3 +-
 net/ipv4/tcp_input.c                            |  10 +-
 net/ipv4/tcp_output.c                           |   6 +-
 net/netlink/af_netlink.c                        |   4 +-
 net/sctp/sysctl.c                               |   3 +-
 net/sctp/ulpevent.c                             | 122 +++---------------------
 net/tipc/bcast.c                                |   1 +
 58 files changed, 355 insertions(+), 214 deletions(-)


