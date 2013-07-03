Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3GCHZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:25:05 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56200 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3GCHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:25:03 -0400
Date: Wed, 3 Jul 2013 09:24:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.11 merge window #1
Message-ID: <20130703092455.3ae5bd06@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070307-0342-0000-0000-0000057A35B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
This is the bulk of the s390 patches for the 3.11 merge window.
Notable enhancements are: the block timeout patches for dasd from Hannes,
and more work on the PCI support front. In addition some cleanup and
the usual bug fixing.

Christian Borntraeger (1):
      s390/kvm: Provide function for setting the guest storage key

Hannes Reinecke (9):
      s390/dasd: Clarify comment
      s390/dasd: make number of retries configurable
      s390/dasd: process all requests in the device tasklet
      s390/dasd: Implement block timeout handling
      s390/dasd: Reduce amount of messages for specific errors
      block/dasd: detailed I/O errors
      block: check for timeout function in blk_rq_timed_out()
      s390/dasd: Add 'timeout' attribute
      s390/dasd: Fail all requests when DASD_FLAG_ABORTIO is set

Heiko Carstens (1):
      s390/smp: get rid of generic_smp_call_function_interrupt

Hendrik Brueckner (1):
      s390/hwsampler: Updated misleading member names in hws_data_entry

Martin Schwidefsky (4):
      s390/sclp: add parameter to specify number of buffer pages
      s390/irq: store interrupt information in pt_regs
      s390/pci: remove per device debug attribute
      s390/airq: simplify adapter interrupt code

Michael Holzheu (5):
      s390/cio: Introduce generic synchronous CHSC IOCTL
      s390/cio: Make /dev/chsc a single-open device
      s390/cio: Introduce on-close CHSC IOCTLs
      s390/sclp: Add SCLP character device driver
      s390/chsc: Use snprintf instead of sprintf

Michael Mueller (1):
      s390/facility: decompose test_facility()

Sebastian Ott (14):
      s390/pci: use to_pci_dev
      s390/qdio: remove unused function
      s390: remove virt_to_phys implementation
      pci: add pcibios_release_device
      s390/pci: implement pcibios_release_device
      s390/pci: cleanup hotplug code
      s390/pci: remove pdev during unplug
      s390/pci: sysfs remove strlen
      s390/qdio: cleanup chsc SSQD usage
      s390/qdio: cleanup chsc SADC usage
      s390/dma: remove gratuitous brackets
      s390/vmwatchdog: do not use static data
      s390/appldata_mem: do not use static data
      s390/appldata_net_sum: do not use static data

Thomas Meyer (5):
      s390/ap_bus: Cocci spatch "ptr_ret.spatch"
      s390/dasd: Cocci spatch "ptr_ret.spatch"
      s390/net: Cocci spatch "ptr_ret.spatch"
      s390/hypfs: Cocci spatch "ptr_ret.spatch"
      s390/drivers: Cocci spatch "ptr_ret.spatch"

Wei Yongjun (1):
      s390/sclp: remove duplicated include from sclp_ctl.c

 Documentation/ioctl/ioctl-number.txt  |    1 +
 arch/s390/appldata/appldata_mem.c     |   18 +++-
 arch/s390/appldata/appldata_net_sum.c |   18 +++-
 arch/s390/hypfs/hypfs_diag.c          |    8 +-
 arch/s390/include/asm/airq.h          |   15 ++-
 arch/s390/include/asm/dma-mapping.h   |    2 +-
 arch/s390/include/asm/facility.h      |   17 ++--
 arch/s390/include/asm/io.h            |   22 -----
 arch/s390/include/asm/pci.h           |    2 -
 arch/s390/include/asm/pgalloc.h       |    3 +
 arch/s390/include/asm/ptrace.h        |    1 +
 arch/s390/include/uapi/asm/Kbuild     |    1 +
 arch/s390/include/uapi/asm/chsc.h     |   13 +++
 arch/s390/include/uapi/asm/dasd.h     |    4 +
 arch/s390/include/uapi/asm/sclp_ctl.h |   24 +++++
 arch/s390/kernel/asm-offsets.c        |    1 +
 arch/s390/kernel/entry.S              |   12 ++-
 arch/s390/kernel/entry.h              |    2 +-
 arch/s390/kernel/entry64.S            |   16 +++-
 arch/s390/kernel/irq.c                |    8 +-
 arch/s390/kernel/smp.c                |    5 +-
 arch/s390/mm/pgtable.c                |   48 ++++++++++
 arch/s390/oprofile/hwsampler.h        |    4 +-
 arch/s390/pci/pci.c                   |   83 ++++++++--------
 arch/s390/pci/pci_clp.c               |    1 -
 arch/s390/pci/pci_debug.c             |   29 ------
 arch/s390/pci/pci_dma.c               |    6 +-
 arch/s390/pci/pci_sysfs.c             |   20 ++--
 block/blk-core.c                      |    3 +
 block/blk-timeout.c                   |    5 +-
 drivers/pci/hotplug/s390_pci_hpc.c    |   60 ++++++++----
 drivers/pci/pci.c                     |   10 ++
 drivers/pci/probe.c                   |    1 +
 drivers/s390/block/dasd.c             |  115 ++++++++++++++++++++---
 drivers/s390/block/dasd_devmap.c      |   97 +++++++++++++++++++
 drivers/s390/block/dasd_diag.c        |    8 +-
 drivers/s390/block/dasd_eckd.c        |   17 +++-
 drivers/s390/block/dasd_erp.c         |    8 ++
 drivers/s390/block/dasd_fba.c         |   10 +-
 drivers/s390/block/dasd_int.h         |   10 ++
 drivers/s390/block/dasd_ioctl.c       |   59 ++++++++++++
 drivers/s390/char/Makefile            |    2 +-
 drivers/s390/char/sclp.c              |   86 +++++++++++++++--
 drivers/s390/char/sclp.h              |    7 +-
 drivers/s390/char/sclp_cmd.c          |   20 ++--
 drivers/s390/char/sclp_con.c          |   31 +++++-
 drivers/s390/char/sclp_ctl.c          |  144 ++++++++++++++++++++++++++++
 drivers/s390/char/sclp_vt220.c        |   39 +++++++-
 drivers/s390/char/tape_class.c        |    2 +-
 drivers/s390/char/vmwatchdog.c        |    5 +-
 drivers/s390/cio/airq.c               |  167 +++++++++++----------------------
 drivers/s390/cio/chsc.c               |   60 ++++++++++++
 drivers/s390/cio/chsc.h               |   44 +++++++--
 drivers/s390/cio/chsc_sch.c           |  155 +++++++++++++++++++++++++++++-
 drivers/s390/cio/cio.c                |   68 ++++++--------
 drivers/s390/cio/qdio.h               |   34 -------
 drivers/s390/cio/qdio_main.c          |   44 ---------
 drivers/s390/cio/qdio_setup.c         |   47 ++++------
 drivers/s390/cio/qdio_thinint.c       |   79 ++++++----------
 drivers/s390/crypto/ap_bus.c          |   64 +++++++------
 drivers/s390/net/claw.c               |    2 +-
 drivers/s390/net/ctcm_main.c          |    2 +-
 drivers/s390/net/lcs.c                |    2 +-
 drivers/s390/net/qeth_core_main.c     |    2 +-
 include/linux/pci.h                   |    1 +
 65 files changed, 1325 insertions(+), 569 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/sclp_ctl.h
 create mode 100644 drivers/s390/char/sclp_ctl.c

