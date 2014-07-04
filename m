Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031302AbaGDWVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:21:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031266AbaGDWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/46] 3.10.47-stable review
Date: Fri,  4 Jul 2014 15:19:04 -0700
Message-Id: <20140704221602.280733370@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.47 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul  6 22:15:52 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.47-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.47-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Adjust speaker HPF and add LED support for HP Spectre 13

Oleg Nesterov <oleg@redhat.com>
    tracing: Fix syscall_*regfunc() vs copy_process() race

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Try again for saved cmdline if failed due to locking

Jacob Keller <jacob.e.keller@intel.com>
    Documentation/SubmittingPatches: describe the Fixes: tag

Mathias Krause <minipli@googlemail.com>
    netfilter: ipt_ULOG: fix info leaks

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max77693: Fix two NULL pointer exceptions on missing pdata

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix hw ready reset flow

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: read H_CSR after asserting reset

Tejun Heo <tj@kernel.org>
    ptrace,x86: force IRET path after a ptrace_stop()

Peter Christensen <pch@ordbogen.com>
    ipvs: Fix panic due to non-linear skb

Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>
    MIPS: KVM: Fix memory leak on VCPU

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Remove redundant NULL checks before kfree()

Jeff Mahoney <jeffm@suse.com>
    reiserfs: call truncate_setsize under tailpack mutex

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support

Paul Bolle <pebolle@tiscali.nl>
    powerpc: fix typo 'CONFIG_PPC_CPU'

Paul Bolle <pebolle@tiscali.nl>
    powerpc: fix typo 'CONFIG_PMAC'

Anton Blanchard <anton@samba.org>
    powerpc: 64bit sendfile is capped at 2GB

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/pseries: Fix overwritten PE state

Jeff Layton <jlayton@primarydata.com>
    nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG entry

Jeff Layton <jlayton@redhat.com>
    nfsd: don't try to reuse an expired DRC entry off the list

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Don't declare inode uptodate unless all attributes were checked

Christoph Hellwig <hch@lst.de>
    nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix FREE_STATEID lockowner leak

Trond Myklebust <trond.myklebust@primarydata.com>
    pNFS: Handle allocation errors correctly in filelayout_alloc_layout_hdr()

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Fix a module reference leak in svc_handle_xprt

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

Gabor Juhos <juhosg@openwrt.org>
    watchdog: ath79_wdt: avoid spurious restarts on AR934x

Viresh Kumar <viresh.kumar@linaro.org>
    watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

hujianyang <hujianyang@huawei.com>
    UBIFS: Remove incorrect assertion in shrink_tnc()

hujianyang <hujianyang@huawei.com>
    UBIFS: fix an mmap and fsync race condition

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Alex Smith <alex.smith@imgtec.com>
    recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

Asai Thambi S P <asamymuthupa@micron.com>
    mtip32xx: Remove dfs_parent after pci unregister

Asai Thambi S P <asamymuthupa@micron.com>
    mtip32xx: Increase timeout for STANDBY IMMEDIATE command

Asai Thambi S P <asamymuthupa@micron.com>
    mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix incorrect vgaarb conditional in WARN_ON()

Thomas Jarosch <thomas.jarosch@intra2net.com>
    PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - deal with clickpads reporting right button events

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Explicily clear login response PDU in exception path

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Avoid rejecting incorrect ITT for Data-Out

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix left-over se_lun->lun_sep pointer OOPs


-------------

Diffstat:

 Documentation/SubmittingPatches              |  22 ++++-
 Documentation/sound/alsa/HD-Audio-Models.txt |   5 ++
 Makefile                                     |   4 +-
 arch/mips/kernel/irq-msc01.c                 |   2 +-
 arch/mips/kvm/kvm_mips.c                     |  13 +--
 arch/powerpc/include/asm/systbl.h            |   2 +-
 arch/powerpc/include/uapi/asm/cputable.h     |   1 +
 arch/powerpc/kernel/cputable.c               |   3 +-
 arch/powerpc/kernel/time.c                   |   2 +-
 arch/powerpc/lib/sstep.c                     |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |   1 +
 arch/x86/include/asm/ptrace.h                |  16 ++++
 drivers/block/mtip32xx/mtip32xx.c            | 123 ++++++++++++++++++++-------
 drivers/extcon/extcon-max77693.c             |   4 +-
 drivers/infiniband/core/user_mad.c           |  75 +++++++++-------
 drivers/infiniband/hw/ipath/ipath_diag.c     |   4 +
 drivers/infiniband/hw/qib/qib_mad.c          |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   6 ++
 drivers/input/mouse/elantech.c               |  27 ++++--
 drivers/misc/mei/hw-me.c                     |  28 ++++--
 drivers/pci/pci.c                            |   2 +-
 drivers/pci/quirks.c                         |   1 +
 drivers/target/iscsi/iscsi_target.c          |   2 +-
 drivers/target/iscsi/iscsi_target_util.c     |   2 +
 drivers/target/target_core_device.c          |   1 +
 drivers/watchdog/ath79_wdt.c                 |  10 +++
 drivers/watchdog/sp805_wdt.c                 |   4 +-
 fs/nfs/inode.c                               |  26 ++++--
 fs/nfs/nfs4filelayout.c                      |   2 +-
 fs/nfsd/nfs4state.c                          |   2 +-
 fs/nfsd/nfs4xdr.c                            |   4 +-
 fs/nfsd/nfscache.c                           |  53 +++---------
 fs/reiserfs/inode.c                          |   8 +-
 fs/ubifs/file.c                              |   3 +-
 fs/ubifs/shrinker.c                          |   1 -
 include/linux/ptrace.h                       |   3 +
 include/trace/syscall.h                      |  15 ++++
 kernel/fork.c                                |   2 +
 kernel/trace/trace.c                         |  13 +--
 net/ipv4/netfilter/ipt_ULOG.c                |   7 +-
 net/netfilter/ipvs/ip_vs_core.c              |  15 ++--
 net/sunrpc/svc_xprt.c                        |   2 +
 scripts/recordmcount.h                       |   4 +-
 sound/pci/hda/patch_sigmatel.c               |  58 ++++++++++++-
 44 files changed, 401 insertions(+), 181 deletions(-)


