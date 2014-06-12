Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaFLXSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:18:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFLXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/18] 3.10.44-stable review
Date: Thu, 12 Jun 2014 16:22:04 -0700
Message-Id: <20140612232212.960235342@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.44 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 14 23:22:02 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.44-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.44-rc1

Andreas Schrägle <ajs124.ajs124@gmail.com>
    ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Jérôme Carretero <cJ-ko@zougloub.eu>
    ahci: Add Device ID for HighPoint RocketRaid 642L

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: drop harmful wait optimization

Ben Collins <ben.c@servergy.com>
    SCSI: megaraid: Use resource_size_t for PCI resources, not long

Andy Lutomirski <luto@amacapital.net>
    auditsc: audit_krule mask accesses need bounds checking

Vlastimil Babka <vbabka@suse.cz>
    mm/compaction: make isolate_freepages start at pageblock boundary

Vlastimil Babka <vbabka@suse.cz>
    mm: compaction: detect when scanners meet in isolate_freepages

Vlastimil Babka <vbabka@suse.cz>
    mm: compaction: reset cached scanner pfn's before reading them

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix alua_access_state attribute OOPs for un-configured devices

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Allow READ_CAPACITY opcode in ALUA Standby access state

Roland Dreier <roland@purestorage.com>
    iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param_value()

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix multi network portal shutdown regression

Sagi Grimberg <sagig@mellanox.com>
    Target/iscsi,iser: Avoid accepting transport connections during stop stage

Florian Westphal <fw@strlen.de>
    netfilter: ipv4: defrag: set local_df flag on defragmented skb

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree

Chris Mason <clm@fb.com>
    mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Andy Lutomirski <luto@amacapital.net>
    fs,userns: Change inode_capable to capable_wrt_inode_uidgid


-------------

Diffstat:

 Makefile                                         |  4 +-
 arch/arm/boot/dts/armada-xp-gp.dts               |  2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  2 +-
 drivers/ata/ahci.c                               |  4 ++
 drivers/infiniband/ulp/isert/ib_isert.c          |  8 ++++
 drivers/misc/mei/hw-me.c                         |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c       |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |  6 +--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h     |  1 -
 drivers/scsi/megaraid/megaraid_sas.h             |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c        |  5 ++-
 drivers/target/iscsi/iscsi_target.c              |  1 +
 drivers/target/iscsi/iscsi_target_core.h         |  1 +
 drivers/target/iscsi/iscsi_target_login.c        | 51 +++++++++++----------
 drivers/target/iscsi/iscsi_target_tpg.c          |  9 ++--
 drivers/target/target_core_alua.c                |  9 ++++
 drivers/target/target_core_configfs.c            |  5 +++
 fs/attr.c                                        |  8 ++--
 fs/inode.c                                       | 10 +++--
 fs/namei.c                                       | 11 ++---
 include/linux/capability.h                       |  2 +-
 kernel/auditsc.c                                 | 27 +++++++----
 kernel/capability.c                              | 18 +++-----
 mm/compaction.c                                  | 57 +++++++++++++++---------
 net/ipv4/netfilter/nf_defrag_ipv4.c              |  5 ++-
 25 files changed, 152 insertions(+), 100 deletions(-)


