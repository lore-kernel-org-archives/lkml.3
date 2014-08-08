Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaHHCU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:20:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaHHCUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:20:25 -0400
Date: Thu, 7 Aug 2014 19:20:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.52
Message-ID: <20140808022024.GA548@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.52 kernel.

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

 Documentation/x86/x86_64/mm.txt         |    2=20
 Makefile                                |    2=20
 arch/arm/mm/idmap.c                     |    7 +
 arch/x86/Kconfig                        |   25 +++
 arch/x86/include/asm/espfix.h           |   16 ++
 arch/x86/include/asm/irqflags.h         |    2=20
 arch/x86/include/asm/pgtable_64_types.h |    2=20
 arch/x86/include/asm/setup.h            |    2=20
 arch/x86/kernel/Makefile                |    1=20
 arch/x86/kernel/entry_32.S              |   12 +
 arch/x86/kernel/entry_64.S              |   77 ++++++++++-
 arch/x86/kernel/espfix_64.c             |  208 +++++++++++++++++++++++++++=
+++++
 arch/x86/kernel/ldt.c                   |   10 -
 arch/x86/kernel/paravirt_patch_64.c     |    2=20
 arch/x86/kernel/smpboot.c               |    7 +
 arch/x86/mm/dump_pagetables.c           |   39 ++++--
 arch/x86/vdso/vdso32-setup.c            |    8 -
 crypto/af_alg.c                         |    2=20
 drivers/iio/industrialio-buffer.c       |    2=20
 drivers/net/ethernet/marvell/mvneta.c   |  206 ++++++++++++++++-----------=
----
 drivers/rapidio/devices/tsi721_dma.c    |    8 +
 drivers/scsi/scsi_lib.c                 |    8 +
 drivers/staging/vt6655/bssdb.c          |    2=20
 drivers/staging/vt6655/device_main.c    |    7 -
 include/linux/printk.h                  |    6=20
 init/main.c                             |    4=20
 kernel/printk.c                         |    2=20
 kernel/sched/core.c                     |    2=20
 kernel/sched/rt.c                       |    2=20
 kernel/time/clockevents.c               |   10 -
 lib/btree.c                             |    1=20
 mm/page_alloc.c                         |   16 +-
 net/l2tp/l2tp_ppp.c                     |    4=20
 net/mac80211/tx.c                       |   27 ++--
 net/wireless/trace.h                    |    3=20
 35 files changed, 554 insertions(+), 180 deletions(-)

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

Eliad Peller (1):
      cfg80211: fix mic_failure tracing

Greg Kroah-Hartman (1):
      Linux 3.10.52

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtim=
e option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit sta=
ck
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler lo=
cks

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

John Stultz (1):
      printk: rename printk_sched to printk_deferred

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory la=
yout

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Malcolm Priestley (2):
      staging: vt6655: Fix disassociated messages every 10 seconds
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Minfei Huang (1):
      lib/btree.c: fix leak of whole btree nodes

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

willy tarreau (5):
      net: mvneta: increase the 64-bit rx/tx stats out of the hot path
      net: mvneta: use per_cpu stats to fix an SMP lock up
      net: mvneta: do not schedule in mvneta_tx_timeout
      net: mvneta: add missing bit descriptions for interrupt masks and cau=
ses
      net: mvneta: replace Tx timer with a real interrupt


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5DPoAAoJEDjbvchgkmk+1BEQAK5FT2HvxvVnd0+lv1ZpKHYa
1weBr/zm2hQ6N6ypz7cQG8HkuTg5ufrQYOM9BNDQlJr1UWApaM3R9PYbS/b+uhE5
GaD/LHUsvjTkxC1+y9QWc138Q6KQ8BJ4n/6zHhuEW+d8aJoWGz8YxXHp7x+9hy4I
FWvKvyoBz91tEtY+U+ZBdBY9t0xokjDxyv1lan7wlMFAOLvN8UY6iICvJ5hUg1Im
sAx7Z66qf7ja6nMjPzJfG4aPu6e2dXwFYtKf7qNy0+exlCU6RgpDZ5lxADtQmHEy
jY374+QjpqmBNBIvHbI2K/fcXu+NHocPMqlE8DOyYgzefictAhf378ZPow/y9hDf
8RMXqPQb4pvzInjult+89EOqgsEAWozu+NvciB7hiDHgTW/tJDDbZLZAGVMHa1eP
tdosrEqUGTGDtzT2okof52puUVXmV7r/Exjm1/kE7DwnGWSzJxqvFSfjxsDzX+Rw
o9GSBOSWlVfcWsOn6fAd9S4ppHh/4KrVeL75E8mgXmomfQBNy6nXUq911ZuuFkgH
4It5OWr3JuzR+egOzVWucXpT0aQDVqHUWYq38/C1Cr1J+reCk/aOpVEjrwJyYkv1
Tn8U9SdMdEjd3zbQpFcfaYNT+2DGlLh7MdpNjN5cmMsWq9gB4SElgJxzY0a5UzlW
vlYfc0PTmVmBfUnEEDw0
=9sb0
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
