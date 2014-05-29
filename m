Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaE2Eeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:34:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaE2Eem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/140] 3.14.5-stable review
Date: Wed, 28 May 2014 21:32:19 -0700
Message-Id: <20140529043049.661315084@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.5 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 31 04:30:12 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.5-rc1

Eric Dumazet <edumazet@google.com>
    net-gro: reset skb->truesize in napi_reuse_skb()

Li RongQing <roy.qing.li@gmail.com>
    ipv4: initialise the itag variable in __mkroute_input

Eric Dumazet <edumazet@google.com>
    ipv6: gro: fix CHECKSUM_COMPLETE support

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix an oops in tcindex filter

Steffen Klassert <steffen.klassert@secunet.com>
    ip_tunnel: Initialize the fallback device properly

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: fix local TT check for outgoing arp requests in DAT

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: increase orig refcount when storing ref in gw_node

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: fix reference counting imbalance while sending fragment

Marek Lindner <mareklindner@neomailbox.ch>
    batman-adv: fix indirect hard_iface NULL dereference

Eric Dumazet <edumazet@google.com>
    net: gro: make sure skb->cb[] initial content has not to be zero

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix out of range parameters for bond_intmax_tbl

Guenter Roeck <linux@roeck-us.net>
    net: phy: Don't call phy_resume if phy_init_hw failed

Cong Wang <cwang@twopensource.com>
    rtnetlink: wait for unregistering devices in rtnl_link_unregister()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix calculation of option len in ip6_append_data

Hannes Frederic Sowa <hannes@stressinduktion.org>
    net: avoid dependency of net_get_random_once on nop patching

Heiko Carstens <heiko.carstens@de.ibm.com>
    net: filter: s390: fix JIT address randomization

Alexei Starovoitov <ast@plumgrid.com>
    net: filter: x86: fix JIT address randomization

Simon Wunderlich <simon@open-mesh.com>
    batman-adv: fix removing neigh_ifinfo

Simon Wunderlich <simon@open-mesh.com>
    batman-adv: always run purge_orig_neighbors

Simon Wunderlich <simon@open-mesh.com>
    batman-adv: fix neigh reference imbalance

Simon Wunderlich <simon@open-mesh.com>
    batman-adv: fix neigh_ifinfo imbalance

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    neigh: set nud_state to NUD_INCOMPLETE when probing router reachability

Susant Sahani <susant@redhat.com>
    ip6_tunnel: fix potential NULL pointer dereference

Nikolay Aleksandrov <nikolay@redhat.com>
    sfc: fix calling of free_irq with already free vector

Peter Christensen <pch@ordbogen.com>
    macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Bjørn Mork <bjorn@mork.no>
    net: cdc_mbim: handle unaccelerated VLAN tagged frames

Sergey Popovich <popovich_sergei@mail.ru>
    ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Florian Westphal <fw@strlen.de>
    net: ipv6: send pkttoobig immediately if orig frag size > mtu

Florian Westphal <fw@strlen.de>
    net: ipv4: ip_forward: fix inverted local_df test

Bjørn Mork <bjorn@mork.no>
    net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock

Timo Teräs <timo.teras@iki.fi>
    ipv4: ip_tunnels: disable cache for nbma gre tunnels

Ying Cai <ycai@google.com>
    ip_tunnel: Set network header properly for IP_ECN_decapsulate()

Eyal Perry <eyalpe@mellanox.com>
    net/mlx4_core: Don't issue PCIe speed/width checks for VFs

Bjørn Mork <bjorn@mork.no>
    net: cdc_ncm: fix buffer overflow

Andy King <acking@vmware.com>
    vsock: Make transport the proto owner

John Fastabend <john.fastabend@gmail.com>
    net: sched: lock imbalance in hhf qdisc

Liu Yu <allanyuliu@tencent.com>
    tcp_cubic: fix the range of delayed_ack

Vlad Yasevich <vyasevic@redhat.com>
    Revert "macvlan : fix checksums error when we are in bridge mode"

Vlad Yasevich <vyasevic@redhat.com>
    mactap: Fix checksum errors for non-gso packets in bridge mode

Karl Heiss <kheiss@gmail.com>
    net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Retrans'.

Oliver Hartkopp <socketcan@hartkopp.net>
    slip: fix spinlock variant

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add a number of Dell devices

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add a number of CMOTech devices

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Alcatel L800MA

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Olivetti Olicard 500

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless MC7305/MC7355

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless MC73xx

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless EM7355

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: reset flowi4_oif parameter on route lookup

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Kumar Sundararajan <kumar@fb.com>
    ipv6: fib: fix fib dump restart

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Warn when interface's information won't fit in our packet

Andrew Lutomirski <luto@amacapital.net>
    net: Fix ns_capable check in sock_diag_put_filterinfo

Vlad Yasevich <vyasevic@redhat.com>
    net: sctp: cache auth_enable per endpoint

Ivan Vecera <ivecera@redhat.com>
    tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Fix lockdep warnings with stacked macvlan devices

Vlad Yasevich <vyasevic@redhat.com>
    vlan: Fix lockdep warning with stacked vlan devices.

Vlad Yasevich <vyasevic@redhat.com>
    net: Allow for more then a single subclass for netif_addr_lock

Vlad Yasevich <vyasevic@redhat.com>
    net: Find the nesting level of a given device by type.

dingtianhong <dingtianhong@huawei.com>
    vlan: Fix lockdep warning when vlan dev handle notification

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6_gre: don't allow to remove the fb_tunnel_dev

Vlad Yasevich <vyasevic@redhat.com>
    net: Start with correct mac_len in skb_network_protocol

Daniel Borkmann <dborkman@redhat.com>
    Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer"

Mathias Krause <minipli@googlemail.com>
    filter: prevent nla extensions to peek beyond the end of the message

Julian Anastasov <ja@ssi.bg>
    ipv4: return valid RTA_IIF on ip route get

Wang, Xiaoming <xiaoming.wang@intel.com>
    net: ipv4: current group_info should be put after using.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti: don't allow to add the same tunnel twice

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    gre: don't allow to add the same tunnel twice

Eric Dumazet <edumazet@google.com>
    ipv6: Limit mtu to 65575 bytes

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Fix double free and memory leak around br_allowed_ingress

Thomas Richter <tmricht@linux.vnet.ibm.com>
    bonding: Remove debug_fs files when module init fails

Florian Westphal <fw@strlen.de>
    net: core: don't account for udp header size when computing seglen

Dmitry Petukhov <dmgenp@gmail.com>
    l2tp: take PMTU from tunnel UDP socket

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: test if association is dead in sctp_wake_up_waiters

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: wake up all assocs if sndbuf policy is per socket

Steven Rostedt <rostedt@goodmis.org>
    drm/i915: Do not dereference pointers from ring buffer in evict event

Jani Nikula <jani.nikula@intel.com>
    drm/i915/tv: fix gen4 composite s-video tv-out

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix typo in spectre_golden_registers

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix endian swap on hawaii clear state buffer setup

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: call drm_edid_to_eld when we update the edid

Christian König <christian.koenig@amd.com>
    drm/radeon: clear needs_reset flag if IB test fails

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/qxl: unset a pointer in sync_obj_unref

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix query buffer locking order violation

Christopher Friedt <chrisfriedt@gmail.com>
    drm/vmwgfx: correct fb_fix_screeninfo.line_length

Eliad Peller <eliad@wizery.com>
    wl18xx: align event mailbox with current fw

Thomas Bächler <thomas@archlinux.org>
    fs: Don't return 0 from get_anon_bdev

Chris Mason <clm@fb.com>
    mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Tony Lindgren <tony@atomide.com>
    serial: omap: Fix missing pm_runtime_resume handling by simplifying code

Bjørn Mork <bjorn@mork.no>
    usb: option: add and update a number of CMOTech devices

Bjørn Mork <bjorn@mork.no>
    usb: option: add Alcatel L800MA

Bjørn Mork <bjorn@mork.no>
    usb: option: add Olivetti Olicard 500

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless MC7305/MC7355

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless MC73xx

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless EM7355

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix firmware download on big-endian machines

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix sysfs-attribute removal deadlock

Johan Hovold <jhovold@gmail.com>
    Revert "USB: serial: add usbid for dell wwan card to sierra.c"

Daniele Palmas <dnlplm@gmail.com>
    usb: option driver, add support for Telit UE910v2

Michele Baldessari <michele@acksyn.org>
    USB: serial: ftdi_sio: add id for Brainboxes serial cards

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix handling of missing bulk endpoints

Tristan Bruns <tristan@tristanbruns.de>
    USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Michael Ulbricht <michael.ulbricht@systec-electronic.com>
    USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Mel Gorman <mgorman@suse.de>
    mm: use paravirt friendly ops for NUMA hinting ptes

Mizuma, Masayoshi <m.mizuma@jp.fujitsu.com>
    mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    thp: close race between split and zap huge pages

Peter Foley <pefoley2@pefoley.com>
    init/Kconfig: move the trusted keyring config option to general setup

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Use rcu_dereference_sched() for trace event triggers

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing/uprobes: Fix uprobe_cpu_buffer memory leak

NeilBrown <neilb@suse.de>
    md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.

Hans de Goede <hdegoede@redhat.com>
    HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: core: do not scan constant input report

Derya <derya.kiran@yahoo.de>
    Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"

Vladimir Murzin <murzin.v@gmail.com>
    xen/events/fifo: correctly align bitops

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/spinlock: Don't enable them unconditionally.

Sachin Prabhu <sprabhu@redhat.com>
    cifs: Wait for writebacks to complete before attempting write.

Al Viro <viro@zeniv.linux.org.uk>
    don't bother with {get,put}_write_access() on non-regular files

John David Anglin <dave.anglin@bell.net>
    parisc: remove _STK_LIM_MAX override

Helge Deller <deller@gmx.de>
    parisc: fix epoll_pwait syscall on compat kernel

Helge Deller <deller@gmx.de>
    parisc: change value of SHMLBA from 0x00400000 to PAGE_SIZE

Viresh Kumar <viresh.kumar@linaro.org>
    tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()

Viresh Kumar <viresh.kumar@linaro.org>
    tick-sched: Don't call update_wall_time() when delta is lesser than tick_period

Viresh Kumar <viresh.kumar@linaro.org>
    tick-common: Fix wrong check in tick_check_replacement()

Jani Nikula <jani.nikula@intel.com>
    drm/i915: restore QUIRK_NO_PCH_PWM_ENABLE

Ilya Dryomov <ilya.dryomov@inktank.com>
    rbd: fix error paths in rbd_img_request_fill()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracepoint: Do not waste memory on mods with no tracepoints

Peter Zijlstra <peterz@infradead.org>
    x86,preempt: Fix preemption for i386

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set names cannot be larger than 15 bytes

Thomas Graf <tgraf@suug.ch>
    netfilter: Can't fail and free after table replacement

Roman Pen <r.peniaev@gmail.com>
    blktrace: fix accounting of partially completed requests

Andrey Vagin <avagin@openvz.org>
    netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Patrick McHardy <kaber@trash.net>
    netfilter: nf_tables: fix nft_cmp_fast failure on big endian for size < 4

Richard Guy Briggs <rgb@redhat.com>
    audit: convert PPIDs to the inital PID namespace.

Richard Guy Briggs <rgb@redhat.com>
    pid: get pid_t ppid of task in init_pid_ns

Steven Rostedt <rostedt@goodmis.org>
    tools lib traceevent: Fix memory leak in pretty_print()

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: remove WARN_ON from get_kernel_ns()

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: megaraid: missing bounds check in mimd_to_kioc()

James Bottomley <JBottomley@Parallels.com>
    SCSI: dual scan thread bug fix

James Bottomley <JBottomley@Parallels.com>
    scsi: fix our current target reap infrastructure


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/parisc/include/asm/shmparam.h             |   5 +-
 arch/parisc/include/uapi/asm/resource.h        |   1 -
 arch/parisc/kernel/cache.c                     |   3 +-
 arch/parisc/kernel/sys_parisc.c                |  14 ++--
 arch/parisc/kernel/syscall_table.S             |   2 +-
 arch/s390/net/bpf_jit_comp.c                   |   2 +-
 arch/x86/include/asm/preempt.h                 |  12 +++
 arch/x86/kvm/x86.c                             |   1 -
 arch/x86/net/bpf_jit_comp.c                    |   2 +-
 arch/x86/xen/spinlock.c                        |   5 +-
 block/blk-core.c                               |   2 +-
 drivers/block/rbd.c                            |   2 +-
 drivers/gpu/drm/i915/i915_drv.h                |   1 +
 drivers/gpu/drm/i915/i915_trace.h              |   4 +-
 drivers/gpu/drm/i915/intel_display.c           |  16 ++++
 drivers/gpu/drm/i915/intel_panel.c             |   4 +
 drivers/gpu/drm/i915/intel_tv.c                |   9 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                  |   1 +
 drivers/gpu/drm/radeon/cik.c                   |   6 +-
 drivers/gpu/drm/radeon/radeon_display.c        |   1 +
 drivers/gpu/drm/radeon/radeon_ring.c           |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c        |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |  22 +++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |   5 +-
 drivers/hid/hid-core.c                         |   5 +-
 drivers/hid/hid-ids.h                          |   3 +-
 drivers/hid/hid-microsoft.c                    |   4 -
 drivers/hid/usbhid/hid-quirks.c                |   1 +
 drivers/md/raid1.c                             |  17 +++-
 drivers/net/bonding/bond_main.c                |   1 +
 drivers/net/bonding/bond_options.c             |   1 +
 drivers/net/ethernet/broadcom/tg3.c            |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |   1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   6 +-
 drivers/net/ethernet/mellanox/mlx4/main.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |   1 -
 drivers/net/ethernet/sfc/nic.c                 |  14 ++--
 drivers/net/macvlan.c                          |  21 +++--
 drivers/net/macvtap.c                          |   9 ++
 drivers/net/phy/phy_device.c                   |   4 +-
 drivers/net/slip/slip.c                        |   6 +-
 drivers/net/usb/cdc_mbim.c                     |  57 +++++++++----
 drivers/net/usb/cdc_ncm.c                      |   2 +-
 drivers/net/usb/qmi_wwan.c                     |  28 +++++++
 drivers/net/wireless/ti/wl18xx/event.h         |  20 +++++
 drivers/scsi/megaraid/megaraid_mm.c            |   2 +
 drivers/scsi/scsi_scan.c                       | 112 ++++++++++++++++---------
 drivers/scsi/scsi_sysfs.c                      |  20 +++--
 drivers/tty/serial/omap-serial.c               |  29 ++++---
 drivers/usb/class/cdc-acm.c                    |  28 +++++--
 drivers/usb/serial/cp210x.c                    |   1 +
 drivers/usb/serial/ftdi_sio.c                  |  33 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h              |  37 ++++++++
 drivers/usb/serial/io_ti.c                     |  50 +++++++----
 drivers/usb/serial/option.c                    |  83 +++++++++++++++++-
 drivers/usb/serial/qcserial.c                  |   9 ++
 drivers/usb/serial/sierra.c                    |   1 -
 drivers/usb/serial/usb-serial.c                |   4 +-
 drivers/usb/serial/usb_wwan.c                  |   9 +-
 drivers/xen/events/events_fifo.c               |  41 ++++++---
 fs/cifs/cifsfs.c                               |  14 +++-
 fs/cifs/cifsglob.h                             |   8 ++
 fs/cifs/cifsproto.h                            |   3 +
 fs/cifs/file.c                                 |  31 ++++++-
 fs/cifs/misc.c                                 |  74 +++++++++++++++-
 fs/cifs/smb1ops.c                              |  11 +++
 fs/cifs/smb2misc.c                             |  18 +++-
 fs/cifs/smb2ops.c                              |  14 ++++
 fs/file_table.c                                |   4 +-
 fs/open.c                                      |  26 ++----
 fs/super.c                                     |   5 +-
 include/asm-generic/pgtable.h                  |  31 +++++--
 include/linux/if_macvlan.h                     |   1 +
 include/linux/if_vlan.h                        |   3 +-
 include/linux/net.h                            |  15 +---
 include/linux/netdevice.h                      |  18 +++-
 include/linux/preempt.h                        |   2 +
 include/linux/rtnetlink.h                      |   5 ++
 include/linux/sched.h                          |  20 ++++-
 include/linux/sock_diag.h                      |   2 +-
 include/linux/thread_info.h                    |   2 -
 include/net/af_vsock.h                         |   6 +-
 include/net/ip6_route.h                        |   5 ++
 include/net/netfilter/nf_conntrack_extend.h    |   4 +-
 include/net/netfilter/nf_tables_core.h         |  10 +++
 include/net/sctp/structs.h                     |  18 +++-
 include/scsi/scsi_device.h                     |   3 +-
 include/trace/events/block.h                   |  33 +++++++-
 init/Kconfig                                   |  24 +++---
 kernel/audit.c                                 |   4 +-
 kernel/auditsc.c                               |   2 +-
 kernel/time/tick-common.c                      |   2 +-
 kernel/time/tick-sched.c                       |   5 +-
 kernel/trace/blktrace.c                        |  20 +++--
 kernel/trace/trace_events_trigger.c            |   2 +-
 kernel/trace/trace_uprobe.c                    |   6 ++
 kernel/tracepoint.c                            |   6 ++
 mm/huge_memory.c                               |  13 ++-
 mm/hugetlb.c                                   |   1 +
 net/8021q/vlan.c                               |   1 +
 net/8021q/vlan_dev.c                           |  13 +--
 net/batman-adv/bat_iv_ogm.c                    |   2 +
 net/batman-adv/distributed-arp-table.c         |   3 +-
 net/batman-adv/fragmentation.c                 |  11 ++-
 net/batman-adv/gateway_client.c                |  11 ++-
 net/batman-adv/originator.c                    |  62 ++++++++++++--
 net/bridge/br_input.c                          |   2 +-
 net/bridge/br_netlink.c                        |  15 ++++
 net/bridge/br_vlan.c                           |   7 +-
 net/bridge/netfilter/ebtables.c                |   5 +-
 net/core/dev.c                                 |  56 ++++++++++++-
 net/core/filter.c                              |   6 +-
 net/core/neighbour.c                           |   4 +-
 net/core/net_namespace.c                       |   2 +-
 net/core/rtnetlink.c                           |  66 ++++++++++++---
 net/core/skbuff.c                              |  16 ++--
 net/core/sock_diag.c                           |   4 +-
 net/core/utils.c                               |   8 +-
 net/ipv4/fib_semantics.c                       |   2 +-
 net/ipv4/ip_forward.c                          |   4 +-
 net/ipv4/ip_gre.c                              |   2 +-
 net/ipv4/ip_tunnel.c                           |   6 +-
 net/ipv4/ip_vti.c                              |   2 +-
 net/ipv4/netfilter/arp_tables.c                |   6 +-
 net/ipv4/netfilter/ip_tables.c                 |   6 +-
 net/ipv4/ping.c                                |  15 +++-
 net/ipv4/route.c                               |   4 +-
 net/ipv4/tcp_cubic.c                           |   2 +-
 net/ipv6/ip6_fib.c                             |   3 +-
 net/ipv6/ip6_gre.c                             |  10 +++
 net/ipv6/ip6_offload.c                         |   6 +-
 net/ipv6/ip6_output.c                          |   8 +-
 net/ipv6/ip6_tunnel.c                          |   2 +-
 net/ipv6/netfilter/ip6_tables.c                |   6 +-
 net/ipv6/route.c                               |   5 +-
 net/ipv6/tcpv6_offload.c                       |   2 +-
 net/l2tp/l2tp_ppp.c                            |   4 +-
 net/netfilter/nf_tables_api.c                  |   3 +-
 net/netfilter/nf_tables_core.c                 |   3 +-
 net/netfilter/nft_cmp.c                        |   2 +-
 net/packet/diag.c                              |   2 +-
 net/sched/cls_tcindex.c                        |  30 ++++---
 net/sched/sch_hhf.c                            |  11 +--
 net/sctp/associola.c                           |  82 ++++++++++++++----
 net/sctp/auth.c                                |  17 ++--
 net/sctp/endpointola.c                         |   3 +-
 net/sctp/protocol.c                            |   7 +-
 net/sctp/sm_make_chunk.c                       |  32 +++----
 net/sctp/sm_sideeffect.c                       |   7 +-
 net/sctp/sm_statefuns.c                        |   8 +-
 net/sctp/socket.c                              | 102 +++++++++++++++-------
 net/sctp/sysctl.c                              |  36 +++++++-
 net/sctp/ulpevent.c                            |   8 +-
 net/vmw_vsock/af_vsock.c                       |  47 +++++------
 tools/lib/traceevent/event-parse.c             |   1 +
 156 files changed, 1546 insertions(+), 509 deletions(-)


