Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3IKVZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:25:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3IKVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:25:51 -0400
Date: Wed, 11 Sep 2013 17:25:49 -0400 (EDT)
Message-Id: <20130911.172549.1636833534315801022.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Sep 2013 14:25:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BLPxg2008082


1) Brown paper bag fix in HTB scheduler, class options set incorrectly due
   to a typoe.  Fix from Vimalkumar.

2) It's possible for the ipv6 FIB garbage collector to run before all
   the necessary datastructure are setup during init, defer the notifier
   registry to avoid this problem.  Fix from Michal Kubecek.

3) New i40e ethernet driver from the Intel folks.

4) Add new qmi wwan device IDs, from BjÃ¸rn Mork.

5) Doorbell lock in bnx2x driver is not initialized properly in some
   configurations, fix from Ariel Elior.

6) Revert an ipv6 packet option padding change that broke standardized
   ipv6 implementation test suites.  From Jiri Pirko.

7) Fix synchronization of ARP information in bonding layer, from Nikolay
   Aleksandrov.

8) Fix missing error return resulting in illegal memory accesses in
   openvswitch, from Daniel Borkmann.

9) SCTP doesn't signal poll events properly due to mistaken operator
   precedence, fix also from Daniel Borkmann.

10) __netdev_pick_tx() passes wrong index to sk_tx_queue_set() which
    essentially disables caching of TX queue in sockets :-/ Fix from
    Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 300893b08f3bc7057a7a5f84074090ba66c8b5ca:

  Merge tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs (2013-09-09 11:19:09 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to f3ad857e3da1abaea780dc892b592cd86c541c52:

  net_sched: htb: fix a typo in htb_change_class() (2013-09-11 17:16:22 -0400)

----------------------------------------------------------------
Ariel Elior (1):
      bnx2x: Fix configuration of doorbell block

BjÃ¸rn Mork (1):
      net: qmi_wwan: add new Qualcomm devices

Chris Metcalf (1):
      net: tilegx driver: avoid compiler warning

Daniel Borkmann (4):
      net: ovs: flow: fix potential illegal memory access in __parse_flow_nlattrs
      net: fib: fib6_add: fix potential NULL pointer dereference
      net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip

David S. Miller (2):
      Merge branch 'bonding_arp'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net

Eric Dumazet (1):
      net: fix multiqueue selection

Herbert Xu (1):
      macvlan: Move skb_clone check closer to call

Jesse Brandeburg (8):
      i40e: main driver core
      i40e: transmit, receive, and NAPI
      i40e: driver ethtool core
      i40e: driver core headers
      i40e: implement virtual device interface
      i40e: init code and hardware support
      i40e: debugfs interface
      i40e: include i40e in kernel proper

Jingoo Han (2):
      irda: donauboe: Remove casting the return value which is a void pointer
      irda: vlsi_ir: Remove casting the return value which is a void pointer

Jiri Pirko (1):
      ipv6/exthdrs: accept tlv which includes only padding

Jitendra Kalsaria (1):
      qlcnic: Fix warning reported by kbuild test robot.

Michael Opdenacker (2):
      net: korina: remove deprecated IRQF_DISABLED
      bcm63xx_enet: remove deprecated IRQF_DISABLED

Michal KubeÄek (1):
      ipv6: don't call fib6_run_gc() until routing is ready

Michal Schmidt (1):
      bnx2x: avoid atomic allocations during initialization

Stefan Tomanek (1):
      fib6_rules: fix indentation

Vimalkumar (1):
      net_sched: htb: fix a typo in htb_change_class()

nikolay@redhat.com (2):
      bonding: fix store_arp_validate race with mode change
      bonding: fix bond_arp_rcv setting and arp validate desync state

 Documentation/networking/00-INDEX                  |    2 +
 Documentation/networking/i40e.txt                  |  115 ++
 MAINTAINERS                                        |    3 +-
 drivers/net/bonding/bond_main.c                    |    4 +-
 drivers/net/bonding/bond_sysfs.c                   |   31 +-
 drivers/net/bonding/bonding.h                      |    1 +
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   38 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |    3 -
 drivers/net/ethernet/intel/Kconfig                 |   18 +
 drivers/net/ethernet/intel/Makefile                |    1 +
 drivers/net/ethernet/intel/i40e/Makefile           |   44 +
 drivers/net/ethernet/intel/i40e/i40e.h             |  558 ++++++
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |  983 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_adminq.h      |  112 ++
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  | 2076 +++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_alloc.h       |   59 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      | 2041 ++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     | 2076 +++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |  131 ++
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |   52 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 1449 +++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_hmc.c         |  366 ++++
 drivers/net/ethernet/intel/i40e/i40e_hmc.h         |  245 +++
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c     | 1006 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h     |  169 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 7375 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_nvm.c         |  391 ++++
 drivers/net/ethernet/intel/i40e/i40e_osdep.h       |   82 +
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |  239 +++
 drivers/net/ethernet/intel/i40e/i40e_register.h    | 4688 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_status.h      |  101 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 1817 ++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |  259 +++
 drivers/net/ethernet/intel/i40e/i40e_type.h        | 1154 ++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h    |  368 ++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2335 +++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  120 ++
 drivers/net/ethernet/korina.c                      |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |    2 +-
 drivers/net/ethernet/tile/tilegx.c                 |    6 +-
 drivers/net/irda/donauboe.c                        |    6 +-
 drivers/net/irda/vlsi_ir.c                         |    2 +-
 drivers/net/macvlan.c                              |   10 +-
 drivers/net/usb/qmi_wwan.c                         |  130 +-
 include/net/ndisc.h                                |    2 +
 net/core/flow_dissector.c                          |    2 +-
 net/ipv6/af_inet6.c                                |    6 +
 net/ipv6/exthdrs.c                                 |    6 -
 net/ipv6/fib6_rules.c                              |    4 +-
 net/ipv6/ip6_fib.c                                 |    2 +-
 net/ipv6/ndisc.c                                   |   18 +-
 net/openvswitch/flow.c                             |    1 +
 net/sched/sch_htb.c                                |    2 +-
 net/sctp/socket.c                                  |    5 +-
 56 files changed, 30666 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/networking/i40e.txt
 create mode 100644 drivers/net/ethernet/intel/i40e/Makefile
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_adminq.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_adminq.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_alloc.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_common.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_debugfs.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_diag.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_diag.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_hmc.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_hmc.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_main.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_nvm.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_osdep.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_prototype.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_register.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_status.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_txrx.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_txrx.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_type.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
