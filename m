Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaJMCd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:33:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaJMCal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 00/25] 3.17.1-stable review
Date: Mon, 13 Oct 2014 04:24:53 +0200
Message-Id: <20141013022454.289398272@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.1 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 15 02:24:45 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.1-rc1

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    serial: 8250: Add Quark X1000 to 8250_pci.c

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    driver/base/node: remove unnecessary kfree of node struct from unregister_one_node

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - fix addressing of struct member

Lu Baolu <baolu.lu@linux.intel.com>
    USB: Add device quirk for ASUS T100 Base Station keyboard

Felipe Balbi <balbi@ti.com>
    usb: musb: dsps: kill OTG timer on suspend

Andreas Bomholtz <andreas@seluxit.com>
    USB: cp210x: add support for Seluxit USB dongle

Joe Savage <joe.savage@goketra.com>
    USB: serial: cp210x: added Ketra N1 wireless interface support

Felipe Balbi <balbi@ti.com>
    Revert "usb: gadget: composite: dequeue cdev->req before free it in composite_dev_cleanup"

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: f_fs: signedness bug in __ffs_func_bind_do_descs()

Hans de Goede <hdegoede@redhat.com>
    uas: Add another ASM1051 usb-id to the uas blacklist

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives

Hans de Goede <hdegoede@redhat.com>
    uas: Add no-report-opcodes quirk

Hans de Goede <hdegoede@redhat.com>
    uas: Add a quirk for rejecting ATA_12 and ATA_16 commands

Yinghai Lu <yinghai@kernel.org>
    PCI: pciehp: Fix wait time in timeout message

Frederic Weisbecker <fweisbec@gmail.com>
    arm: Tell irq work about self IPI support

Frederic Weisbecker <fweisbec@gmail.com>
    x86: Tell irq work about self IPI support

Frederic Weisbecker <fweisbec@gmail.com>
    irq_work: Force raised irq work to run on irq work interrupt

Peter Zijlstra <peterz@infradead.org>
    irq_work: Introduce arch_irq_work_has_interrupt()

WANG Cong <xiyou.wangcong@gmail.com>
    net_sched: copy exts->type in tcf_exts_change()

Sylvain \\\"ythier\\\" Hitier <sylvain.hitier@gmail.com>
    3c59x: fix bad split of cpu_to_le32(pci_map_single())

Vlad Yasevich <vyasevich@gmail.com>
    sctp: handle association restarts when the socket is closed.

KY Srinivasan <kys@microsoft.com>
    hyperv: Fix a bug in netvsc_send()

Joe Lawrence <Joe.Lawrence@stratus.com>
    team: avoid race condition in scheduling delayed work

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: fix bcm_sysport_insert_tsb()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6_gre: fix flowi6_proto value in xmit path


-------------

Diffstat:

 Documentation/kernel-parameters.txt        |  4 +++
 Makefile                                   |  4 +--
 arch/alpha/include/asm/Kbuild              |  1 +
 arch/arc/include/asm/Kbuild                |  1 +
 arch/arm/include/asm/irq_work.h            | 11 ++++++++
 arch/arm/kernel/smp.c                      |  2 +-
 arch/arm64/include/asm/Kbuild              |  3 +-
 arch/avr32/include/asm/Kbuild              |  1 +
 arch/blackfin/include/asm/Kbuild           |  1 +
 arch/c6x/include/asm/Kbuild                |  1 +
 arch/cris/include/asm/Kbuild               |  1 +
 arch/frv/include/asm/Kbuild                |  1 +
 arch/hexagon/include/asm/Kbuild            |  1 +
 arch/ia64/include/asm/Kbuild               |  1 +
 arch/m32r/include/asm/Kbuild               |  1 +
 arch/m68k/include/asm/Kbuild               |  1 +
 arch/metag/include/asm/Kbuild              |  1 +
 arch/microblaze/include/asm/Kbuild         |  1 +
 arch/mips/include/asm/Kbuild               |  1 +
 arch/mn10300/include/asm/Kbuild            |  1 +
 arch/openrisc/include/asm/Kbuild           |  1 +
 arch/parisc/include/asm/Kbuild             |  1 +
 arch/powerpc/include/asm/Kbuild            |  1 +
 arch/s390/include/asm/Kbuild               |  1 +
 arch/score/include/asm/Kbuild              |  1 +
 arch/sh/include/asm/Kbuild                 |  1 +
 arch/sparc/include/asm/Kbuild              |  1 +
 arch/tile/include/asm/Kbuild               |  1 +
 arch/um/include/asm/Kbuild                 |  1 +
 arch/unicore32/include/asm/Kbuild          |  1 +
 arch/x86/include/asm/irq_work.h            | 11 ++++++++
 arch/x86/kernel/irq_work.c                 |  2 +-
 arch/xtensa/include/asm/Kbuild             |  1 +
 drivers/base/node.c                        |  1 -
 drivers/crypto/caam/caamhash.c             |  6 ++--
 drivers/net/ethernet/3com/3c59x.c          |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c | 13 +++++----
 drivers/net/hyperv/netvsc.c                | 15 +++++-----
 drivers/net/team/team.c                    |  4 +--
 drivers/pci/hotplug/pciehp_hpc.c           |  2 +-
 drivers/tty/serial/8250/8250_pci.c         | 21 ++++++++++++++
 drivers/usb/core/hub.c                     |  6 ++--
 drivers/usb/core/quirks.c                  |  4 +++
 drivers/usb/gadget/composite.c             |  1 -
 drivers/usb/gadget/function/f_fs.c         |  3 +-
 drivers/usb/musb/musb_dsps.c               |  2 ++
 drivers/usb/serial/cp210x.c                |  2 ++
 drivers/usb/storage/uas.c                  | 17 +++++++++++
 drivers/usb/storage/unusual_uas.h          | 45 +++++++++++++++++++++++-------
 drivers/usb/storage/usb.c                  |  9 +++++-
 include/asm-generic/irq_work.h             | 10 +++++++
 include/linux/irq_work.h                   |  3 ++
 include/linux/usb/quirks.h                 |  3 ++
 include/linux/usb_usual.h                  |  4 +++
 include/net/sctp/command.h                 |  2 +-
 kernel/irq_work.c                          | 15 ++++++++--
 kernel/time/timer.c                        |  2 +-
 net/ipv6/ip6_gre.c                         |  4 +--
 net/sched/cls_api.c                        |  1 +
 net/sctp/sm_statefuns.c                    | 19 +++++++++++--
 60 files changed, 229 insertions(+), 50 deletions(-)


