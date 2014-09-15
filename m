Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaIOUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:05:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbaIOTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/71] 3.10.55-stable review
Date: Mon, 15 Sep 2014 12:25:58 -0700
Message-Id: <20140915192638.702282534@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.55 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Sep 17 19:26:27 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.55-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.55-rc1

Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    tpm: Provide a generic means to override the chip returned timeouts

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: fix bad hashing of dentries

Al Viro <viro@zeniv.linux.org.uk>
    dcache.c: get rid of pointless macros

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix deadlock between host removal and multipathd

Tejun Heo <tj@kernel.org>
    blkcg: don't call into policy draining if root_blkg is already gone

Roger Quadros <rogerq@ti.com>
    mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Kevin Hao <haokexin@gmail.com>
    mtd/ftl: fix the double free of the buffers allocated in build_maps()

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong restart readdir for SMB1

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong filename length for SMB2

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong directory attributes after rename

Steve French <smfrench@gmail.com>
    CIFS: Possible null ptr deref in SMB2_tcon

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix async reading on reconnects

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: do not hard code max auth ticket len

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: add process_one_ticket() helper

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly

NeilBrown <neilb@suse.de>
    md/raid1,raid10: always abort recover on write error.

Chris Mason <clm@fb.com>
    xfs: don't zero partial page cache pages during O_DIRECT write

Dave Chinner <dchinner@redhat.com>
    xfs: don't zero partial page cache pages during O_DIRECT writes

Dave Chinner <dchinner@redhat.com>
    xfs: don't dirty buffers beyond EOF

Dave Chinner <dchinner@redhat.com>
    xfs: quotacheck leaves dquot buffers without verifiers

Steve Wise <swise@opengridcomputing.com>
    RDMA/iwcm: Use a default listen backlog if needed

NeilBrown <neilb@suse.de>
    md/raid10: Fix memory leak when raid10 reshape completes.

NeilBrown <neilb@suse.de>
    md/raid10: fix memory leak when reshaping a RAID10.

NeilBrown <neilb@suse.de>
    md/raid6: avoid data corruption during recovery of double-degraded RAID6

Vignesh Raman <Vignesh_Raman@mentor.com>
    Bluetooth: Avoid use of session socket after the session gets freed

Vladimir Davydov <vdavydov@parallels.com>
    Bluetooth: never linger on process exit

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Add tests for unprivileged remount cases that have found to be faulty

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Change the default remount atime from relatime to the existing value

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Correct permission checks in do_remount

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Only change user settable mount flags in remount

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Up rb_iter_peek() loop count to 3

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Always reset iterator to reader page

Jiri Kosina <jkosina@suse.cz>
    ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Run fixed event device notifications in process context

David E. Box <david.e.box@linux.intel.com>
    ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

Ben Hutchings <ben@decadent.org.uk>
    bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address

Daniel Mack <zonque@gmail.com>
    ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: max98090: Fix missing free_irq

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: samsung: Correct I2S DAI suspend/resume ops

Praveen Diwakar <praveen.diwakar@intel.com>
    ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou <zhouqiao@marvell.com>
    ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Jonas Bonn <jonas@southpole.se>
    openrisc: Rework signal handling

Ralf Baechle <ralf@linux-mips.org>
    MIPS: Fix accessing to per-cpu data when flushing the cache

Aaro Koskinen <aaro.koskinen@nsn.com>
    MIPS: OCTEON: make get_system_type() thread-safe

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Ralf Baechle <ralf@linux-mips.org>
    MIPS: Cleanup flags in syscall flags handlers.

Alex Smith <alex@alex-smith.me.uk>
    MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the same time

Huacai Chen <chenhc@lemote.com>
    MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Huacai Chen <chenhc@lemote.com>
    MIPS: tlbex: Fix a missing statement for HUGETLB

Paul Burton <paul.burton@imgtec.com>
    MIPS: Prevent user from setting FCSR cause bits

Jeffrey Deans <jeffrey.deans@imgtec.com>
    MIPS: GIC: Prevent array overrun

K. Y. Srinivasan <kys@microsoft.com>
    drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Implement a eh_timed_out handler

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/pseries: Failure on removing device node

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/mm: Use read barrier when creating real_pte

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    powerpc/mm/numa: Fix break placement

Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
    regulator: arizona-ldo1: remove bypass functionality

Michael Welling <mwelling@emacinc.com>
    mfd: omap-usb-host: Fix improper mask use.

Sasha Levin <sasha.levin@oracle.com>
    kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Eric Paris <eparis@redhat.com>
    CAPABILITIES: remove undefined caps from all processes

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: missing tpm_chip_put in tpm_get_random()

Guenter Roeck <linux@roeck-us.net>
    firmware: Do not use WARN_ON(!spin_is_locked())

Mark A. Greer <mgreer@animalcreek.com>
    spi: omap2-mcspi: Configure hardware when slave driver changes mode

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    spi: orion: fix incorrect handling of cell-index DT property

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix cleanup_domain for mass device removal

Salva Peiró <speiro@ai2.upv.es>
    media: media-device: Remove duplicated memset() in media_enum_entities()

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: au0828: Only alt setting logic when needed

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: xc4000: Fix get_frequency()

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: xc5000: Fix get_frequency()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/cavium-octeon/setup.c                    |  18 +-
 arch/mips/include/asm/reg.h                        | 260 +++++++++++++--------
 arch/mips/include/asm/thread_info.h                |   2 +
 arch/mips/kernel/binfmt_elfo32.c                   |  32 ++-
 arch/mips/kernel/irq-gic.c                         |   6 +-
 arch/mips/kernel/ptrace.c                          |   3 +-
 arch/mips/kernel/scall32-o32.S                     |   2 +-
 arch/mips/kernel/scall64-64.S                      |   2 +-
 arch/mips/kernel/scall64-n32.S                     |   2 +-
 arch/mips/kernel/scall64-o32.S                     |   2 +-
 arch/mips/kernel/unaligned.c                       |   1 -
 arch/mips/mm/c-r4k.c                               |   5 +
 arch/mips/mm/tlbex.c                               |   1 +
 arch/openrisc/kernel/entry.S                       |  59 ++---
 arch/openrisc/kernel/signal.c                      | 198 ++++++++--------
 arch/powerpc/include/asm/pte-hash64-64k.h          |  32 ++-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 block/blk-cgroup.c                                 |   7 +
 drivers/acpi/acpica/utcopy.c                       |   6 +
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/acpi/scan.c                                |  15 +-
 drivers/char/tpm/tpm.c                             |  69 ++++--
 drivers/char/tpm/tpm.h                             |   3 +
 drivers/char/tpm/tpm_tis.c                         |  31 +++
 drivers/firmware/efi/vars.c                        |   8 +-
 drivers/infiniband/core/iwcm.c                     |  27 +++
 drivers/infiniband/ulp/srp/ib_srp.c                |  38 ++-
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/md/raid1.c                                 |   8 +-
 drivers/md/raid10.c                                |  11 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/media/media-device.c                       |   2 -
 drivers/media/tuners/xc4000.c                      |  20 +-
 drivers/media/tuners/xc5000.c                      |  22 +-
 drivers/media/usb/au0828/au0828-video.c            |  34 +--
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/mtd/ftl.c                                  |   1 -
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/regulator/arizona-ldo1.c                   |   2 -
 drivers/scsi/bfa/bfa_ioc.h                         |   2 +-
 drivers/scsi/storvsc_drv.c                         |  19 ++
 drivers/spi/spi-omap2-mcspi.c                      |  14 ++
 drivers/spi/spi-orion.c                            |  10 +-
 fs/cifs/cifsglob.h                                 |   5 -
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/inode.c                                    |   6 +
 fs/cifs/readdir.c                                  |   4 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2inode.c                                |   2 +-
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/cifs/smb2pdu.c                                  |   5 +-
 fs/dcache.c                                        |   5 +-
 fs/namei.c                                         |   4 +-
 fs/namespace.c                                     |  59 ++++-
 fs/proc/array.c                                    |  11 +-
 fs/xfs/xfs_aops.c                                  |  61 +++++
 fs/xfs/xfs_dquot.c                                 |   3 +-
 fs/xfs/xfs_file.c                                  |  21 +-
 fs/xfs/xfs_qm.c                                    |   8 +-
 include/linux/capability.h                         |   5 +-
 include/linux/mount.h                              |   9 +-
 kernel/audit.c                                     |   2 +-
 kernel/capability.c                                |   4 +
 kernel/smp.c                                       |   2 +-
 kernel/trace/ring_buffer.c                         |  31 ++-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/rfcomm/core.c                        |   7 +-
 net/bluetooth/rfcomm/sock.c                        |   3 +-
 net/bluetooth/sco.c                                |   6 +-
 net/ceph/auth_x.c                                  | 256 ++++++++++----------
 net/ceph/messenger.c                               |   2 +-
 security/commoncap.c                               |   3 +
 sound/soc/codecs/max98090.c                        |   2 +-
 sound/soc/codecs/wm_adsp.c                         |   2 +
 sound/soc/pxa/pxa-ssp.c                            |   4 +-
 sound/soc/samsung/i2s.c                            |  16 +-
 sound/soc/soc-pcm.c                                |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mount/Makefile             |  17 ++
 .../selftests/mount/unprivileged-remount-test.c    | 242 +++++++++++++++++++
 83 files changed, 1261 insertions(+), 563 deletions(-)


