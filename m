Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3C1TXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:23:03 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41053 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3C1TXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:23:00 -0400
Date: Thu, 28 Mar 2013 12:22:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.71
Message-ID: <20130328192257.GA16851@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.71 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/x86/lib/usercopy_64.c                 |    4 +-
 drivers/gpu/drm/drm_edid.c                 |    2 -
 drivers/gpu/drm/i915/i915_debugfs.c        |    2 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 ++++--
 drivers/gpu/drm/i915/intel_opregion.c      |   23 ++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |    8 +++-
 drivers/net/netconsole.c                   |   20 ++++------
 drivers/net/sfc/efx.c                      |   53 ++++++++++++++++++------=
-----
 drivers/net/sfc/efx.h                      |   13 +++++++
 drivers/net/sfc/falcon.c                   |    2 +
 drivers/net/sfc/filter.c                   |   41 +++++++++++++---------
 drivers/net/sfc/mcdi.c                     |   29 +++++++++------
 drivers/net/sfc/mcdi.h                     |    1=20
 drivers/net/sfc/mcdi_mac.c                 |    4 +-
 drivers/net/sfc/net_driver.h               |   10 ++++-
 drivers/net/sfc/nic.c                      |   24 ++++++++++---
 drivers/net/sfc/nic.h                      |    2 +
 drivers/net/sfc/rx.c                       |   25 ++++++++-----
 drivers/net/sfc/selftest.c                 |    2 -
 drivers/net/sfc/siena.c                    |   29 +++++++++++----
 drivers/net/wireless/mwifiex/join.c        |    7 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 +
 drivers/platform/x86/asus-laptop.c         |   17 ++-------
 drivers/tty/serial/sunsu.c                 |   21 ++++-------
 drivers/usb/host/ehci-q.c                  |   18 ++-------
 drivers/usb/host/xhci.h                    |    4 +-
 drivers/usb/serial/garmin_gps.c            |    7 ---
 drivers/usb/serial/io_ti.c                 |    1=20
 drivers/usb/serial/usb-serial.c            |    3 +
 drivers/usb/storage/unusual_devs.h         |    7 +++
 fs/binfmt_em86.c                           |    1=20
 fs/binfmt_misc.c                           |    6 ---
 fs/binfmt_script.c                         |    4 --
 fs/cifs/asn1.c                             |   53 ++----------------------=
-----
 fs/compat.c                                |   15 +++-----
 fs/exec.c                                  |   10 ++---
 fs/ext4/extents.c                          |    6 ++-
 fs/isofs/export.c                          |    1=20
 fs/udf/namei.c                             |    1=20
 fs/udf/udf_sb.h                            |    2 -
 include/linux/binfmts.h                    |    2 -
 include/net/inet_frag.h                    |    9 ++++
 include/net/ip_fib.h                       |   12 ++----
 kernel/time/tick-broadcast.c               |    3 +
 kernel/trace/ftrace.c                      |    4 +-
 kernel/trace/trace.c                       |    3 +
 mm/hugetlb.c                               |    8 +++-
 net/core/rtnetlink.c                       |    2 -
 net/ipv4/inet_fragment.c                   |   20 ++++++++++
 net/ipv4/ip_fragment.c                     |   12 +++---
 net/ipv4/ip_options.c                      |    5 --
 net/ipv6/netfilter/nf_conntrack_reasm.c    |   12 +++---
 net/ipv6/reassembly.c                      |    8 +++-
 net/sctp/associola.c                       |    2 -
 security/keys/compat.c                     |    4 +-
 security/keys/keyctl.c                     |    4 +-
 sound/pci/hda/hda_codec.c                  |    2 -
 sound/usb/mixer.c                          |   16 ++++----
 59 files changed, 353 insertions(+), 268 deletions(-)

Alan Cox (1):
      key: Fix resource leak

Ben Hutchings (10):
      sfc: Fix loop condition for efx_filter_search() when !for_insert
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_b=
oard_cfg()
      sfc: Fix two causes of flush failure
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Detach net device when stopping queues for reconfiguration
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Only use TX push if a single descriptor is to be written
      asus-laptop: Do not call HWRS on init

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Pieczko (1):
      sfc: lock TX queues when calling netif_device_detach()

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Felix Fietkau (1):
      rt2x00: error in configurations with mesh support disabled

Greg Kroah-Hartman (2):
      Revert "USB: EHCI: don't check DMA values in QH overlays"
      Linux 3.0.71

Hannes Frederic Sowa (1):
      inet: limit length of fragment queue hash table bucket lists

Jan Kara (1):
      udf: Fix bitmap overflow on large filesystems with small block size

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Johan Hovold (3):
      USB: serial: fix interface refcounting
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters

Kees Cook (3):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count
      exec: use -ELOOP for max recursion depth

Lekensteyn (1):
      i915: initialize CADL in opregion

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Mathias Krause (2):
      isofs: avoid info leak on export
      udf: avoid info leak on export

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and=
 security keys

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Steve Hodgson (1):
      sfc: Fix Siena mac statistics on big endian platforms

Steven Rostedt (Red Hat) (2):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()

Stuart Hodgson (1):
      sfc: Do not attempt to flush queues if DMA is disabled

Takashi Iwai (1):
      ALSA: hda - Fix typo in checking IEC958 emphasis bit

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=3DttySY" cmd=
line option

Torsten Duwe (1):
      KMS: fix EDID detailed timing vsync parsing

Veaceslav Falico (1):
      netconsole: don't call __netpoll_cleanup() while atomic

Vlad Yasevich (1):
      rtnetlink: Mask the rta_type when range checking

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcom=
mit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to fin=
d the matched transport

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_exte=
nt()


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRVJiRAAoJEDjbvchgkmk+nkoQAMcyA/cSeiOIzgX8gfnuEsIw
6pO1i6Cqzn5wzTWjSiHs6Q0zmOGFxYQs6zYDy0XTmyNZix/DZBMxtBFwSU8nnQs7
PDw8+VCm8duYARiia7SkqdueXXYLtjjiKcogQbWgHArd+AqH/AQIwuxum+Xgw7e+
ahwE82WKmqqD1tIrrxsH1KlPolbIFSxIynfDisg9uxwhKCPNQqLIEg8nktMf/hWo
0qzzRnOXi/qBn61n0OeO/GI1/KLDxQrROXlM0LU/K8FdemX+0MyNdKw+2vKuvyey
GekPL19DgDKFNo6au/XpXjB26Q6RL3fdilr9d7+P/Da/huK6tZocaLuVSlFkenmu
P5UgRVJV/yfxQLbPwl8OYdPdmQqCRg40Ku7I6pnxrHE1TZ0OAjaw5ltO+4esliat
guKtT1SA9vC/vh4tZz/q5bqzaVMbX/nNaqWVT/CNY13yaxAMqHeYZz6M/311yBSN
oxmvMaK5ia8hRXxwOcQnnLgU1NomzMz4tRidpXTSnxhgNNR6OXQAzjHfZA41xFiB
nJZueixv+RvPF9m+O4p2HsWi6uhaKXPld3lLULmQrKyXqukAow4IM/+FYn7fgE68
BR1FYGe8f7Y0BFYk/sPgJPmQo6MKI6hdEXmRPtJ93fqMxQlIhDzLVF/fIcj+jRBW
RhxLkJoUU699NSbtfwFz
=oqrd
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
