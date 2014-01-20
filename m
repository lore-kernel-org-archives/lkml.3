Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaATIyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:54:39 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:46094 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaATIyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:54:35 -0500
Date: Mon, 20 Jan 2014 09:54:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.14 merge window
Message-ID: <20140120095427.3b59259b@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012008-3548-0000-0000-000007C7328B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The bulk of the s390 updates for v3.14. New features are the perf support
for the CPU-Measurement Sample Facility and the EP11 support for the crypto
cards. And the normal cleanups and bug-fixes.

Eugene Crosser (1):
      s390/qdio: bridgeport support - CHSC part

Heiko Carstens (4):
      s390/smp: only send external call ipi if needed
      s390/smp: reduce memory consumption of pcpu_devices array
      s390: use IS_ENABLED to check if a CONFIG is set to y or m
      s390/compat: fix PSW32_USER_BITS definition

Hendrik Brueckner (19):
      s390/sclp_early: Get rid of sclp_early_read_info_sccb_valid
      s390/sclp_early: Replace early_read_info_sccb with sccb_early
      s390/sclp_early: Pass sccb pointer to every *_detect() function
      s390/sclp_early: Add function to detect sclp console capabilities
      s390/oprofile: move hwsampler interfaces to cpu_mf.h
      s390/cpum_cf: Export event names in sysfs
      s390/perf: add support for the CPU-Measurement Sampling Facility
      s390/perf: Improve PMU selection for PERF_COUNT_HW_CPU_CYCLES events
      s390/perf,oprofile: Share sampling facility
      s390/perf: Add service level information for CPU-Measurement Facilities
      s390/cpum_sf: Dynamically extend the sampling buffer if overflows occur
      s390/cpum_sf: Atomically reset trailer entry fields of sample-data-blocks
      s390/cpum_sf: Add helper to read TOD from trailer entries
      s390/cpum_sf: Detect KVM guest samples
      s390/cpum_sf: Filter perf events based event->attr.exclude_* settings
      s390/cpum_sf: Add raw data sampling to support the diagnostic-sampling function
      s390/cpum_sf: Add flag to process full SDBs only
      s390: Fix misspellings using 'codespell' tool
      s390/cpum_sf: fix printk format warnings

Ingo Tuchscherer (1):
      s390/zcrypt: add support for EP11 coprocessor cards

Martin Schwidefsky (5):
      s390/ptrace: simplify enable/disable single step
      s390: optimize control register update
      s390/3270: fix use after free of tty3270_screen structure
      s390/compat: correct check for EFAULT in rt-signal frame creation
      s390/mm: optimize randomize_et_dyn for !PF_RANDOMIZE

Paul Gortmaker (1):
      s390: delete new instances of __cpuinit usage

Peter Oberparleiter (5):
      s390/cio: More efficient handling of CHPID availability events
      s390/cio: Relax subchannel scan loop
      s390/cio: Delay scan for newly available I/O devices
      s390/css: Prevent unnecessary allocation in subchannel loop
      s390/blacklist: Perform subchannel scan only when needed

Sebastian Ott (8):
      s390/pci: prevent inadvertently triggered bus scans
      s390/pci: fix removal of nonexistent pci bus
      s390/pci: set error state for unavailable functions
      s390/pci/dma: fix accounting of allocated_pages
      s390/pci: reenable per default
      s390/cio: fix unlocked access of online member
      s390/cio: use device_lock to synchronize calls to the ccw driver
      s390/cio: use device_lock to synchronize calls to the ccwgroup driver

 Documentation/kmsg/s390/zcrypt         |   20 +
 arch/s390/include/asm/compat.h         |    3 +-
 arch/s390/include/asm/cpu_mf.h         |  181 ++++
 arch/s390/include/asm/css_chars.h      |    2 +
 arch/s390/include/asm/pci.h            |    1 +
 arch/s390/include/asm/perf_event.h     |   80 +-
 arch/s390/include/asm/qdio.h           |   35 +-
 arch/s390/include/asm/sclp.h           |    4 +-
 arch/s390/include/uapi/asm/zcrypt.h    |   65 ++
 arch/s390/kernel/Makefile              |    3 +-
 arch/s390/kernel/compat_signal.c       |    5 +-
 arch/s390/kernel/entry64.S             |    8 +-
 arch/s390/kernel/perf_cpum_cf.c        |    1 +
 arch/s390/kernel/perf_cpum_cf_events.c |  322 +++++++
 arch/s390/kernel/perf_cpum_sf.c        | 1641 ++++++++++++++++++++++++++++++++
 arch/s390/kernel/perf_event.c          |  174 +++-
 arch/s390/kernel/process.c             |   14 +-
 arch/s390/kernel/ptrace.c              |   27 +-
 arch/s390/kernel/s390_ksyms.c          |    2 +-
 arch/s390/kernel/setup.c               |    2 +-
 arch/s390/kernel/smp.c                 |   19 +-
 arch/s390/kvm/priv.c                   |    2 +-
 arch/s390/lib/uaccess_pt.c             |    4 +-
 arch/s390/mm/pgtable.c                 |    4 +-
 arch/s390/oprofile/hwsampler.c         |   78 +-
 arch/s390/oprofile/hwsampler.h         |   52 +-
 arch/s390/oprofile/init.c              |   23 +-
 arch/s390/pci/pci.c                    |   16 +-
 arch/s390/pci/pci_dma.c                |   13 +-
 arch/s390/pci/pci_event.c              |   26 +-
 drivers/s390/block/dasd.c              |    2 +-
 drivers/s390/char/sclp.h               |    1 -
 drivers/s390/char/sclp_cmd.c           |    2 -
 drivers/s390/char/sclp_early.c         |  125 +--
 drivers/s390/char/tty3270.c            |    7 +-
 drivers/s390/cio/blacklist.c           |    6 +-
 drivers/s390/cio/ccwgroup.c            |   12 +-
 drivers/s390/cio/chsc.c                |   73 +-
 drivers/s390/cio/chsc.h                |   51 +-
 drivers/s390/cio/css.c                 |   26 +-
 drivers/s390/cio/css.h                 |    1 +
 drivers/s390/cio/device.c              |   29 +-
 drivers/s390/cio/qdio_main.c           |   91 ++
 drivers/s390/crypto/ap_bus.c           |   31 +-
 drivers/s390/crypto/ap_bus.h           |    4 +-
 drivers/s390/crypto/zcrypt_api.c       |  109 ++-
 drivers/s390/crypto/zcrypt_api.h       |    2 +
 drivers/s390/crypto/zcrypt_cex4.c      |   20 +-
 drivers/s390/crypto/zcrypt_error.h     |   18 +-
 drivers/s390/crypto/zcrypt_msgtype50.c |   12 +
 drivers/s390/crypto/zcrypt_msgtype6.c  |  260 +++++
 drivers/s390/crypto/zcrypt_msgtype6.h  |    2 +
 drivers/s390/crypto/zcrypt_pcica.c     |   11 +
 drivers/s390/crypto/zcrypt_pcicc.c     |   12 +
 54 files changed, 3383 insertions(+), 351 deletions(-)
 create mode 100644 Documentation/kmsg/s390/zcrypt
 create mode 100644 arch/s390/kernel/perf_cpum_cf_events.c
 create mode 100644 arch/s390/kernel/perf_cpum_sf.c

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

