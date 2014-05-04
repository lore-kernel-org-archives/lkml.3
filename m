Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaEDQSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:18:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaEDPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/86] 3.10.39-stable review
Date: Sun,  4 May 2014 11:40:35 -0400
Message-Id: <20140504154140.444932005@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.39 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May  6 15:41:13 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.39-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.39-rc1

Aaron Sanders <aaron.sanders@hp.com>
    USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Theodore Ts'o <tytso@mit.edu>
    ext4: use i_size_read in ext4_unaligned_aio()

Jan Kara <jack@suse.cz>
    ext4: fix jbd2 warning under heavy xattr load

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

Vlastimil Babka <vbabka@suse.cz>
    mm: try_to_unmap_cluster() should lock_page() before mlocking

Matt Fleming <matt.fleming@intel.com>
    sh: fix format string bug in stack tracer

Felipe Franciosi <felipe@paradoxo.org>
    mtip32xx: Set queue bounce limit

Alan Stern <stern@rowland.harvard.edu>
    USB: unbind all interfaces before rebinding any

Michal Simek <michal.simek@xilinx.com>
    usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Paul Gortmaker <paul.gortmaker@windriver.com>
    hvc: ensure hvc_init is only ever called once in hvc_console.c

Felipe Balbi <balbi@ti.com>
    usb: musb: avoid NULL pointer dereference

Huang Rui <ray.huang@amd.com>
    usb: dwc3: fix wrong bit mask in dwc3_event_devt

Wolfram Sang <wsa@the-dreams.de>
    media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Florian Vaussard <florian.vaussard@epfl.ch>
    media: omap3isp: preview: Fix the crop margins

Hans Verkuil <hans.verkuil@cisco.com>
    media: saa7134: fix WARN_ON during resume

Antti Palosaari <crope@iki.fi>
    media: em28xx: fix PCTV 290e LNA oops

Malcolm Priestley <tvboxspy@gmail.com>
    media: m88rs2000: add caps FE_CAN_INVERSION_AUTO

Malcolm Priestley <tvboxspy@gmail.com>
    media: m88rs2000: prevent frontend crash on continuous transponder scans

Hans Verkuil <hans.verkuil@cisco.com>
    media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support

Oleksij Rempel <linux@rempel-privat.de>
    media: uvcvideo: Do not use usb_set_interface on bulk EP

David Cohen <david.a.cohen@linux.intel.com>
    usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

Igor Gnatenko <i.gnatenko.brain@gmail.com>
    xhci: extend quirk for Renesas cards

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent runtime pm from autosuspending during initialization

Roger Quadros <rogerq@ti.com>
    usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1

Kees Cook <keescook@chromium.org>
    usb: gadget: tcm_usb_gadget: stop format strings

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix race in readdir

Matt Fleming <matt@console-pimps.org>
    x86/efi: Correct EFI boot stub use of code32_start

Andy Grover <agrover@redhat.com>
    target/tcm_fc: Fix use-after-free of ft_tpg

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: arcmsr: upper 32 of dma address lost

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()

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

Jeff Layton <jlayton@redhat.com>
    nfsd: set timeparms.to_maxval in setup_callback_client

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Traverse unconfirmed client through hash-table

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix setclientid encode size

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: check passed socket's net matches NFSd superblock's one

J. Bruce Fields <bfields@redhat.com>
    nfsd: notify_change needs elevated write count

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix test_stateid error reply encoding

J. Bruce Fields <bfields@redhat.com>
    nfsd4: buffer-length check for SUPPATTR_EXCLCREAT

J. Bruce Fields <bfields@redhat.com>
    nfsd4: session needs room for following op to error out

Alec Berg <alecaberg@chromium.org>
    iio: querying buffer scan_mask should return 0/1

Alan Stern <stern@rowland.harvard.edu>
    USB: fix crash during hotplug of PCI USB controller card

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Petr Mladek <pmladek@suse.cz>
    ftrace/x86: One more missing sync after fixup of function modification failure

Mark Tinguely <tinguely@sgi.com>
    xfs: fix directory hash ordering bug

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0

Himangi Saraogi <himangi774@gmail.com>
    staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

David Fries <David@Fries.net>
    w1: fix w1_send_slave dropping a slave id

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: 88pm860x: Fix I2C device resource leak on regmap init fail

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: do not load the driver if the FW doesn't support MEI interface

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/cio: fix driver callback initialization for ccw consoles

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC288 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent speaker output due to mute LED fixup

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1712: Fix boundary checks in PCM pointer ops

W. Trevor King <wking@tremily.us>
    ALSA: hda - Enable beep for ASUS 1015E

Laura Abbott <lauraa@codeaurora.org>
    ARM: 7728/1: mm: Use phys_addr_t properly for ioremap functions

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP

Liu Hua <sdu.liu@huawei.com>
    ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Xiangyu Lu <luxiangyu@huawei.com>
    ARM: 8027/1: fix do_div() bug in big-endian systems

Christopher Covington <cov@codeaurora.org>
    ARM: 8007/1: Remove extraneous kcmp syscall ignore

Will Deacon <will.deacon@arm.com>
    ARM: 7954/1: mm: remove remaining domain support from ARMv6

Tomasz Figa <t.figa@samsung.com>
    ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Roger Quadros <rogerq@ti.com>
    ARM: OMAP3: hwmod data: Correct clock domains for USB modules

Nishanth Menon <nm@ti.com>
    ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Stefan Sørensen <stefan.sorensen@spectralink.com>
    ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Make DMA coherent and strongly ordered mappings not executable

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not synchronise I and D caches for special ptes


-------------

Diffstat:

 Documentation/video4linux/gspca.txt           |  1 +
 Makefile                                      |  4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi          |  1 +
 arch/arm/boot/dts/exynos5250-arndale.dts      |  1 +
 arch/arm/include/asm/div64.h                  |  2 +-
 arch/arm/include/asm/futex.h                  |  6 --
 arch/arm/include/asm/io.h                     |  8 +--
 arch/arm/include/asm/pgtable-2level.h         |  1 +
 arch/arm/include/asm/unistd.h                 |  1 -
 arch/arm/kernel/machine_kexec.c               |  7 ++
 arch/arm/mach-ebsa110/core.c                  |  2 +-
 arch/arm/mach-imx/mm-imx3.c                   |  2 +-
 arch/arm/mach-iop13xx/io.c                    |  2 +-
 arch/arm/mach-ixp4xx/common.c                 |  2 +-
 arch/arm/mach-msm/common.h                    |  2 +-
 arch/arm/mach-msm/io.c                        |  2 +-
 arch/arm/mach-omap2/irq.c                     |  8 +++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c    |  4 +-
 arch/arm/mach-omap2/pm.h                      |  2 +-
 arch/arm/mm/Kconfig                           |  3 +-
 arch/arm/mm/ioremap.c                         | 10 +--
 arch/arm/mm/mmu.c                             | 10 +++
 arch/arm/mm/nommu.c                           |  6 +-
 arch/arm/mm/proc-macros.S                     | 19 ++----
 arch/arm/mm/proc-v7-2level.S                  |  7 --
 arch/arm64/include/asm/pgtable.h              |  8 +--
 arch/s390/include/asm/ccwdev.h                |  2 +-
 arch/sh/kernel/dumpstack.c                    |  2 +-
 arch/x86/boot/compressed/eboot.c              |  5 +-
 arch/x86/boot/compressed/head_32.S            | 14 ++--
 arch/x86/boot/compressed/head_64.S            |  9 +--
 arch/x86/kernel/ftrace.c                      |  2 +-
 arch/x86/kernel/ldt.c                         | 11 ++++
 drivers/block/mtip32xx/mtip32xx.c             |  1 +
 drivers/iio/industrialio-buffer.c             |  6 +-
 drivers/infiniband/hw/ehca/ehca_cq.c          |  1 +
 drivers/infiniband/hw/ipath/ipath_diag.c      | 66 +++++++------------
 drivers/infiniband/hw/mthca/mthca_provider.c  |  1 +
 drivers/infiniband/hw/nes/nes_verbs.c         |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c         | 16 +++--
 drivers/media/dvb-frontends/m88rs2000.c       | 19 +++++-
 drivers/media/pci/saa7134/saa7134-cards.c     |  4 +-
 drivers/media/platform/omap3isp/isppreview.c  |  9 +++
 drivers/media/usb/em28xx/em28xx-dvb.c         |  3 +-
 drivers/media/usb/gspca/sn9c20x.c             |  1 +
 drivers/media/usb/uvc/uvc_video.c             | 20 +++++-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 +-
 drivers/mfd/88pm860x-core.c                   |  6 ++
 drivers/mfd/max77686.c                        |  4 ++
 drivers/mfd/max77693.c                        | 12 +++-
 drivers/mfd/max8925-i2c.c                     |  9 +++
 drivers/mfd/max8997.c                         | 18 +++++
 drivers/mfd/max8998.c                         |  4 ++
 drivers/mfd/sec-core.c                        |  4 ++
 drivers/mfd/tps65910.c                        |  4 +-
 drivers/misc/mei/hw-me-regs.h                 |  5 ++
 drivers/misc/mei/pci-me.c                     | 30 +++++++--
 drivers/s390/char/con3215.c                   |  2 +-
 drivers/s390/char/con3270.c                   |  6 +-
 drivers/s390/char/raw3270.c                   | 10 ++-
 drivers/s390/char/raw3270.h                   |  2 +-
 drivers/s390/cio/device.c                     |  3 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |  7 +-
 drivers/scsi/qla2xxx/qla_os.c                 |  6 +-
 drivers/staging/rtl8712/rtl871x_recv.c        | 13 ++--
 drivers/staging/serqt_usb2/serqt_usb2.c       |  2 +-
 drivers/target/iscsi/iscsi_target.c           |  4 +-
 drivers/target/tcm_fc/tfc_sess.c              |  1 +
 drivers/tty/hvc/hvc_console.c                 |  6 +-
 drivers/usb/core/driver.c                     | 94 ++++++++++++++++-----------
 drivers/usb/core/hcd-pci.c                    |  2 +-
 drivers/usb/core/hub.c                        |  5 +-
 drivers/usb/core/usb.h                        |  2 +-
 drivers/usb/dwc3/core.h                       |  6 +-
 drivers/usb/gadget/tcm_usb_gadget.c           |  2 +-
 drivers/usb/gadget/zero.c                     |  2 +-
 drivers/usb/host/xhci-pci.c                   | 15 +++--
 drivers/usb/host/xhci.c                       |  6 +-
 drivers/usb/musb/musb_core.c                  |  5 +-
 drivers/usb/phy/phy-ulpi.c                    |  2 +
 drivers/usb/serial/pl2303.c                   |  3 +
 drivers/usb/serial/pl2303.h                   |  5 +-
 drivers/w1/w1_netlink.c                       | 25 +++----
 fs/ext4/file.c                                |  2 +-
 fs/ext4/xattr.c                               | 23 +++++--
 fs/nfsd/nfs4callback.c                        |  4 +-
 fs/nfsd/nfs4proc.c                            |  9 ++-
 fs/nfsd/nfs4state.c                           | 13 ++--
 fs/nfsd/nfs4xdr.c                             |  5 ++
 fs/nfsd/nfsctl.c                              |  5 ++
 fs/nfsd/vfs.c                                 |  9 +++
 fs/ocfs2/buffer_head_io.c                     |  2 -
 fs/ocfs2/dlm/dlmrecovery.c                    | 29 ++++++---
 fs/reiserfs/dir.c                             |  6 +-
 fs/xfs/xfs_da_btree.c                         |  2 +-
 include/linux/sunrpc/svcsock.h                |  1 +
 kernel/sysctl.c                               |  6 ++
 mm/hugetlb.c                                  |  1 +
 mm/mlock.c                                    |  2 +
 mm/rmap.c                                     | 14 +++-
 net/sunrpc/svcsock.c                          | 16 +++++
 sound/pci/hda/patch_realtek.c                 |  8 ++-
 sound/pci/ice1712/ice1712.c                   | 15 +++--
 sound/soc/codecs/cs42l51.c                    |  9 ++-
 sound/soc/codecs/cs42l52.c                    |  8 +--
 sound/soc/codecs/cs42l73.c                    |  6 +-
 106 files changed, 561 insertions(+), 285 deletions(-)


