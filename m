Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaFXQuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:50:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaFXPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/52] 3.10.45-stable review
Date: Tue, 24 Jun 2014 11:50:15 -0400
Message-Id: <20140624154713.428945460@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.45 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 26 15:46:59 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.45-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.45-rc1

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Make sure that id->index does not overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Handle numid overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Don't access controls outside of protected regions

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Fix replacing user controls

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Protect user controls against concurrent access

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add quirk for external mic on Lifebook U904

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC891 codec

Wang, Xiaoming <xiaoming.wang@intel.com>
    ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.

Thomas Gleixner <tglx@linutronix.de>
    nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lzo: properly check for overruns

Peter Meerwald <pmeerw@pmeerw.net>
    iio: Fix endianness issue in ak8975_read_axis()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
    staging: iio: tsl2x7x_core: fix proximity treshold

Jonathan Cameron <jic23@kernel.org>
    iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ASoC: max98090: Fix reset at resume time

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: balloon: Ensure pressure reports are posted regularly

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM imbalance at shutdown

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix I/O after failed open

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix shutdown and suspend race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM for control messages

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix broken runtime suspend

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and resume race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and suspend race

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Allocate at least 16KB for exception handlers

Boris BREZILLON <boris.brezillon@free-electrons.com>
    ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: lapic: sync highest ISR to hardware apic on EOI

Wei Yang <weiyang@linux.vnet.ibm.com>
    net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Wei Yang <weiyang@linux.vnet.ibm.com>
    net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset

Cong Wang <cwang@twopensource.com>
    vxlan: use dev->needed_headroom instead of dev->hard_header_len

Michal Schmidt <mschmidt@redhat.com>
    rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: Fix sk_ack_backlog wrap-around problem

Eric Dumazet <edumazet@google.com>
    ipv4: fix a race in ip4_datagram_release_cb()

Dmitry Popov <ixaphire@qrator.net>
    ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Eric Dumazet <edumazet@google.com>
    net: force a list_del() in unregister_netdevice_many()

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Olivetti Olicard modems

Alexei Starovoitov <ast@plumgrid.com>
    net: filter: fix sparc32 typo

Alexei Starovoitov <ast@plumgrid.com>
    net: filter: fix typo in sparc BPF JIT

Yuchung Cheng <ycheng@google.com>
    tcp: fix cwnd undo on DSACK in F-RTO

Jiri Pirko <jiri@resnulli.us>
    team: fix mtu setting

Eric Dumazet <edumazet@google.com>
    net: fix inet_getid() and ipv6_select_ident() bugs

Tom Gundersen <teg@jklm.no>
    net: tunnels - enable module autoloading

Michal Schmidt <mschmidt@redhat.com>
    netlink: rate-limit leftover bytes warning and print process name

Eric W. Biederman <ebiederm@xmission.com>
    netlink: Only check file credentials for implicit destinations

Eric W. Biederman <ebiederm@xmission.com>
    net: Use netlink_ns_capable to verify the permisions of netlink messages

Eric W. Biederman <ebiederm@xmission.com>
    net: Add variants of capable for use on netlink messages

Eric W. Biederman <ebiederm@xmission.com>
    net: Add variants of capable for use on on sockets

Eric W. Biederman <ebiederm@xmission.com>
    net: Move the permission check in sock_diag_put_filterinfo to packet_diag_dump

Eric W. Biederman <ebiederm@xmission.com>
    netlink: Rename netlink_capable netlink_allowed

Mimi Zohar <zohar@linux.vnet.ibm.com>
    evm: prohibit userspace writing 'security.evm' HMAC value

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: introduce ima_kernel_read()

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Reject mutual authentication with reflected CHAP_C

Boris BREZILLON <boris.brezillon@free-electrons.com>
    rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/arm/mach-at91/sysirq_mask.c          |  22 ++--
 arch/mips/kvm/kvm_mips.c                  |   2 +-
 arch/sparc/net/bpf_jit_comp.c             |   8 +-
 arch/x86/kvm/lapic.c                      |  62 +++++++----
 crypto/crypto_user.c                      |   2 +-
 drivers/connector/cn_proc.c               |   2 +-
 drivers/hv/hv_balloon.c                   |  29 ++++-
 drivers/iio/adc/at91_adc.c                |  16 +--
 drivers/iio/adc/max1363.c                 |  16 +--
 drivers/iio/magnetometer/ak8975.c         |   9 +-
 drivers/net/ethernet/mellanox/mlx4/main.c | 170 +++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   1 +
 drivers/net/macvlan.c                     |   1 -
 drivers/net/team/team.c                   |   7 +-
 drivers/net/usb/qmi_wwan.c                |   7 +-
 drivers/net/vxlan.c                       |   4 +-
 drivers/rtc/rtc-at91rm9200.c              |  16 ++-
 drivers/scsi/scsi_netlink.c               |   2 +-
 drivers/staging/iio/light/tsl2x7x_core.c  |   8 +-
 drivers/target/iscsi/iscsi_target_auth.c  |  10 ++
 drivers/usb/class/cdc-acm.c               |  96 ++++++++++-------
 drivers/usb/class/cdc-acm.h               |   2 +-
 include/linux/if_team.h                   |   1 +
 include/linux/netlink.h                   |  14 ++-
 include/linux/sock_diag.h                 |   2 +-
 include/net/inetpeer.h                    |   9 +-
 include/net/sock.h                        |   5 +
 include/sound/core.h                      |   2 +
 include/uapi/sound/compress_offload.h     |   2 +-
 kernel/audit.c                            |   4 +-
 kernel/time/tick-sched.c                  |   4 +-
 lib/lzo/lzo1x_decompress_safe.c           |  62 +++++++----
 lib/nlattr.c                              |   4 +-
 net/can/gw.c                              |   4 +-
 net/core/dev.c                            |   5 +-
 net/core/rtnetlink.c                      |  43 +++++---
 net/core/sock.c                           |  49 +++++++++
 net/core/sock_diag.c                      |   4 +-
 net/dcb/dcbnl.c                           |   2 +-
 net/decnet/dn_dev.c                       |   4 +-
 net/decnet/dn_fib.c                       |   4 +-
 net/decnet/netfilter/dn_rtmsg.c           |   2 +-
 net/ipv4/datagram.c                       |  20 +++-
 net/ipv4/ipip.c                           |   5 +-
 net/ipv4/tcp_input.c                      |  11 +-
 net/ipv6/ip6_tunnel.c                     |   1 +
 net/ipv6/output_core.c                    |  11 +-
 net/ipv6/sit.c                            |   5 +-
 net/mac80211/iface.c                      |   1 -
 net/netfilter/nfnetlink.c                 |   2 +-
 net/netlink/af_netlink.c                  |  80 +++++++++++++-
 net/netlink/genetlink.c                   |   2 +-
 net/packet/diag.c                         |   7 +-
 net/phonet/pn_netlink.c                   |   8 +-
 net/sched/act_api.c                       |   2 +-
 net/sched/cls_api.c                       |   2 +-
 net/sched/sch_api.c                       |   6 +-
 net/sctp/associola.c                      |   2 +-
 net/tipc/netlink.c                        |   2 +-
 net/xfrm/xfrm_user.c                      |   2 +-
 security/integrity/evm/evm_main.c         |  12 ++-
 security/integrity/ima/ima_crypto.c       |  32 +++++-
 sound/core/control.c                      |  78 +++++++++-----
 sound/core/init.c                         |   1 +
 sound/pci/hda/patch_realtek.c             |  10 ++
 sound/soc/codecs/max98090.c               |   3 +
 67 files changed, 702 insertions(+), 325 deletions(-)


