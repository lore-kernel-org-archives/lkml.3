Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaLGTtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:49:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaLGTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:49:08 -0500
Date: Sun, 7 Dec 2014 11:49:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.62
Message-ID: <20141207194905.GA2786@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.62 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/arm/mm/proc-v7.S                     |    2=20
 arch/arm/mm/proc-xscale.S                 |    4 -
 arch/mips/loongson/common/Makefile        |    3=20
 arch/mips/oprofile/backtrace.c            |    2=20
 arch/powerpc/platforms/powernv/pci-ioda.c |    3=20
 arch/powerpc/platforms/powernv/pci.c      |    4 -
 arch/powerpc/platforms/pseries/msi.c      |    2=20
 arch/powerpc/xmon/xmon.c                  |    6 -
 arch/sparc/include/uapi/asm/swab.h        |   12 +--
 arch/x86/include/asm/page_32_types.h      |    1=20
 arch/x86/include/asm/page_64_types.h      |   11 +--
 arch/x86/include/asm/thread_info.h        |    2=20
 arch/x86/kernel/cpu/common.c              |    2=20
 arch/x86/kernel/dumpstack_64.c            |    1=20
 arch/x86/kernel/entry_64.S                |   81 ++++++-------------------
 arch/x86/kernel/traps.c                   |   71 ++++++++++++++++-----
 arch/x86/mm/init_64.c                     |   11 +++
 drivers/infiniband/ulp/isert/ib_isert.c   |   29 +++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c     |    8 ++
 drivers/input/joystick/xpad.c             |   16 ++++
 drivers/net/can/dev.c                     |    2=20
 drivers/net/can/usb/esd_usb2.c            |    1=20
 drivers/net/ieee802154/fakehard.c         |   13 ++--
 drivers/net/ppp/pptp.c                    |    4 -
 drivers/net/usb/qmi_wwan.c                |    1=20
 drivers/net/wireless/rt2x00/rt2x00queue.c |   50 +++------------
 drivers/of/address.c                      |   19 ++++-
 drivers/pci/msi.c                         |   26 ++++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |    7 ++
 drivers/spi/spi-dw.c                      |    6 -
 drivers/target/target_core_transport.c    |    2=20
 drivers/usb/core/quirks.c                 |    3=20
 drivers/usb/host/xhci-ring.c              |    3=20
 drivers/usb/serial/cp210x.c               |    1=20
 drivers/usb/serial/ftdi_sio.c             |   33 ++++++++++
 drivers/usb/serial/ftdi_sio_ids.h         |   39 ++++++++++--
 drivers/usb/serial/keyspan.c              |   97 ++++++++++++++++++-------=
-----
 drivers/usb/serial/ssu100.c               |   11 ---
 fs/nfsd/nfs4callback.c                    |    8 +-
 fs/nfsd/nfs4state.c                       |   31 ++++++---
 fs/nfsd/vfs.c                             |    3=20
 include/linux/iio/events.h                |    2=20
 include/linux/inetdevice.h                |    2=20
 include/linux/pci.h                       |    1=20
 kernel/events/uprobes.c                   |    1=20
 net/ipv4/fib_rules.c                      |    4 +
 net/ipx/af_ipx.c                          |    6 +
 sound/soc/codecs/sgtl5000.c               |    3=20
 sound/soc/codecs/sgtl5000.h               |    2=20
 sound/soc/codecs/wm_adsp.c                |    1=20
 sound/usb/quirks.c                        |   14 ++++
 52 files changed, 423 insertions(+), 246 deletions(-)

Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Alexey Khoroshilov (2):
      ieee802154: fix error handling in ieee802154fake_probe()
      can: esd_usb2: fix memory leak on disconnect

Andy Lutomirski (4):
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Rework bad_iret
      uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Benjamin Herrenschmidt (4):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      of/base: Fix PowerPC address parsing hack
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      powerpc/powernv: Honor the generic "no_64bit_msi" flag

Charles Keepax (1):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in u=
se

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David S. Miller (1):
      sparc64: Fix constraints on swab helpers.

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Greg Kroah-Hartman (2):
      Input: xpad - use proper endpoint type
      Linux 3.10.62

Hans de Goede (1):
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

J. Bruce Fields (1):
      nfsd4: fix leak of inode reference on delegation failure

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Johan Hovold (3):
      USB: ssu100: fix overrun-error reporting
      USB: keyspan: fix overrun-error reporting
      USB: keyspan: fix tty line-status reporting

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devic=
es

Kees Cook (1):
      x86, mm: Set NX across entire PMD at boot

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathias Nyman (1):
      USB: xhci: don't start a halted endpoint before its new dequeue is set

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length =3D=3D 0

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener c=
orrectly

Sergio Gelato (1):
      nfsd: Fix ACL null pointer deref

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Thomas K=F6rper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (1):
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (1):
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhK8xAAoJEDjbvchgkmk+9MgQAJPPbtxmwhxLD4bfqBYc6rlC
+hDZ647E1J8USBJft1MjSC2/K40oNZVwt+12+eQCl1fASyIUI8ulW2h98OBm9khO
ppdz+2+bGA9BhMtkWnshINi5Eh8hSs/E+QO6xzREMiOc7UC1eEtKJdjuKX8kRM5R
t0+9y166gUUO7CXj833IqcpofhBy70aXcXi8YKsaJPAMYiR8h8xRcN12hzC1+5+d
+dBR3rPZbkzvpw1hGmDs47MGIFueHV4d9PKsb/mO8P5Id09Jtt6XfA+fz4vSaTKy
4nxWlBlhGZUghabSeblaCrIeeeo9EaYhkDF1n653jnbj12doEymxoCzdETqPt8jB
7iS8lf3Rrc1uI3ujutXhyzq/cRUE9/Zn3zfvtfLq7mQL92bX77uM8ojk2krEZg94
gfhd2Cr4uG+TmQ/PAWHxTk1cB4KsQyEe4uxaHrjWAksveJ9WuGttJ4D4aSHWOVvA
/TqKi2IbQwUxgN0MX8Brx/XuAnxzImh0Ijdi2cc+os/LZtKCkYQ/kpTUIlF9C6/0
mjoYFkJF+zNdYDMVhAwEc8+y0X6/HX4WQicWwflhd8QHd0nNOM45EJj8YnCYQJIy
UfnRWkgbNkyzTlG/CfHu5XFrBm8HC0j53xvS3YabiydHKoGGOcM8n60+EaEftDc4
qYh5t1GGQUof19Lh/ffF
=htYZ
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
