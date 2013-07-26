Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3GZUsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:48:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3GZUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/79] 3.10.4-stable review
Date: Fri, 26 Jul 2013 13:46:50 -0700
Message-Id: <20130726204721.849052763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.4 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul 28 20:45:08 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.4-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix EAPD GPIO control for Sigmatel codecs

Eldad Zack <eldad@fogrefinery.com>
    ALSA: usb-audio: 6fire: return correct XRUN indication

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Remove NO_PRESENCE bit override for Dell 1420n Laptop

Thomas Gleixner <tglx@linutronix.de>
    hrtimers: Move SMP function call to thread context

David Jeffery <djeffery@redhat.com>
    lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Soeren Moch <smoch@web.de>
    media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Takashi Iwai <tiwai@suse.de>
    media: saa7134: Fix unlocked snd_pcm_stop() call

Liu ShuoX <shuox.liu@intel.com>
    PM / Sleep: avoid 'autosleep' in shutdown progress

Theodore Ts'o <tytso@mit.edu>
    ext4: fix error handling in ext4_ext_truncate()

Barry Grussling <barry@grussling.com>
    usb: cp210x support SEL C662 Vendor/Device

Sami Rahman <sami.rahman@mmbresearch.com>
    USB: cp210x: add MMB and PI ZigBee USB Device Support

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Mike Frysinger <vapier@gentoo.org>
    ARM: footbridge: fix overlapping PCI mappings

Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
    ARM: S3C24XX: Add missing clkdev entries for s3c2440 UART

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: Add ONYX 3G device support

Alexandr \\\"Sky\\\" Ivanov <alexandr.sky@gmail.com>
    USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Daniil Bolsun <dan.bolsun@gmail.com>
    USB: option: append Petatel NP10T device to GSM modems list

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Dan Williams <dcbw@redhat.com>
    usb: serial: option: add Olivetti Olicard 200

Bjørn Mork <bjorn@mork.no>
    usb: option: add TP-LINK MA260

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: blacklist ONDA MT689DC QMI interface

Markos Chandras <markos.chandras@imgtec.com>
    lib/Kconfig.debug: Restrict FRAME_POINTER for MIPS

Bjørn Mork <bjorn@mork.no>
    SCSI: megaraid_sas: fix memory leak if SGL has zero length entries

Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
    SCSI: mpt3sas: fix for kernel panic when driver loads with HBA conected to non LUN 0 configured expander

Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
    SCSI: mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned

Borislav Petkov <bp@suse.de>
    EDAC: Fix lockdep splat

Kent Overstreet <kmo@daterainc.com>
    bcache: Journal replay fix

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix GC_SECTORS_USED() calculation

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a sysfs splat on shutdown

Kent Overstreet <kmo@daterainc.com>
    bcache: Shutdown fix

Kent Overstreet <kmo@daterainc.com>
    bcache: Advertise that flushes are supported

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a dumb race

Miklos Szeredi <mszeredi@suse.cz>
    fuse: readdirplus: sanity checks

Miklos Szeredi <mszeredi@suse.cz>
    fuse: readdirplus: fix instantiate

Niels de Vos <ndevos@redhat.com>
    fuse: readdirplus: fix dentry leak

Ralf Baechle <ralf@linux-mips.org>
    RAPIDIO: IDT_GEN2: Fix build error.

Ralf Baechle <ralf@linux-mips.org>
    MIPS: Oceton: Fix build error.

Eric Dumazet <edumazet@google.com>
    vlan: fix a race in egress prio management

Eric Dumazet <edumazet@google.com>
    vlan: mask vlan prio bits

Jason Wang <jasowang@redhat.com>
    macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jason Wang <jasowang@redhat.com>
    tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Paolo Valente <paolo.valente@unimore.it>
    pkt_sched: sch_qfq: remove a source of high packet delay/jitter

Haiyang Zhang <haiyangz@microsoft.com>
    hyperv: Fix the NETIF_F_SG flag setting in netvsc

Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
    be2net: Fix to avoid hardware workaround when not needed

Eric Dumazet <edumazet@google.com>
    ipv4: set transport header earlier

Neil Horman <nhorman@tuxdriver.com>
    atl1e: unmap partially mapped skb on dma error and free skb

Neil Horman <nhorman@tuxdriver.com>
    atl1e: fix dma mapping warnings

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: only static routes qualify for equal cost multipathing

Alexander Duyck <alexander.h.duyck@intel.com>
    gre: Fix MTU sizing check for gretap tunnels

dingtianhong <dingtianhong@huawei.com>
    ifb: fix oops when loading the ifb failed

dingtianhong <dingtianhong@huawei.com>
    dummy: fix oops when loading the dummy failed

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix route selection if kernel is not compiled with CONFIG_IPV6_ROUTER_PREF

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    alx: fix lockdep annotation

Sasha Levin <sasha.levin@oracle.com>
    9p: fix off by one causing access violations and memory corruption

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: in case of link failure remove route directly instead of letting it expire

Jason Wang <jasowang@redhat.com>
    macvtap: correctly linearize skb when zerocopy is used

Jason Wang <jasowang@redhat.com>
    tuntap: correctly linearize skb when zerocopy is used

dingtianhong <dingtianhong@huawei.com>
    ifb: fix rcu_sched self-detected stalls

Dave Kleikamp <dave.kleikamp@oracle.com>
    sunvnet: vnet_port_remove must call unregister_netdev

Michael S. Tsirkin <mst@redhat.com>
    vhost-net: fix use-after-free in vhost_net_flush

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix race in RX VQ processing

Michael S. Tsirkin <mst@redhat.com>
    virtio: support unlocked queue poll

Jongsung Kim <neidhard.kim@lge.com>
    net/cadence/macb: fix bug/typo in extracting gem_irq_read_clear bit

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix memory leak when discarding scattered packets

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: rt6_check_neigh should successfully verify neigh if no NUD information are available

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data

Cong Wang <amwang@redhat.com>
    ipip: fix a regression in ioctl

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    l2tp: add missing .owner to struct pppox_proto

Pravin B Shelar <pshelar@nicira.com>
    ip_tunnels: Use skb-len to PMTU check.

Amerigo Wang <amwang@redhat.com>
    ipv6,mcast: always hold idev->lock before mca_lock

Cong Wang <amwang@redhat.com>
    vti: remove duplicated code to fix a memory leak

Cong Wang <amwang@redhat.com>
    gre: fix a regression in ioctl

Changli Gao <xiaosuo@gmail.com>
    net: Swap ver and type in pppoe_hdr

Dave Jones <davej@redhat.com>
    x25: Fix broken locking in ioctl error paths.

Eric Dumazet <eric.dumazet@gmail.com>
    neighbour: fix a race in neigh_destroy()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: only apply anti-spoofing checks to not-pointopoint tunnels

Olivier DANET <odanet@caramail.com>
    sparc32: vm_area_struct access for old Sun SPARCs.

Jan Kara <jack@suse.cz>
    writeback: Fix periodic writeback after fs mount


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/mach-footbridge/dc21285.c              |   2 -
 arch/arm/mach-s3c24xx/clock-s3c2410.c           | 161 ++++++++++++++----------
 arch/arm/mach-s3c24xx/clock-s3c2440.c           |   3 +
 arch/arm/plat-samsung/include/plat/clock.h      |   5 +
 arch/mips/cavium-octeon/setup.c                 |   3 +-
 arch/sparc/kernel/asm-offsets.c                 |   2 +
 arch/sparc/mm/hypersparc.S                      |   8 +-
 arch/sparc/mm/swift.S                           |   8 +-
 arch/sparc/mm/tsunami.S                         |   6 +-
 arch/sparc/mm/viking.S                          |  10 +-
 drivers/edac/edac_mc.c                          |   9 ++
 drivers/edac/edac_mc_sysfs.c                    |  28 +++--
 drivers/edac/i5100_edac.c                       |   2 +-
 drivers/md/bcache/bcache.h                      |   1 +
 drivers/md/bcache/btree.c                       |   4 +-
 drivers/md/bcache/closure.c                     |   6 +-
 drivers/md/bcache/journal.c                     |   7 +-
 drivers/md/bcache/request.c                     |   8 +-
 drivers/md/bcache/super.c                       |  31 +++--
 drivers/media/dvb-core/dmxdev.c                 |   8 +-
 drivers/media/pci/saa7134/saa7134-alsa.c        |   2 +
 drivers/net/dummy.c                             |   4 +
 drivers/net/ethernet/atheros/alx/main.c         |   5 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++-
 drivers/net/ethernet/cadence/macb.c             |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |  14 ++-
 drivers/net/ethernet/sfc/rx.c                   |  27 ++--
 drivers/net/ethernet/sun/sunvnet.c              |   2 +
 drivers/net/hyperv/netvsc_drv.c                 |   4 +-
 drivers/net/ifb.c                               |   8 +-
 drivers/net/macvtap.c                           |  66 ++++++----
 drivers/net/tun.c                               |  69 ++++++----
 drivers/net/virtio_net.c                        |   5 +-
 drivers/rapidio/switches/idt_gen2.c             |   2 +
 drivers/scsi/megaraid/megaraid_sas_base.c       |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |  30 +++--
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/option.c                     |  23 ++--
 drivers/vhost/net.c                             |   9 +-
 drivers/virtio/virtio_ring.c                    |  56 +++++++--
 fs/block_dev.c                                  |   9 +-
 fs/ext4/extents.c                               |  11 ++
 fs/fuse/dir.c                                   |  40 ++++--
 fs/lockd/svclock.c                              |   4 +
 include/linux/edac.h                            |   7 +-
 include/linux/if_vlan.h                         |   3 +-
 include/linux/virtio.h                          |   4 +
 include/net/addrconf.h                          |   3 +
 include/net/udp.h                               |   1 +
 include/uapi/linux/if_pppox.h                   |   4 +-
 kernel/hrtimer.c                                |  28 ++---
 kernel/power/autosleep.c                        |   3 +-
 lib/Kconfig.debug                               |   2 +-
 net/8021q/vlan_core.c                           |   2 +-
 net/8021q/vlan_dev.c                            |   7 ++
 net/9p/trans_common.c                           |  10 +-
 net/core/dev.c                                  |  11 +-
 net/core/neighbour.c                            |  12 +-
 net/ipv4/ip_gre.c                               |   9 +-
 net/ipv4/ip_input.c                             |   7 +-
 net/ipv4/ip_tunnel.c                            |  97 +++++++-------
 net/ipv4/ip_vti.c                               |   7 --
 net/ipv4/ipip.c                                 |  12 +-
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/addrconf.c                             |  28 +++--
 net/ipv6/ip6_fib.c                              |  15 ++-
 net/ipv6/ip6_output.c                           |  16 ++-
 net/ipv6/mcast.c                                |  18 +--
 net/ipv6/route.c                                |  70 +++++++----
 net/ipv6/sit.c                                  |   2 +-
 net/ipv6/udp.c                                  |   7 +-
 net/l2tp/l2tp_ppp.c                             |   3 +-
 net/sched/sch_qfq.c                             |  85 ++++++++-----
 net/x25/af_x25.c                                |  15 +--
 sound/pci/hda/patch_sigmatel.c                  |  13 +-
 sound/usb/6fire/pcm.c                           |   2 +-
 77 files changed, 840 insertions(+), 438 deletions(-)


