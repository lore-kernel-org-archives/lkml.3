Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3ASB0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:26:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:57149 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab3ASBWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/16] 3.0.60-stable review
Date: Fri, 18 Jan 2013 17:21:38 -0800
Message-Id: <20130119012138.680057206@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.60 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jan 21 01:20:05 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.60-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.60-rc1

Ben Hutchings <ben@decadent.org.uk>
    staging: vt6656: Fix inconsistent structure packing

chao bi <chao.bi@intel.com>
    serial:ifx6x60:Delete SPI timer when shut down port

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on ONDA MT8205 4G LTE

Bjørn Mork <bjorn@mork.no>
    USB: option: add TP-LINK HSUPA Modem MA180

Andrew Cooper <andrew.cooper3@citrix.com>
    xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.

Julius Werner <jwerner@chromium.org>
    xhci: fix null-pointer dereference when destroying half-built segment rings

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: add missing part_round_stats to _drbd_start_io_acct

Tom Mingarelli <thomas.mingarelli@hp.com>
    intel-iommu: Prevent devices with RMRRs from being placed into SI Domain

Alan Stern <stern@rowland.harvard.edu>
    USB: fix endpoint-disabling for failed config changes

Shuah Khan <shuah.khan@hp.com>
    powerpc: fix wii_memory_fixups() compile error on 3.0.y tree

Eric Sandeen <sandeen@redhat.com>
    ext4: init pagevec in ext4_da_block_invalidatepages

Jesse Barnes <jbarnes@virtuousgeek.org>
    x86/Sandy Bridge: reserve pages when integrated graphics is present

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/time: fix sched_clock() overflow

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not report target role when target is not defined

Mark Rustad <mark.d.rustad@intel.com>
    tcm_fc: Do not indicate retry capability to initiators

Thomas Schwinge <thomas@codesourcery.com>
    sh: Fix FDPIC binary loader


-------------

Diffstat:

 Makefile                                 |  4 +--
 arch/powerpc/platforms/embedded6xx/wii.c |  6 ++--
 arch/s390/include/asm/timex.h            | 28 ++++++++++++++++++
 arch/s390/kernel/time.c                  |  2 +-
 arch/s390/kvm/interrupt.c                |  2 +-
 arch/sh/include/asm/elf.h                |  4 +--
 arch/x86/kernel/entry_32.S               |  1 -
 arch/x86/kernel/setup.c                  | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_req.c            |  1 +
 drivers/pci/intel-iommu.c                | 31 ++++++++++++++++++++
 drivers/staging/vt6656/bssdb.h           |  1 -
 drivers/staging/vt6656/int.h             |  1 -
 drivers/staging/vt6656/iocmd.h           | 33 +++++++++++-----------
 drivers/staging/vt6656/iowpa.h           |  8 ++----
 drivers/target/tcm_fc/tfc_sess.c         | 12 ++++++--
 drivers/tty/serial/ifx6x60.c             |  1 +
 drivers/usb/core/message.c               | 53 +++++++++++++++++++---------------
 drivers/usb/host/xhci-mem.c              | 11 ++++++--
 drivers/usb/serial/option.c              |  9 +++++-
 fs/ext4/inode.c                          |  2 ++
 20 files changed, 227 insertions(+), 61 deletions(-)


