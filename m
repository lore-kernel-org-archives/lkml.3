Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLEXIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:08:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaLEXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/45] 3.10.62-stable review
Date: Fri,  5 Dec 2014 14:44:43 -0800
Message-Id: <20141205223316.738290875@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.62 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  7 22:32:54 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.62-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.62-rc1

Sergio Gelato <Sergio.Gelato@astro.su.se>
    nfsd: Fix ACL null pointer deref

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Honor the generic "no_64bit_msi" flag

Maurizio Lombardi <mlombard@redhat.com>
    bnx2fc: do not add shared skbs to the fcoe_rx_list

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix leak of inode reference on delegation failure

Trond Myklebust <trond.myklebust@primarydata.com>
    nfsd: Fix slot wake up race in the nfsv4.1 callback code

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: do not align payload on modern H/W

Thomas Körper <thomas.koerper@esd.eu>
    can: dev: avoid calling kfree_skb() from interrupt context

Thor Thayer <tthayer@opensource.altera.com>
    spi: dw: Fix dynamic speed change.

Sagi Grimberg <sagig@dev.mellanox.co.il>
    iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly

Roland Dreier <roland@purestorage.com>
    target: Don't call TFO->write_pending if data_length == 0

Bart Van Assche <bvanassche@acm.org>
    srp-target: Retry when QP creation fails with ENOMEM

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Input: xpad - use proper endpoint type

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: 8222/1: mvebu: enable strex backoff delay

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Jurgen Kramer <gtmkramer@xs4all.nl>
    ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Alexey Khoroshilov <khoroshilov@ispras.ru>
    can: esd_usb2: fix memory leak on disconnect

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: xhci: don't start a halted endpoint before its new dequeue is set

Hans de Goede <hdegoede@redhat.com>
    usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Troy Clark <tclark@matrixorbital.ca>
    usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Preston Fick <pffick@gmail.com>
    USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix tty line-status reporting

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix overrun-error reporting

Johan Hovold <johan@kernel.org>
    USB: ssu100: fix overrun-error reporting

Cristina Ciocan <cristina.ciocan@intel.com>
    iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Laurent Dufour <ldufour@linux.vnet.ibm.com>
    powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/pseries: Honor the generic "no_64bit_msi" flag

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    of/base: Fix PowerPC address parsing hack

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sgtl5000: Fix SMALL_POP bit definition

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    PCI/MSI: Add device flag indicating that 64-bit MSIs don't work

Jiri Bohac <jbohac@suse.cz>
    ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Mathias Krause <minipli@googlemail.com>
    pptp: fix stack info leak in pptp_getname()

Martin Hauke <mardnh@gmx.de>
    qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Alexey Khoroshilov <khoroshilov@ispras.ru>
    ieee802154: fix error handling in ieee802154fake_probe()

Panu Matilainen <pmatilai@redhat.com>
    ipv4: Fix incorrect error code when adding an unreachable route

Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>
    inetdevice: fixed signed integer overflow

David S. Miller <davem@davemloft.net>
    sparc64: Fix constraints on swab helpers.

Andy Lutomirski <luto@amacapital.net>
    uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Kees Cook <keescook@chromium.org>
    x86, mm: Set NX across entire PMD at boot

Dave Hansen <dave.hansen@linux.intel.com>
    x86: Require exact match for 'noxsave' command line option

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Rework bad_iret

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Stop using IST for #SS

Andy Lutomirski <luto@amacapital.net>
    x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: Loongson: Make platform serial setup always built-in.

Aaro Koskinen <aaro.koskinen@nsn.com>
    MIPS: oprofile: Fix backtrace on 64-bit kernel


-------------

Diffstat:

 Makefile                                  |  4 +-
 arch/arm/mm/proc-v7.S                     |  2 -
 arch/arm/mm/proc-xscale.S                 |  4 +-
 arch/mips/loongson/common/Makefile        |  3 +-
 arch/mips/oprofile/backtrace.c            |  2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  3 +-
 arch/powerpc/platforms/powernv/pci.c      |  4 +-
 arch/powerpc/platforms/pseries/msi.c      |  2 +-
 arch/powerpc/xmon/xmon.c                  |  6 +-
 arch/sparc/include/uapi/asm/swab.h        | 12 ++--
 arch/x86/include/asm/page_32_types.h      |  1 -
 arch/x86/include/asm/page_64_types.h      | 11 ++--
 arch/x86/include/asm/thread_info.h        |  2 +-
 arch/x86/kernel/cpu/common.c              |  2 +
 arch/x86/kernel/dumpstack_64.c            |  1 -
 arch/x86/kernel/entry_64.S                | 81 +++++++-------------------
 arch/x86/kernel/traps.c                   | 71 ++++++++++++++++------
 arch/x86/mm/init_64.c                     | 11 +++-
 drivers/infiniband/ulp/isert/ib_isert.c   | 29 +++++----
 drivers/infiniband/ulp/srpt/ib_srpt.c     |  8 +++
 drivers/input/joystick/xpad.c             | 16 ++++-
 drivers/net/can/dev.c                     |  2 +-
 drivers/net/can/usb/esd_usb2.c            |  1 +
 drivers/net/ieee802154/fakehard.c         | 13 +++--
 drivers/net/ppp/pptp.c                    |  4 +-
 drivers/net/usb/qmi_wwan.c                |  1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c | 50 ++++------------
 drivers/of/address.c                      | 19 +++++-
 drivers/pci/msi.c                         | 26 +++++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  7 +++
 drivers/spi/spi-dw.c                      |  6 +-
 drivers/target/target_core_transport.c    |  2 +-
 drivers/usb/core/quirks.c                 |  3 +
 drivers/usb/host/xhci-ring.c              |  3 +-
 drivers/usb/serial/cp210x.c               |  1 +
 drivers/usb/serial/ftdi_sio.c             | 33 +++++++++++
 drivers/usb/serial/ftdi_sio_ids.h         | 39 +++++++++++--
 drivers/usb/serial/keyspan.c              | 97 +++++++++++++++++++------------
 drivers/usb/serial/ssu100.c               | 11 +---
 fs/nfsd/nfs4callback.c                    |  8 ++-
 fs/nfsd/nfs4state.c                       | 31 ++++++----
 fs/nfsd/vfs.c                             |  3 +
 include/linux/iio/events.h                |  2 +-
 include/linux/inetdevice.h                |  2 +-
 include/linux/pci.h                       |  1 +
 kernel/events/uprobes.c                   |  1 -
 net/ipv4/fib_rules.c                      |  4 ++
 net/ipx/af_ipx.c                          |  6 +-
 sound/soc/codecs/sgtl5000.c               |  3 +-
 sound/soc/codecs/sgtl5000.h               |  2 +-
 sound/soc/codecs/wm_adsp.c                |  1 +
 sound/usb/quirks.c                        | 14 +++++
 52 files changed, 424 insertions(+), 247 deletions(-)


