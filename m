Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaEDP4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:56:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaEDPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/43] 3.4.89-stable review
Date: Sun,  4 May 2014 11:41:54 -0400
Message-Id: <20140504154224.211508175@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.89 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May  6 15:42:07 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.89-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.89-rc1

Aaron Sanders <aaron.sanders@hp.com>
    USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Theodore Ts'o <tytso@mit.edu>
    ext4: use i_size_read in ext4_unaligned_aio()

alex chen <alex.chen@huawei.com>
    ocfs2: do not put bh when buffer_uptodate failed

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: dlm: fix recovery hung

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: dlm: fix lock migration crash

Liu Hua <sdu.liu@huawei.com>
    hung_task: check the value of "sysctl_hung_task_timeout_sec"

Mizuma, Masayoshi <m.mizuma@jp.fujitsu.com>
    mm: hugetlb: fix softlockup when a large number of hugepages are freed.

Matt Fleming <matt.fleming@intel.com>
    sh: fix format string bug in stack tracer

Alan Stern <stern@rowland.harvard.edu>
    USB: unbind all interfaces before rebinding any

Paul Gortmaker <paul.gortmaker@windriver.com>
    hvc: ensure hvc_init is only ever called once in hvc_console.c

Huang Rui <ray.huang@amd.com>
    usb: dwc3: fix wrong bit mask in dwc3_event_devt

David Cohen <david.a.cohen@linux.intel.com>
    usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

Igor Gnatenko <i.gnatenko.brain@gmail.com>
    xhci: extend quirk for Renesas cards

supriya karanth <supriya.karanth@stericsson.com>
    usb: musb: set TXMAXP and AUTOSET for full speed bulk in device mode

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix race in readdir

Andy Grover <agrover@redhat.com>
    target/tcm_fc: Fix use-after-free of ft_tpg

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: arcmsr: upper 32 of dma address lost

Mike Marciniszyn <mike.marciniszyn@intel.com>
    ib_srpt: Use correct ib_sg_dma primitives

Yann Droneaud <ydroneaud@opteya.com>
    IB/ehca: Returns an error on ib_copy_to_udata() failure

Yann Droneaud <ydroneaud@opteya.com>
    IB/mthca: Return an error on ib_copy_to_udata() failure

Yann Droneaud <ydroneaud@opteya.com>
    IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/ipath: Fix potential buffer overrun in sending diag packet routine

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix setclientid encode size

J. Bruce Fields <bfields@redhat.com>
    nfsd: notify_change needs elevated write count

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix test_stateid error reply encoding

J. Bruce Fields <bfields@redhat.com>
    nfsd4: buffer-length check for SUPPATTR_EXCLCREAT

J. Bruce Fields <bfields@redhat.com>
    nfsd4: session needs room for following op to error out

Alan Stern <stern@rowland.harvard.edu>
    USB: fix crash during hotplug of PCI USB controller card

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0

Himangi Saraogi <himangi774@gmail.com>
    staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

David Fries <David@Fries.net>
    w1: fix w1_send_slave dropping a slave id

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1712: Fix boundary checks in PCM pointer ops

W. Trevor King <wking@tremily.us>
    ALSA: hda - Enable beep for ASUS 1015E

Liu Hua <sdu.liu@huawei.com>
    ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Xiangyu Lu <luxiangyu@huawei.com>
    ARM: 8027/1: fix do_div() bug in big-endian systems

Roger Quadros <rogerq@ti.com>
    ARM: OMAP3: hwmod data: Correct clock domains for USB modules

Stefan Sørensen <stefan.sorensen@spectralink.com>
    ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/arm/include/asm/div64.h                 |  2 +-
 arch/arm/kernel/machine_kexec.c              |  7 +++
 arch/arm/mach-omap2/irq.c                    |  8 +++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |  4 +-
 arch/sh/kernel/dumpstack.c                   |  2 +-
 arch/x86/kernel/ldt.c                        | 11 ++++
 drivers/infiniband/hw/ehca/ehca_cq.c         |  1 +
 drivers/infiniband/hw/ipath/ipath_diag.c     | 66 ++++++++-----------
 drivers/infiniband/hw/mthca/mthca_provider.c |  1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 16 +++--
 drivers/mfd/max8925-i2c.c                    |  9 +++
 drivers/mfd/max8997.c                        | 18 ++++++
 drivers/mfd/max8998.c                        |  4 ++
 drivers/scsi/arcmsr/arcmsr_hba.c             |  7 +--
 drivers/staging/rtl8712/rtl871x_recv.c       | 13 ++--
 drivers/staging/serqt_usb2/serqt_usb2.c      |  2 +-
 drivers/target/iscsi/iscsi_target.c          |  4 +-
 drivers/target/tcm_fc/tfc_sess.c             |  1 +
 drivers/tty/hvc/hvc_console.c                |  6 +-
 drivers/usb/core/driver.c                    | 94 +++++++++++++++++-----------
 drivers/usb/core/hcd-pci.c                   |  2 +-
 drivers/usb/core/hub.c                       |  5 +-
 drivers/usb/core/usb.h                       |  2 +-
 drivers/usb/dwc3/core.h                      |  6 +-
 drivers/usb/host/xhci-pci.c                  |  4 +-
 drivers/usb/host/xhci.c                      |  6 +-
 drivers/usb/musb/musb_gadget.c               | 22 ++++++-
 drivers/usb/serial/pl2303.c                  |  3 +
 drivers/usb/serial/pl2303.h                  |  5 +-
 drivers/w1/w1_netlink.c                      | 25 ++++----
 fs/ext4/file.c                               |  2 +-
 fs/nfsd/nfs4proc.c                           |  9 ++-
 fs/nfsd/nfs4xdr.c                            |  5 ++
 fs/nfsd/vfs.c                                |  9 +++
 fs/ocfs2/buffer_head_io.c                    |  2 -
 fs/ocfs2/dlm/dlmrecovery.c                   | 29 ++++++---
 fs/reiserfs/dir.c                            |  6 +-
 kernel/sysctl.c                              |  6 ++
 mm/hugetlb.c                                 |  1 +
 sound/pci/hda/patch_realtek.c                |  1 +
 sound/pci/ice1712/ice1712.c                  | 15 +++--
 sound/soc/codecs/cs42l73.c                   |  6 +-
 44 files changed, 296 insertions(+), 157 deletions(-)


