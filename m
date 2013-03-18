Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3CRVHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3CRVHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/48] 3.4.37-stable review
Date: Mon, 18 Mar 2013 14:08:08 -0700
Message-Id: <20130318210810.247845918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.37 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar 20 21:07:59 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.37-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.37-rc1

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    6lowpan: Fix endianness issue in is_addr_link_local().

Mathias Krause <minipli@googlemail.com>
    dcbnl: fix various netlink info leaks

Mathias Krause <minipli@googlemail.com>
    rtnl: fix info leak on RTM_GETLINK request for VF devices

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: stop multicast forwarding to process interface scoped addresses

Cristian Bercaru <B43982@freescale.com>
    bridging: fix rx_handlers return code

Paul Moore <pmoore@redhat.com>
    netlabel: correctly list all the static label mappings

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.

Eric Dumazet <edumazet@google.com>
    tun: add a missing nf_reset() in tun_net_xmit()

Neal Cardwell <ncardwell@google.com>
    tcp: fix double-counted receiver RTT when leaving receiver fast path

Lorenzo Colitti <lorenzo@google.com>
    net: ipv6: Don't purge default router if accept_ra=2

Cong Wang <amwang@redhat.com>
    rds: limit the size allocated by rds_message_alloc()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Restore socket refcount when sendmsg succeeds

Stéphane Marchesin <marcheu@chromium.org>
    drm/i915: Increase the RC6p threshold.

Guo Chao <yan@linux.vnet.ibm.com>
    loopdev: remove an user triggerable oops

Guo Chao <yan@linux.vnet.ibm.com>
    loopdev: fix a deadlock

Guo Chao <yan@linux.vnet.ibm.com>
    block: use i_size_write() in bd_set_size()

Ben Hutchings <ben@decadent.org.uk>
    hwmon: (sht15) Fix memory leak if regulator_enable() fails

Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>
    drm/i915: EBUSY status handling added to i915_gem_fault().

Johan Hovold <jhovold@gmail.com>
    atmel_lcdfb: fix 16-bpp modes on older SOCs

Eric Sandeen <sandeen@redhat.com>
    btrfs: use rcu_barrier() to wait for bdev puts at unmount

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/mm: fix flush_tlb_kernel_range()

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: critical section cleanup vs. machine checks

David Rientjes <rientjes@google.com>
    perf,x86: fix link failure for non-Intel configs

Linus Torvalds <torvalds@linux-foundation.org>
    perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

Dan Carpenter <dan.carpenter@oracle.com>
    selinux: use GFP_ATOMIC under spin_lock

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix cputable entry for 970MP rev 1.0

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix STAB initialization

Marcin Jurkowski <marcin1j@gmail.com>
    w1: fix oops when w1_search is called from netlink connector

Axel Lin <axel.lin@ingics.com>
    hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Fix temperature reporting

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Stephane Eranian <eranian@google.com>
    perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Jiri Slaby <jslaby@suse.cz>
    TTY: do not reset master's packet mode

Paul Bolle <pebolle@tiscali.nl>
    tty: serial: fix typo "ARCH_S5P6450"

Wang YanQing <udknight@gmail.com>
    serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller

Lars-Peter Clausen <lars@metafoo.de>
    ext3: Fix format string issues

Kees Cook <keescook@chromium.org>
    signal: always clear sa_restorer on execve

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix oops on resume from suspend.

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: don't check DMA values in QH overlays

Bjørn Mork <bjorn@mork.no>
    USB: storage: fix Huawei mode switching regression

Steve Conklin <sconklin@canonical.com>
    usb: serial: Add Rigblaster Advantage to device table

Christian Schmiedl <christian.schmiedl@gemalto.com>
    USB: added support for Cinterion's products AH6 and PLS8

Matwey V. Kornilov <matwey@sai.msu.ru>
    usb: cp210x new Vendor/Device IDs

Oliver Neukum <oneukum@suse.de>
    USB: cdc-wdm: fix buffer overflow

Bjørn Mork <bjorn@mork.no>
    USB: option: add Huawei E5331

Amit Shah <amit.shah@redhat.com>
    virtio: rng: disallow multiple device registrations, fixes crashes

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Don't disable a PCI device that is already disabled.

Dan Williams <dcbw@redhat.com>
    qcaux: add Franklin U600


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/powerpc/kernel/cputable.c            |   2 +-
 arch/powerpc/mm/hash_utils_64.c           |   2 +
 arch/s390/include/asm/tlbflush.h          |   2 -
 arch/s390/kernel/entry.S                  |   3 +-
 arch/s390/kernel/entry64.S                |   5 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  10 +
 arch/x86/power/cpu.c                      |   2 +
 drivers/block/loop.c                      |  24 ++-
 drivers/char/hw_random/virtio-rng.c       |  13 +-
 drivers/gpu/drm/i915/i915_gem.c           |   5 +
 drivers/gpu/drm/i915/intel_display.c      |   2 +-
 drivers/hwmon/lineage-pem.c               |   2 +
 drivers/hwmon/pmbus/ltc2978.c             |  14 +-
 drivers/hwmon/sht15.c                     |   2 +-
 drivers/net/macvlan.c                     |   1 +
 drivers/net/tun.c                         |   2 +
 drivers/staging/vt6656/main_usb.c         |   4 -
 drivers/tty/pty.c                         |   1 -
 drivers/tty/serial/8250/8250_pci.c        |   4 +
 drivers/tty/serial/Kconfig                |   2 +-
 drivers/usb/class/cdc-wdm.c               |  23 ++-
 drivers/usb/host/ehci-q.c                 |  18 +-
 drivers/usb/serial/cp210x.c               |  20 ++
 drivers/usb/serial/option.c               |   5 +
 drivers/usb/serial/qcaux.c                |   1 +
 drivers/usb/storage/initializers.c        |  76 +------
 drivers/usb/storage/initializers.h        |   4 +-
 drivers/usb/storage/unusual_devs.h        | 329 +++++++++++++++++++++++++++++-
 drivers/video/atmel_lcdfb.c               |  22 +-
 drivers/w1/w1.c                           |   3 +-
 drivers/xen/xen-pciback/pciback_ops.c     |   3 +-
 fs/block_dev.c                            |   4 +-
 fs/btrfs/volumes.c                        |   6 +
 fs/ext3/super.c                           |   4 +-
 include/linux/perf_event.h                |   6 +
 include/video/atmel_lcdc.h                |   1 +
 kernel/signal.c                           |   3 +
 net/core/dev.c                            |   1 +
 net/core/rtnetlink.c                      |   1 +
 net/dcb/dcbnl.c                           |   7 +
 net/ieee802154/6lowpan.h                  |   2 +-
 net/ipv4/tcp_input.c                      |   6 +-
 net/ipv6/ip6_input.c                      |   3 +-
 net/ipv6/route.c                          |   3 +-
 net/l2tp/l2tp_ppp.c                       |   1 +
 net/netlabel/netlabel_unlabeled.c         |  27 +--
 net/rds/message.c                         |   3 +
 security/selinux/xfrm.c                   |   2 +-
 sound/core/seq/seq_timer.c                |   8 +-
 50 files changed, 541 insertions(+), 157 deletions(-)


