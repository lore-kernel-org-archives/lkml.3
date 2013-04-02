Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3DBWui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3DBWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/56] 3.0.72-stable review
Date: Tue,  2 Apr 2013 15:49:27 -0700
Message-Id: <20130402224711.840825715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.72 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  4 22:46:30 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.72-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.72-rc1

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Make sure dma_ops are set for hotplug devices

Steve Glendinning <steve.glendinning@shawell.net>
    smsc75xx: fix jumbo frame support

Veaceslav Falico <vfalico@redhat.com>
    pch_gbe: fix ip_summed checksum reporting on rx

Eric Dumazet <edumazet@google.com>
    net: add a synchronize_net() in netdev_rx_handler_unregister()

Max.Nekludov@us.elster.com <Max.Nekludov@us.elster.com>
    ks8851: Fix interpretation of rxlen field.

Hong Zhiguo <honkiko@gmail.com>
    ipv6: fix bad free of addrconf_init_net

Mugunthan V N <mugunthanvnm@ti.com>
    atl1e: drop pci-msi support because of packet corruption

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue

Eric Dumazet <edumazet@google.com>
    aoe: reserve enough headroom on skbs

Paul Moore <pmoore@redhat.com>
    unix: fix a race condition in unix_release()

Masatake YAMATO <yamato@redhat.com>
    thermal: shorten too long mcast group name

Cong Wang <amwang@redhat.com>
    8021q: fix a potential use-after-free

Yuchung Cheng <ycheng@google.com>
    tcp: undo spurious timeout after SACK reneging

Eric Dumazet <edumazet@google.com>
    tcp: preserve ACK clocking in TSO

Mirko Lindner <mlindner@marvell.com>
    sky2: Threshold for Pause Packet is set wrong

Mirko Lindner <mlindner@marvell.com>
    sky2: Receive Overflows not counted

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Prevent buffer overwrite disabled for latency tracers

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Protect tracer flags with trace_types_lock

Theodore Ts'o <tytso@mit.edu>
    ext4: use atomic64_t for the per-flexbg free_clusters count

Matt Fleming <matt.fleming@intel.com>
    efivars: Handle duplicate names from get_next_variable()

Matt Fleming <matt.fleming@intel.com>
    efivars: explicitly calculate length of VariableName

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't clobber crtc->fb when queue_flip fails

Jesse Barnes <jbarnes@virtuousgeek.org>
    drm/i915: don't set unpin_work if vblank_get fails

J. Bruce Fields <bfields@redhat.com>
    nfsd4: reject "negative" acl lengths

Anatol Pomozov <anatol.pomozov@gmail.com>
    loop: prevent bdev freeing while device in use

Petr Matousek <pmatouse@redhat.com>
    KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)

Jiang Liu <jiang.liu@huawei.com>
    mm/hotplug: correctly add new zone to all other nodes' zone lists

Avi Kivity <avi@redhat.com>
    KVM: Fix buffer overflow in kvm_set_irq()

Jason Wang <jasowang@redhat.com>
    macvtap: zerocopy: validate vectors before building skb

Avi Kivity <avi@redhat.com>
    KVM: Ensure all vcpus are consistent with in-kernel irqchip settings

Chuck Lever <chuck.lever@oracle.com>
    NFS: nfs_getaclargs.acl_len is a size_t

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix an Oops in the NFSv4 getacl code

Andy Adamson <andros@netapp.com>
    NFSv4: include bitmap in nfsv4 get acl data

Jan Kiszka <jan.kiszka@siemens.com>
    KVM: x86: Prevent starting PIT timers in the absence of irqchip support

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only write requested number of byte to user buffer

Paul Kot <pawlkt@gmail.com>
    batman-adv: bat_socket_read missing checks

Matthew Daley <mattjd@gmail.com>
    x25: Handle undersized/fragmented skbs

Matthew Daley <mattjd@gmail.com>
    x25: Validate incoming call user data lengths

Jan Kiszka <jan.kiszka@siemens.com>
    KVM: Clean up error handling during VCPU creation

Josef Bacik <jbacik@fusionio.com>
    Btrfs: limit the global reserve to 512mb

Vivek Gautam <gautam.vivek@samsung.com>
    usb: xhci: Fix TRB transfer length macro used for Event TRB.

Kees Cook <keescook@chromium.org>
    net/irda: add missing error path release_sock call

Bing Zhao <bzhao@marvell.com>
    mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Al Viro <viro@zeniv.linux.org.uk>
    vt: synchronize_rcu() under spinlock is not nice...

Konstantin Holoborodko <klh.kernel@gmail.com>
    usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Jan Beulich <JBeulich@suse.com>
    xen-blkback: fix dispatch_rw_block_io() error path

Iestyn C. Elfick <isedev@gmail.com>
    b43: A fix for DMA transmission sequence errors

Ming Lei <ming.lei@canonical.com>
    sysfs: handle failure path correctly for readdir()

Ming Lei <ming.lei@canonical.com>
    sysfs: fix race between readdir and lseek

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: s626: fix continuous acquisition

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:817a]

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:0036]

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked

Andrew Morton <akpm@linux-foundation.org>
    kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Ben Hutchings <ben@decadent.org.uk>
    signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer


-------------

Diffstat:

 Makefile                              |  4 +-
 arch/arm/include/asm/signal.h         |  1 +
 arch/avr32/include/asm/signal.h       |  1 +
 arch/cris/include/asm/signal.h        |  1 +
 arch/h8300/include/asm/signal.h       |  1 +
 arch/ia64/kvm/kvm-ia64.c              |  5 ++
 arch/m32r/include/asm/signal.h        |  1 +
 arch/m68k/include/asm/signal.h        |  1 +
 arch/mn10300/include/asm/signal.h     |  1 +
 arch/powerpc/include/asm/signal.h     |  1 +
 arch/s390/include/asm/signal.h        |  1 +
 arch/sparc/include/asm/signal.h       |  1 +
 arch/x86/include/asm/signal.h         |  2 +
 arch/x86/kernel/amd_iommu.c           | 24 +++++----
 arch/x86/kvm/i8254.c                  | 10 ++--
 arch/x86/kvm/x86.c                    | 19 +++++--
 arch/xtensa/include/asm/signal.h      |  1 +
 drivers/block/aoe/aoecmd.c            |  3 +-
 drivers/block/loop.c                  |  9 +++-
 drivers/block/xen-blkback/blkback.c   |  7 +--
 drivers/bluetooth/ath3k.c             |  4 ++
 drivers/bluetooth/btusb.c             |  2 +
 drivers/firmware/efivars.c            | 92 ++++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_display.c  | 23 ++++----
 drivers/net/atl1e/atl1e.h             |  1 -
 drivers/net/atl1e/atl1e_main.c        | 22 +-------
 drivers/net/davinci_emac.c            |  2 +-
 drivers/net/ks8851.c                  |  2 +-
 drivers/net/macvtap.c                 |  4 ++
 drivers/net/pch_gbe/pch_gbe_main.c    |  4 +-
 drivers/net/sky2.c                    |  2 +-
 drivers/net/sky2.h                    |  2 +-
 drivers/net/usb/smsc75xx.c            | 12 +++--
 drivers/net/wireless/b43/dma.c        | 65 ++++++++++++++++++-----
 drivers/net/wireless/mwifiex/init.c   |  8 +++
 drivers/staging/comedi/drivers/s626.c |  2 +-
 drivers/tty/vt/vc_screen.c            |  6 ++-
 drivers/usb/host/xhci-ring.c          | 24 ++++-----
 drivers/usb/host/xhci.h               |  4 ++
 drivers/usb/serial/ftdi_sio.c         |  1 +
 drivers/usb/serial/ftdi_sio_ids.h     |  7 +++
 fs/block_dev.c                        |  1 +
 fs/btrfs/extent-tree.c                |  2 +-
 fs/ext4/ext4.h                        |  6 +--
 fs/ext4/ialloc.c                      | 18 +++----
 fs/ext4/mballoc.c                     | 10 ++--
 fs/ext4/resize.c                      |  4 +-
 fs/ext4/super.c                       |  4 +-
 fs/nfs/nfs4proc.c                     | 99 +++++++++++++++++++++--------------
 fs/nfs/nfs4xdr.c                      | 34 +++++++++---
 fs/nfsd/nfs4xdr.c                     |  2 +-
 fs/sysfs/dir.c                        | 17 +++++-
 include/asm-generic/signal.h          |  4 ++
 include/linux/kvm_host.h              |  7 +++
 include/linux/nfs_xdr.h               |  5 ++
 include/linux/sunrpc/xdr.h            |  2 +
 include/linux/thermal.h               |  2 +-
 kernel/signal.c                       |  2 +-
 kernel/trace/trace.c                  | 50 ++++++++++++++----
 kernel/trace/trace.h                  |  7 +++
 kernel/trace/trace_irqsoff.c          | 19 +++++--
 kernel/trace/trace_sched_wakeup.c     | 18 +++++--
 mm/memory_hotplug.c                   | 15 +++---
 net/8021q/vlan.c                      | 14 ++---
 net/batman-adv/icmp_socket.c          |  5 +-
 net/bluetooth/sco.c                   |  1 +
 net/core/dev.c                        |  6 +++
 net/ipv4/tcp_input.c                  |  7 +--
 net/ipv4/tcp_output.c                 |  7 ++-
 net/ipv6/addrconf.c                   | 26 ++++-----
 net/irda/af_irda.c                    |  6 ++-
 net/netlink/genetlink.c               |  1 +
 net/sunrpc/sched.c                    |  9 +++-
 net/sunrpc/xdr.c                      |  3 +-
 net/unix/af_unix.c                    |  7 ++-
 net/x25/af_x25.c                      | 37 ++++++++++---
 net/x25/x25_dev.c                     |  6 +++
 net/x25/x25_facilities.c              | 10 ++--
 net/x25/x25_in.c                      | 43 +++++++++++++--
 net/x25/x25_link.c                    |  3 ++
 net/x25/x25_subr.c                    | 14 ++++-
 virt/kvm/irq_comm.c                   |  1 +
 virt/kvm/kvm_main.c                   | 15 ++++--
 83 files changed, 665 insertions(+), 267 deletions(-)


