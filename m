Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab3GSCXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:23:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976Ab3GSCX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:23:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/18] 3.0.87-stable review
Date: Thu, 18 Jul 2013 19:23:15 -0700
Message-Id: <20130719021048.965829361@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.87 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul 21 02:10:01 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.87-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.87-rc1

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Jed Davis <jld@mozilla.com>
    ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Jan Kara <jack@suse.cz>
    ext4: fix overflow when counting used blocks on 32-bit architectures

Jan Kara <jack@suse.cz>
    ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs

Bart Van Assche <bart.vanassche@gmail.com>
    timer: Fix jiffies wrap behavior of round_jiffies_common()

Shane Huang <shane.huang@amd.com>
    ahci: remove pmp link online check in FBS EH

Shane Huang <shane.huang@amd.com>
    ahci: Add AMD CZ SATA device ID

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: xattr: fix inlined xattr reflink

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Axel Lin <axel.lin@ingics.com>
    drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Ben Hutchings <ben@decadent.org.uk>
    genirq: Fix can_request_irq() for IRQs without an action

Laszlo Ersek <lersek@redhat.com>
    xen/time: remove blocked time accounting from xen "clockchip"

Joachim Eastwood <manabian@gmail.com>
    pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check for failed dma pool allocation

UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
    usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Dan Williams <dcbw@redhat.com>
    USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Al Viro <viro@ZenIV.linux.org.uk>
    ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Theodore Ts'o <tytso@mit.edu>
    jbd2: fix theoretical race in jbd2__journal_restart


-------------

Diffstat:

 Makefile                            |  4 ++--
 arch/arm/kernel/perf_event.c        |  1 +
 arch/x86/xen/time.c                 | 17 ++---------------
 drivers/acpi/ec.c                   |  4 ++++
 drivers/ata/ahci.c                  |  1 +
 drivers/ata/libahci.c               |  3 +--
 drivers/dma/pl330.c                 |  4 ++--
 drivers/pci/quirks.c                |  2 ++
 drivers/pcmcia/at91_cf.c            |  4 ++--
 drivers/rtc/rtc-rv3029c2.c          |  2 +-
 drivers/usb/gadget/f_mass_storage.c |  2 ++
 drivers/usb/host/xhci-mem.c         |  4 ++++
 drivers/usb/serial/option.c         |  4 ----
 drivers/usb/serial/qcserial.c       |  8 +++++++-
 fs/ext3/namei.c                     |  7 ++-----
 fs/ext4/extents.c                   |  4 ++--
 fs/ext4/inode.c                     |  4 ++--
 fs/ext4/namei.c                     |  7 ++-----
 fs/jbd2/transaction.c               |  2 +-
 fs/ocfs2/xattr.c                    | 10 ++++++++++
 kernel/irq/manage.c                 |  6 +++---
 kernel/timer.c                      |  8 +++++---
 22 files changed, 58 insertions(+), 50 deletions(-)


