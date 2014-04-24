Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaDXVxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:53:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbaDXVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/27] 3.4.88-stable review
Date: Thu, 24 Apr 2014 14:55:34 -0700
Message-Id: <20140424215551.942390050@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.88 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Apr 26 21:55:41 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.88-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.88-rc1

Oleg Nesterov <oleg@redhat.com>
    wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Li Zefan <lizefan@huawei.com>
    jffs2: remove from wait queue after schedule()

Li Zefan <lizefan@huawei.com>
    jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Ajesh Kunhipurayil Vijayan <ajesh@broadcom.com>
    jffs2: Fix crash due to truncation of csize

Kamlakant Patel <kamlakant.patel@broadcom.com>
    jffs2: Fix segmentation fault found in stress test

Claudio Takahasi <claudio.takahasi@openbossa.org>
    Bluetooth: Fix removing Long Term Key

Jiri Slaby <jslaby@suse.cz>
    Char: ipmi_bt_sm, fix infinite loop

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc64: don't treat 64-bit syscall return codes as 32-bit

Paul Gortmaker <paul.gortmaker@windriver.com>
    sparc32: fix build failure for arch_jump_label_transform

Dave Kleikamp <dave.kleikamp@oracle.com>
    Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."

oftedal <oftedal@gmail.com>
    sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device in rds_iw_laddr_check

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: several buffer overflows

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    isdnloop: Validate NUL-terminated strings from user.

Pablo Neira <pablo@netfilter.org>
    netlink: don't compare the nul-termination in nla_strcmp

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: some ipv6 statistic counters failed to disable bh

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: remove pointless clause from if statement

Michael S. Tsirkin <mst@redhat.com>
    vhost: validate vhost_get_vq_desc return value

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix total length when packets are too short

lucien <lucien.xin@gmail.com>
    ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

Heiner Kallweit <heiner.kallweit@web.de>
    ipv6: Avoid unnecessary temporary addresses being generated

Matthew Leach <matthew.leach@arm.com>
    net: socket: error on a negative msg_namelen

Peter Boström <peter.bostrom@netrounds.com>
    vlan: Set correct source MAC address with TX VLAN offload enabled

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: don't set DST_NOCOUNT for remotely added routes

Eric Dumazet <edumazet@google.com>
    net: unix: non blocking recvmsg() should not return -EINTR

Linus Lüssing <linus.luessing@web.de>
    bridge: multicast: add sanity check for query source addresses

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk


-------------

Diffstat:

 Makefile                            |  4 ++--
 arch/sparc/Kconfig                  |  2 +-
 arch/sparc/include/asm/uaccess_64.h |  4 ++--
 arch/sparc/kernel/pci.c             |  4 ++--
 arch/sparc/kernel/syscalls.S        |  4 ++--
 drivers/char/ipmi/ipmi_bt_sm.c      |  2 +-
 drivers/isdn/isdnloop/isdnloop.c    | 23 +++++++++++++++--------
 drivers/net/xen-netback/netback.c   |  4 ++--
 drivers/vhost/net.c                 | 20 +++++++++++++++++++-
 fs/jffs2/compr_rtime.c              |  4 ++--
 fs/jffs2/nodelist.h                 |  2 +-
 fs/jffs2/nodemgmt.c                 | 14 ++++++++++----
 kernel/exit.c                       | 15 +++++++++++----
 lib/nlattr.c                        | 10 ++++++++--
 net/8021q/vlan_dev.c                |  3 +++
 net/bluetooth/hci_event.c           |  8 +++++++-
 net/bridge/br_multicast.c           |  6 ++++++
 net/ipv6/addrconf.c                 |  5 ++++-
 net/ipv6/icmp.c                     |  2 +-
 net/ipv6/ip6_output.c               | 18 ++++++++----------
 net/ipv6/mcast.c                    | 11 ++++++-----
 net/ipv6/route.c                    |  2 +-
 net/rds/iw.c                        |  3 ++-
 net/sctp/sm_make_chunk.c            |  4 ++--
 net/sctp/sm_statefuns.c             |  5 -----
 net/socket.c                        |  4 ++++
 net/unix/af_unix.c                  | 17 ++++++++++++-----
 27 files changed, 134 insertions(+), 66 deletions(-)


