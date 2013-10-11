Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3JKVDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:03:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab3JKTg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:36:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/48] 3.4.66-stable review
Date: Fri, 11 Oct 2013 12:36:07 -0700
Message-Id: <20131011193637.253208688@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.66 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 13 19:35:35 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.66-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.66-rc1

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid hang when mounting non-journal filesystems with orphan list

Josef Bacik <jbacik@fusionio.com>
    Btrfs: change how we queue blocks for backref checking

Chris Metcalf <cmetcalf@tilera.com>
    tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Lv Zheng <lv.zheng@intel.com>
    ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

David Rientjes <rientjes@google.com>
    mm, show_mem: suppress page counts in non-blockable contexts

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix callback path in tasklet

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Align private space in rtl_priv struct

Jack Wang <jinpu.wang@profitbricks.com>
    ib_srpt: always set response for task management

Nicholas Bellinger <nab@linux-iscsi.org>
    ib_srpt: Destroy cm_id before destroying QP.

Michal Malý <madcatxster@prifuk.cz>
    USB: serial: option: Ignore card reader interface on Huawei E1750

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kernel/kmod.c: check for NULL in call_usermodehelper_exec()

Kirill Tkhai <tkhai@yandex.ru>
    sparc32: Fix exit flag passed from traced sys_sigreturn

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall

David S. Miller <davem@davemloft.net>
    sparc64: Fix off by one in trampoline TLB mapping installation loop.

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Remove RWSEM export leftovers

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Fix ITLB handler of null page

David S. Miller <davem@davemloft.net>
    esp_scsi: Fix tag state corruption when autosensing.

Andre Guedes <andre.guedes@openbossa.org>
    Bluetooth: Fix encryption key size for peripheral role

Andre Guedes <andre.guedes@openbossa.org>
    Bluetooth: Fix security level for peripheral role

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    powerpc: Restore registers on error exit from csum_partial_copy_generic()

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    powerpc: Fix parameter clobber in csum_partial_copy_generic()

Prarit Bhargava <prarit@redhat.com>
    powerpc/vio: Fix modalias_show return values

Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
    powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: max98095: a couple array underflows

Ricardo Ribalda <ricardo.ribalda@gmail.com>
    ll_temac: Reset dma descriptors indexes on ndo_open

Salam Noureddine <noureddine@aristanetworks.com>
    ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Salam Noureddine <noureddine@aristanetworks.com>
    ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put

Neil Horman <nhorman@tuxdriver.com>
    bonding: Fix broken promiscuity reference counting issue

Peter Korsgaard <peter@korsgaard.com>
    dm9601: fix IFF_ALLMULTI handling

Roger Luethi <rl@hellgate.ch>
    via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: udp packets following an UFO enqueued packet need also be handled by UFO

Ansis Atteka <aatteka@nicira.com>
    ip: generate unique IP identificator if local fragmentation is allowed

Ansis Atteka <aatteka@nicira.com>
    ip: use ip_hdr() in __ip_make_skb() to retrieve IP header

Herbert Xu <herbert@gondor.apana.org.au>
    bridge: Clamp forward_delay when enabling STP

Chris Healy <cphealy@gmail.com>
    resubmit bridge: fix message_age_timer calculation

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Nikolay Aleksandrov <nikolay@redhat.com>
    netpoll: fix NULL pointer dereference in netpoll_cleanup

Eric Dumazet <edumazet@google.com>
    net: flow_dissector: fix thoff for IPPROTO_AH

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix smatch warning in sctp_send_asconf_del_ip

Dave Jones <davej@redhat.com>
    caif: Add missing braces to multiline if in cfctrl_linkup_request

Claudiu Manoil <claudiu.manoil@freescale.com>
    gianfar: Change default HW Tx queue scheduling mode

Dan Carpenter <dan.carpenter@oracle.com>
    cciss: fix info leak in cciss_ioctl32_passthru()

Dan Carpenter <dan.carpenter@oracle.com>
    cpqarray: fix info leak in ida_locked_ioctl()


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arm/mm/init.c                          |  3 ++
 arch/ia64/mm/contig.c                       |  2 +
 arch/ia64/mm/discontig.c                    |  2 +
 arch/parisc/mm/init.c                       |  2 +
 arch/powerpc/kernel/iommu.c                 |  2 +-
 arch/powerpc/kernel/vio.c                   | 12 ++++--
 arch/powerpc/lib/checksum_64.S              | 58 +++++++++++++++++++++--------
 arch/sparc/kernel/entry.S                   |  2 +-
 arch/sparc/kernel/ktlb.S                    |  3 +-
 arch/sparc/kernel/syscalls.S                |  8 ++--
 arch/sparc/kernel/trampoline_64.S           |  2 -
 arch/sparc/lib/ksyms.c                      |  9 -----
 arch/tile/include/asm/percpu.h              | 34 +++++++++++++++--
 arch/unicore32/mm/init.c                    |  3 ++
 drivers/acpi/acpi_ipmi.c                    | 24 +++++++-----
 drivers/block/cciss.c                       |  1 +
 drivers/block/cpqarray.c                    |  1 +
 drivers/dma/imx-dma.c                       | 31 ++++++++-------
 drivers/infiniband/ulp/srpt/ib_srpt.c       | 14 +++----
 drivers/net/bonding/bond_main.c             | 13 +++++--
 drivers/net/ethernet/freescale/gianfar.c    | 11 +++++-
 drivers/net/ethernet/freescale/gianfar.h    | 11 +++++-
 drivers/net/ethernet/via/via-rhine.c        |  9 ++++-
 drivers/net/ethernet/xilinx/ll_temac_main.c |  6 +++
 drivers/net/ppp/pptp.c                      |  2 +-
 drivers/net/usb/dm9601.c                    |  2 +-
 drivers/net/wireless/p54/p54usb.c           |  1 +
 drivers/net/wireless/rtlwifi/wifi.h         |  2 +-
 drivers/scsi/esp_scsi.c                     | 14 ++++---
 drivers/scsi/esp_scsi.h                     |  1 +
 drivers/staging/comedi/drivers/ni_65xx.c    | 26 ++++++-------
 drivers/usb/serial/option.c                 |  3 ++
 fs/btrfs/relocation.c                       | 14 +++----
 fs/ext4/namei.c                             |  3 +-
 include/linux/mm.h                          |  3 +-
 include/net/ip.h                            | 12 ++++--
 include/net/ipip.h                          |  2 +-
 kernel/kmod.c                               |  4 ++
 lib/show_mem.c                              |  3 ++
 mm/page_alloc.c                             |  7 ++++
 net/bluetooth/hci_event.c                   |  6 ++-
 net/bridge/br_private.h                     |  1 +
 net/bridge/br_stp.c                         | 23 ++++++++----
 net/bridge/br_stp_if.c                      | 12 +++++-
 net/caif/cfctrl.c                           |  3 +-
 net/core/flow_dissector.c                   |  4 +-
 net/core/netpoll.c                          |  9 ++---
 net/ipv4/igmp.c                             |  8 ++--
 net/ipv4/inetpeer.c                         |  4 +-
 net/ipv4/ip_output.c                        |  8 ++--
 net/ipv4/ipmr.c                             |  2 +-
 net/ipv4/raw.c                              |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c                |  2 +-
 net/ipv6/ip6_output.c                       | 53 +++++++++++---------------
 net/ipv6/mcast.c                            |  4 +-
 net/netfilter/ipvs/ip_vs_xmit.c             |  2 +-
 net/sctp/ipv6.c                             | 42 +++++++--------------
 net/sctp/socket.c                           |  3 ++
 sound/soc/codecs/88pm860x-codec.c           |  3 ++
 sound/soc/codecs/max98095.c                 |  4 +-
 61 files changed, 342 insertions(+), 219 deletions(-)


