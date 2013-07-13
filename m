Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3GME35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 00:29:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33388 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab3GME34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 00:29:56 -0400
Message-ID: <1373689791.2922.5.camel@dabdike>
Subject: [GIT PULL] Final round of SCSI updates for the 3.10+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 13 Jul 2013 08:29:51 +0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the remaining set of SCSI patches for the merge window.  it's
mostly driver updates (scsi_debug, qla2xxx, storvsc, mp3sas).  There are
also several bug fixes in fcoe, libfc, and megaraid_sas.  We also have a
couple of core changes to try to make device destruction more
deterministic.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is

Akinobu Mita (6):
      scsi_debug: reduce duplication between prot_verify_read and prot_verify_write
      scsi_debug: simplify offset calculation for dif_storep
      scsi_debug: invalidate protection info for unmapped region
      scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
      scsi_debug: fix incorrectly nested kmap_atomic()
      scsi_debug: fix invalid address passed to kunmap_atomic()

Bart Van Assche (12):
      fcoe: Reduce number of sparse warnings
      enable destruction of blocked devices which fail LUN scanning
      qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
      qla2xxx: Remove an unused variable from qla2x00_remove_one().
      qla2xxx: Fix qla2xxx_check_risc_status().
      qla2xxx: Help Coverity with analyzing ct_sns_pkt initialization.
      qla2xxx: Remove redundant assignments.
      qla2xxx: Remove a dead assignment in qla24xx_build_scsi_crc_2_iocbs().
      qla2xxx: Remove two superfluous tests.
      qla2xxx: Remove dead code in qla2x00_configure_hba()
      qla2xxx: Clean up qla84xx_mgmt_cmd()
      qla2xxx: Clean up qla24xx_iidma()

Bjørn Mork (1):
      megaraid_sas: fix memory leak if SGL has zero length entries

Chad Dupuis (2):
      qla2xxx: Do not take a second firmware dump when intentionally generating one.
      qla2xxx: Do not query FC statistics during chip reset.

Dan Carpenter (1):
      megaraid_sas: fix a bug for 64 bit arches

Douglas Gilbert (1):
      scsi constants: command, sense key + additional sense strings

Giridhar Malavali (2):
      qla2xxx: Set the index in outstanding command array to NULL when cmd is aborted when the request timeout.
      qla2xxx: Clear the MBX_INTR_WAIT flag when the mailbox time-out happens.

James Bottomley (1):
      Fix race between starved list and device removal

K. Y. Srinivasan (3):
      storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS
      storvsc: Support FC devices
      storvsc: Implement multi-channel support

Mark Rustad (2):
      fcoe: Stop fc_rport_priv structure leak
      libfc: Reject PLOGI from nodes with incompatible role

Neerav Parikh (1):
      fcoe: Fix smatch warning in fcoe_fdmi_info function

Robert Love (3):
      libfcoe: Fix meaningless log statement
      libfc: Differentiate echange timer cancellation debug statements
      libfc: Remove extra space in fc_exch_timer_cancel definition

Saurav Kashyap (2):
      qla2xxx: Fix sparse warning from qla_mr.c and qla_iocb.c.
      qla2xxx: Move qla2x00_free_device to the correct location.

Sreekanth Reddy (7):
      mpt3sas: Bump driver version to v02.100.00.00
      mpt3sas: when async scanning is enabled then while scanning, devices are removed but their transport layer entries are not removed
      mpt3sas: MPI2.5 Rev F v2.5.1.1 specification
      mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
      mpt3sas: fix for kernel panic when driver loads with HBA conected to non LUN 0 configured expander
      mpt3sas: Updated the Hardware timing requirements
      mpt3sas: 2013 source code copyright

Yi Zou (1):
      fcoe: fix the link error status block sparse warnings

Yijing Wang (1):
      pm8001: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)

The diffstat is

 drivers/scsi/constants.c                    | 235 ++++++++++++++++++++++------
 drivers/scsi/fcoe/fcoe.c                    |  26 +--
 drivers/scsi/fcoe/fcoe_ctlr.c               |   4 +
 drivers/scsi/fcoe/fcoe_sysfs.c              |  24 +--
 drivers/scsi/fcoe/fcoe_transport.c          |  28 +---
 drivers/scsi/libfc/fc_exch.c                |   4 +-
 drivers/scsi/libfc/fc_rport.c               |  27 ++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |  10 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   4 +-
 drivers/scsi/mpt3sas/Kconfig                |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |  12 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  15 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |  10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h        |  10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h         |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |  10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  22 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  54 ++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |   2 +-
 drivers/scsi/pm8001/pm8001_init.c           |   7 +-
 drivers/scsi/qla2xxx/qla_attr.c             |   5 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |  38 ++---
 drivers/scsi/qla2xxx/qla_dbg.c              |  12 +-
 drivers/scsi/qla2xxx/qla_def.h              |  34 ++--
 drivers/scsi/qla2xxx/qla_gbl.h              |   2 +-
 drivers/scsi/qla2xxx/qla_gs.c               |  86 +++++-----
 drivers/scsi/qla2xxx/qla_init.c             |   8 -
 drivers/scsi/qla2xxx/qla_inline.h           |   2 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c              |   1 +
 drivers/scsi/qla2xxx/qla_mbx.c              |  16 +-
 drivers/scsi/qla2xxx/qla_mr.c               | 167 ++++++++++----------
 drivers/scsi/qla2xxx/qla_mr.h               |  98 ++++++------
 drivers/scsi/qla2xxx/qla_os.c               |  10 +-
 drivers/scsi/scsi_debug.c                   | 174 +++++++++-----------
 drivers/scsi/scsi_lib.c                     |  27 +++-
 drivers/scsi/storvsc_drv.c                  | 139 +++++++++++++++-
 46 files changed, 828 insertions(+), 529 deletions(-)

James


