Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3JKTf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:35:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3JKTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/39] 3.0.100-stable review
Date: Fri, 11 Oct 2013 12:34:44 -0700
Message-Id: <20131011193210.843963685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------
NOTE: This is going to be the next-to-last 3.0.x release that I do.
      You should be moving off to the 3.4.x or 3.10.x longterm kernels
      by now, and not use the 3.0.x kernel unless you have to for some
      reason.  If anyone has any problems with this, please let me know.
--------------------------------

This is the start of the stable review cycle for the 3.0.100 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 13 19:30:52 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.100-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.100-rc1

Olaf Hering <olaf@aepfle.de>
    Tools: hv: verify origin of netlink connector message

Kees Cook <keescook@chromium.org>
    tg3: fix length overflow in VPD firmware parsing

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid hang when mounting non-journal filesystems with orphan list

Josef Bacik <jbacik@fusionio.com>
    Btrfs: change how we queue blocks for backref checking

Chris Metcalf <cmetcalf@tilera.com>
    tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Lv Zheng <lv.zheng@intel.com>
    ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Align private space in rtl_priv struct

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

Neil Horman <nhorman@tuxdriver.com>
    bonding: Fix broken promiscuity reference counting issue

Peter Korsgaard <peter@korsgaard.com>
    dm9601: fix IFF_ALLMULTI handling

Roger Luethi <rl@hellgate.ch>
    via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: udp packets following an UFO enqueued packet need also be handled by UFO

Salam Noureddine <noureddine@aristanetworks.com>
    ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put

Salam Noureddine <noureddine@aristanetworks.com>
    ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Ansis Atteka <aatteka@nicira.com>
    ip: generate unique IP identificator if local fragmentation is allowed

Herbert Xu <herbert@gondor.apana.org.au>
    bridge: Clamp forward_delay when enabling STP

Chris Healy <cphealy@gmail.com>
    resubmit bridge: fix message_age_timer calculation

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Nikolay Aleksandrov <nikolay@redhat.com>
    netpoll: fix NULL pointer dereference in netpoll_cleanup

Dave Jones <davej@redhat.com>
    caif: Add missing braces to multiline if in cfctrl_linkup_request

Dan Carpenter <dan.carpenter@oracle.com>
    cciss: fix info leak in cciss_ioctl32_passthru()

Dan Carpenter <dan.carpenter@oracle.com>
    cpqarray: fix info leak in ida_locked_ioctl()

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Fix leaks in pagetable freeing


-------------

Diffstat:

 Makefile                                 |  4 +-
 arch/powerpc/kernel/iommu.c              |  2 +-
 arch/powerpc/kernel/vio.c                | 12 ++++--
 arch/powerpc/lib/checksum_64.S           | 58 ++++++++++++++++++-------
 arch/sparc/kernel/entry.S                |  2 +-
 arch/sparc/kernel/ktlb.S                 |  3 +-
 arch/sparc/kernel/syscalls.S             |  8 ++--
 arch/sparc/kernel/trampoline_64.S        |  2 -
 arch/sparc/lib/ksyms.c                   |  9 ----
 arch/tile/include/asm/percpu.h           | 34 +++++++++++++--
 drivers/acpi/acpi_ipmi.c                 | 24 ++++++-----
 drivers/block/cciss.c                    |  1 +
 drivers/block/cpqarray.c                 |  1 +
 drivers/net/bonding/bond_main.c          | 13 ++++--
 drivers/net/ll_temac_main.c              |  6 +++
 drivers/net/pptp.c                       |  2 +-
 drivers/net/tg3.c                        |  7 +++-
 drivers/net/usb/dm9601.c                 |  2 +-
 drivers/net/via-rhine.c                  |  9 +++-
 drivers/net/wireless/p54/p54usb.c        |  1 +
 drivers/net/wireless/rtlwifi/wifi.h      |  2 +-
 drivers/pci/intel-iommu.c                | 72 ++++++++++++++++----------------
 drivers/scsi/esp_scsi.c                  | 14 ++++---
 drivers/scsi/esp_scsi.h                  |  1 +
 drivers/staging/comedi/drivers/ni_65xx.c | 26 +++++-------
 drivers/staging/hv/tools/hv_kvp_daemon.c | 10 +++--
 drivers/usb/serial/option.c              |  3 ++
 fs/btrfs/relocation.c                    | 14 +++----
 fs/ext4/namei.c                          |  3 +-
 include/net/ip.h                         | 12 ++++--
 include/net/ipip.h                       |  2 +-
 kernel/kmod.c                            |  4 ++
 net/bridge/br_private.h                  |  1 +
 net/bridge/br_stp.c                      | 23 ++++++----
 net/bridge/br_stp_if.c                   | 12 +++++-
 net/caif/cfctrl.c                        |  3 +-
 net/core/netpoll.c                       |  9 ++--
 net/ipv4/igmp.c                          |  8 ++--
 net/ipv4/inetpeer.c                      |  4 +-
 net/ipv4/ip_output.c                     |  6 +--
 net/ipv4/ipmr.c                          |  2 +-
 net/ipv4/raw.c                           |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c             |  2 +-
 net/ipv6/ip6_output.c                    | 53 ++++++++++-------------
 net/ipv6/mcast.c                         |  4 +-
 net/netfilter/ipvs/ip_vs_xmit.c          |  2 +-
 net/sctp/ipv6.c                          | 42 ++++++-------------
 sound/soc/codecs/88pm860x-codec.c        |  3 ++
 sound/soc/codecs/max98095.c              |  4 +-
 49 files changed, 312 insertions(+), 231 deletions(-)


