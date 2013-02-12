Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3BLUlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:41:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3BLUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/36] 3.4.31-stable review
Date: Tue, 12 Feb 2013 12:40:54 -0800
Message-Id: <20130212203857.305594226@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.31 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 14 20:38:17 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.31-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.31-rc1

Somnath Kotur <somnath.kotur@emulex.com>
    be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug

Nithin Nayak Sujir <nsujir@broadcom.com>
    tg3: Fix crc errors on jumbo frame receive

Nithin Nayak Sujir <nsujir@broadcom.com>
    tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode

Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
    bridge: Pull ip header into skb->data before looking into ip header.

Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
    tcp: fix for zero packets_in_flight was too broad

Eric Dumazet <edumazet@google.com>
    tcp: frto should not set snd_cwnd to 0

Ian Campbell <Ian.Campbell@citrix.com>
    netback: correct netbk_tx_err to handle wrap around.

Ian Campbell <Ian.Campbell@citrix.com>
    xen/netback: free already allocated memory on failure in xen_netbk_get_requests

Matthew Daley <mattjd@gmail.com>
    xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Ian Campbell <Ian.Campbell@citrix.com>
    xen/netback: shutdown the ring if it contains garbage.

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_endpoint_free: zero out secret key data

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree

Neil Horman <nhorman@tuxdriver.com>
    sctp: refactor sctp_outq_teardown to insure proper re-initalization

Heiko Carstens <heiko.carstens@de.ibm.com>
    atm/iphase: rename fregt_t -> ffreg_t

Phil Sutter <phil.sutter@viprinet.com>
    packet: fix leakage of tx_ring memory

David S. Miller <davem@davemloft.net>
    via-rhine: Fix bugs in NAPI support.

Marcelo Ricardo Leitner <mleitner@redhat.com>
    ipv6: do not create neighbor entries for local delivery

Cong Wang <amwang@redhat.com>
    pktgen: correctly handle failures when adding a device

Eric Dumazet <edumazet@google.com>
    net: loopback: fix a dst refcounting issue

Timo Teräs <timo.teras@iki.fi>
    r8169: remove the obsolete and incorrect AMD workaround

Eric Dumazet <edumazet@google.com>
    netxen: fix off by one bug in netxen_release_tx_buffer()

Tilman Schmidt <tilman@imap.cc>
    isdn/gigaset: fix zero size border case in debug dump

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults

Yan Burman <yanb@mellanox.com>
    net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

Rob Herring <rob.herring@calxeda.com>
    net: calxedaxgmac: throw away overrun frames

Romain KUNTZ <r.kuntz@ipflavors.com>
    ipv6: fix header length calculation in ip6_append_data()

Stephen Hemminger <stephen.hemminger@vyatta.com>
    MAINTAINERS: Stephen Hemminger email change

Romain Kuntz <r.kuntz@ipflavors.com>
    ipv6: fix the noflags test in addrconf_get_prefix_route

Cong Wang <xiyou.wangcong@gmail.com>
    net: prevent setting ttl=0 via IP_TTL

Matt Fleming <matt.fleming@intel.com>
    samsung-laptop: Disable on EFI hardware

Matt Fleming <matt.fleming@intel.com>
    efi: Make 'efi_enabled' a function to query EFI facilities

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix handling of unexpected SMP PDUs

T Makphaibulchoke <tmac@hp.com>
    kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Sjur Brændeland <sjur.brandeland@stericsson.com>
    virtio_console: Don't access uninitialized data.

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix scheduling while atomic bug

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix the usage of the wrong variable in usb.c


-------------

Diffstat:

 MAINTAINERS                                          |   6 +-
 Makefile                                             |   4 +-
 arch/x86/include/asm/efi.h                           |   1 +
 arch/x86/kernel/reboot.c                             |   2 +-
 arch/x86/kernel/setup.c                              |  28 ++---
 arch/x86/platform/efi/efi.c                          |  57 +++++----
 drivers/acpi/osl.c                                   |   2 +-
 drivers/atm/iphase.h                                 | 146 +++++++++++------------
 drivers/char/virtio_console.c                        |   3 +-
 drivers/firmware/dmi_scan.c                          |   2 +-
 drivers/firmware/efivars.c                           |   4 +-
 drivers/firmware/iscsi_ibft_find.c                   |   2 +-
 drivers/gpu/drm/radeon/radeon_device.c               |   3 +-
 drivers/isdn/gigaset/capi.c                          |   2 +
 drivers/net/ethernet/broadcom/tg3.c                  |  62 ++++++----
 drivers/net/ethernet/calxeda/xgmac.c                 |   4 +
 drivers/net/ethernet/emulex/benet/be.h               |   5 +
 drivers/net/ethernet/emulex/benet/be_main.c          |  56 ++++++---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c           |  13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c            |  11 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |   2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |   2 +
 drivers/net/ethernet/realtek/r8169.c                 |   7 --
 drivers/net/ethernet/via/via-rhine.c                 |   8 +-
 drivers/net/loopback.c                               |   5 +
 drivers/net/wireless/rtlwifi/base.c                  |   7 +-
 drivers/net/wireless/rtlwifi/usb.c                   |   4 +-
 drivers/net/xen-netback/common.h                     |   3 +
 drivers/net/xen-netback/interface.c                  |  23 ++--
 drivers/net/xen-netback/netback.c                    | 115 +++++++++++-------
 drivers/platform/x86/ibm_rtl.c                       |   2 +-
 drivers/platform/x86/samsung-laptop.c                |   4 +
 drivers/scsi/isci/init.c                             |   2 +-
 include/linux/efi.h                                  |  24 +++-
 init/main.c                                          |   4 +-
 kernel/resource.c                                    |  50 ++++++--
 net/bluetooth/smp.c                                  |  13 ++
 net/bridge/br_netfilter.c                            |   3 +
 net/core/pktgen.c                                    |   9 +-
 net/ipv4/ip_sockglue.c                               |   2 +-
 net/ipv4/tcp_input.c                                 |   5 +
 net/ipv6/addrconf.c                                  |   2 +-
 net/ipv6/ip6_output.c                                |   4 +-
 net/ipv6/route.c                                     |   3 +-
 net/packet/af_packet.c                               |  10 +-
 net/sctp/endpointola.c                               |   5 +
 net/sctp/outqueue.c                                  |  12 +-
 net/sctp/socket.c                                    |   2 +-
 48 files changed, 461 insertions(+), 284 deletions(-)


