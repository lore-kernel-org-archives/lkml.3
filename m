Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3CZXBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:01:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab3CZXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:01:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/49] 3.0.71-stable review
Date: Tue, 26 Mar 2013 16:00:57 -0700
Message-Id: <20130326225839.554028294@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.71 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 28 22:57:54 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.71-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.71-rc1

Ben Hutchings <ben@decadent.org.uk>
    asus-laptop: Do not call HWRS on init

Felix Fietkau <nbd@openwrt.org>
    rt2x00: error in configurations with mesh support disabled

Kees Cook <keescook@chromium.org>
    exec: use -ELOOP for max recursion depth

Lekensteyn <lekensteyn@gmail.com>
    i915: initialize CADL in opregion

Mathias Krause <minipli@googlemail.com>
    udf: avoid info leak on export

Mathias Krause <minipli@googlemail.com>
    isofs: avoid info leak on export

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys

Alan Cox <alan@linux.intel.com>
    key: Fix resource leak

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix get_icount for two port adapters

Johan Hovold <jhovold@gmail.com>
    USB: garmin_gps: fix memory leak on disconnect

Jan Kara <jack@suse.cz>
    udf: Fix bitmap overflow on large filesystems with small block size

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix interface refcounting

Dmitry Torokhov <dtor@vmware.com>
    USB: xhci - fix bit definitions for IMAN register

CQ Tang <cq.tang@intel.com>
    x86-64: Fix the failure case in copy_user_handle_tail()

Mark Rutland <mark.rutland@arm.com>
    clockevents: Don't allow dummy broadcast timers

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IPoIB: Fix send lockup due to missed TX completion

Dmitry Artamonow <mad_soft@inbox.ru>
    usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Zheng Liu <wenqing.lz@taobao.com>
    ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

Jeff Layton <jlayton@redhat.com>
    cifs: ignore everything in SPNEGO blob after mechTypes

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting

Torsten Duwe <torsten@lst.de>
    KMS: fix EDID detailed timing vsync parsing

Kees Cook <keescook@chromium.org>
    drm/i915: bounds check execbuffer relocation count

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix potential out-of-boundary access to ibss rate table

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix free of probe entry by calling call_rcu_sched()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix race in snapshot swapping

Kees Cook <keescook@chromium.org>
    drm/i915: restrict kernel address leak in debugfs

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: mixer: propagate errors up the call chain

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix typo in checking IEC958 emphasis bit

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Only use TX push if a single descriptor is to be written

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Disable soft interrupt handling during efx_device_detach_sync()

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Detach net device when stopping queues for reconfiguration

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix efx_rx_buf_offset() in the presence of swiotlb

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Properly sync RX DMA buffer when it is not the last in the page

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix timekeeping in efx_mcdi_poll()

Daniel Pieczko <dpieczko@solarflare.com>
    sfc: lock TX queues when calling netif_device_detach()

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix two causes of flush failure

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()

Stuart Hodgson <smhodgson@solarflare.com>
    sfc: Do not attempt to flush queues if DMA is disabled

Steve Hodgson <shodgson@solarflare.com>
    sfc: Fix Siena mac statistics on big endian platforms

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix loop condition for efx_filter_search() when !for_insert

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: limit length of fragment queue hash table bucket lists

Vlad Yasevich <vyasevic@redhat.com>
    rtnetlink: Mask the rta_type when range checking

Denis V. Lunev <den@openvz.org>
    ipv4: fix definition of FIB_TABLE_HASHSZ

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: don't break the loop while meeting the active_path so as to find the matched transport

Veaceslav Falico <vfalico@redhat.com>
    netconsole: don't call __netpoll_cleanup() while atomic

David Ward <david.ward@ll.mit.edu>
    net/ipv4: Ensure that location of timestamp option is stored

Tkhai Kirill <tkhai@yandex.ru>
    sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "USB: EHCI: don't check DMA values in QH overlays"


-------------

Diffstat:

 Makefile                                   |  4 +--
 arch/x86/lib/usercopy_64.c                 |  4 +--
 drivers/gpu/drm/drm_edid.c                 |  2 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |  2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 11 +++++--
 drivers/gpu/drm/i915/intel_opregion.c      | 23 ++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  8 +++--
 drivers/net/netconsole.c                   | 20 +++++------
 drivers/net/sfc/efx.c                      | 53 +++++++++++++++++++-----------
 drivers/net/sfc/efx.h                      | 13 ++++++++
 drivers/net/sfc/falcon.c                   |  2 ++
 drivers/net/sfc/filter.c                   | 41 +++++++++++++----------
 drivers/net/sfc/mcdi.c                     | 29 +++++++++-------
 drivers/net/sfc/mcdi.h                     |  1 +
 drivers/net/sfc/mcdi_mac.c                 |  4 ++-
 drivers/net/sfc/net_driver.h               | 10 +++++-
 drivers/net/sfc/nic.c                      | 24 +++++++++++---
 drivers/net/sfc/nic.h                      |  2 ++
 drivers/net/sfc/rx.c                       | 25 ++++++++------
 drivers/net/sfc/selftest.c                 |  2 +-
 drivers/net/sfc/siena.c                    | 29 +++++++++++-----
 drivers/net/wireless/mwifiex/join.c        |  7 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  2 ++
 drivers/platform/x86/asus-laptop.c         | 17 +++-------
 drivers/tty/serial/sunsu.c                 | 21 +++++-------
 drivers/usb/host/ehci-q.c                  | 18 +++-------
 drivers/usb/host/xhci.h                    |  4 +--
 drivers/usb/serial/garmin_gps.c            |  7 +---
 drivers/usb/serial/io_ti.c                 |  1 +
 drivers/usb/serial/usb-serial.c            |  3 +-
 drivers/usb/storage/unusual_devs.h         |  7 ++++
 fs/binfmt_em86.c                           |  1 -
 fs/binfmt_misc.c                           |  6 ----
 fs/binfmt_script.c                         |  4 +--
 fs/cifs/asn1.c                             | 53 +++---------------------------
 fs/compat.c                                | 15 ++++-----
 fs/exec.c                                  | 10 +++---
 fs/ext4/extents.c                          |  6 +++-
 fs/isofs/export.c                          |  1 +
 fs/udf/namei.c                             |  1 +
 fs/udf/udf_sb.h                            |  2 +-
 include/linux/binfmts.h                    |  2 --
 include/net/inet_frag.h                    |  9 +++++
 include/net/ip_fib.h                       | 12 +++----
 kernel/time/tick-broadcast.c               |  3 +-
 kernel/trace/ftrace.c                      |  4 +--
 kernel/trace/trace.c                       |  3 +-
 mm/hugetlb.c                               |  8 +++--
 net/core/rtnetlink.c                       |  2 +-
 net/ipv4/inet_fragment.c                   | 20 ++++++++++-
 net/ipv4/ip_fragment.c                     | 12 +++----
 net/ipv4/ip_options.c                      |  5 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c    | 12 +++----
 net/ipv6/reassembly.c                      |  8 +++--
 net/sctp/associola.c                       |  2 +-
 security/keys/compat.c                     |  4 +--
 security/keys/keyctl.c                     |  4 +--
 sound/pci/hda/hda_codec.c                  |  2 +-
 sound/usb/mixer.c                          | 16 +++++----
 59 files changed, 354 insertions(+), 269 deletions(-)


