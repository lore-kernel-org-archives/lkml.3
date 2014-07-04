Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031683AbaGDWuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:50:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030742AbaGDWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/19] 3.4.97-stable review
Date: Fri,  4 Jul 2014 15:15:10 -0700
Message-Id: <20140704221436.423715636@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.97 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul  6 22:14:29 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.97-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.97-rc1

Oleg Nesterov <oleg@redhat.com>
    tracing: Fix syscall_*regfunc() vs copy_process() race

Tejun Heo <tj@kernel.org>
    ptrace,x86: force IRET path after a ptrace_stop()

Paul Bolle <pebolle@tiscali.nl>
    powerpc: fix typo 'CONFIG_PPC_CPU'

Paul Bolle <pebolle@tiscali.nl>
    powerpc: fix typo 'CONFIG_PMAC'

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/pseries: Fix overwritten PE state

Christoph Hellwig <hch@lst.de>
    nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix FREE_STATEID lockowner leak

Bart Van Assche <bvanassche@acm.org>
    IB/umad: Fix use-after-free on close

Bart Van Assche <bvanassche@acm.org>
    IB/umad: Fix error handling

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix a sporadic crash triggered by cable pulling

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Fix port in pkey change event

Viresh Kumar <viresh.kumar@linaro.org>
    watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

hujianyang <hujianyang@huawei.com>
    UBIFS: Remove incorrect assertion in shrink_tnc()

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Alex Smith <alex.smith@imgtec.com>
    recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix incorrect vgaarb conditional in WARN_ON()

Thomas Jarosch <thomas.jarosch@intra2net.com>
    PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - deal with clickpads reporting right button events


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/mips/kernel/irq-msc01.c                 |  2 +-
 arch/powerpc/kernel/time.c                   |  2 +-
 arch/powerpc/lib/sstep.c                     |  2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |  1 +
 arch/x86/include/asm/ptrace.h                | 16 ++++++
 drivers/infiniband/core/user_mad.c           | 75 ++++++++++++++++------------
 drivers/infiniband/hw/ipath/ipath_diag.c     |  4 ++
 drivers/infiniband/hw/qib/qib_mad.c          |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |  6 +++
 drivers/input/mouse/elantech.c               | 22 ++++++--
 drivers/pci/pci.c                            |  2 +-
 drivers/pci/quirks.c                         |  1 +
 drivers/watchdog/sp805_wdt.c                 |  4 +-
 fs/nfsd/nfs4state.c                          |  2 +-
 fs/nfsd/nfs4xdr.c                            |  4 +-
 fs/ubifs/shrinker.c                          |  1 -
 include/linux/ptrace.h                       |  3 ++
 include/trace/syscall.h                      | 15 ++++++
 kernel/fork.c                                |  2 +
 scripts/recordmcount.h                       |  4 +-
 21 files changed, 123 insertions(+), 51 deletions(-)


