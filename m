Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaJIVsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:48:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbaJIVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:48:14 -0400
Date: Thu, 9 Oct 2014 14:48:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.5
Message-ID: <20141009214813.GA8710@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.5 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/ia64/pci/fixup.c                    |    4 -
 arch/x86/include/asm/vga.h               |    6 --
 arch/x86/pci/fixup.c                     |    3 -
 drivers/cpufreq/integrator-cpufreq.c     |    4 -
 drivers/cpufreq/pcc-cpufreq.c            |    2=20
 drivers/gpu/drm/i915/i915_gem_gtt.c      |   14 ++++++
 drivers/gpu/drm/i915/intel_opregion.c    |   16 +++++--
 drivers/gpu/vga/vgaarb.c                 |   38 +++++++++++++++++
 drivers/i2c/busses/i2c-qup.c             |   12 +++--
 drivers/i2c/busses/i2c-rk3x.c            |    2=20
 drivers/md/raid5.c                       |   18 +++++++-
 drivers/media/v4l2-core/videobuf2-core.c |   15 ++++++
 drivers/usb/storage/uas-detect.h         |   67 +++++++++++++++++++-------=
-----
 drivers/video/fbdev/efifb.c              |   39 ------------------
 fs/cifs/smb1ops.c                        |    2=20
 fs/cifs/smb2maperror.c                   |    2=20
 fs/udf/inode.c                           |   35 +++++++++-------
 include/linux/jiffies.h                  |   12 -----
 include/media/videobuf2-core.h           |    4 +
 init/Kconfig                             |    1=20
 kernel/events/core.c                     |    4 +
 kernel/fork.c                            |    5 +-
 kernel/time.c                            |   54 +++++++++++++-----------
 kernel/trace/ring_buffer.c               |    2=20
 mm/huge_memory.c                         |   11 +++--
 mm/memcontrol.c                          |   36 ++++++++++++++--
 mm/migrate.c                             |    5 +-
 sound/soc/codecs/ssm2602.c               |    2=20
 sound/soc/soc-core.c                     |    2=20
 30 files changed, 259 insertions(+), 160 deletions(-)

Aaron Lu (1):
      ACPI / i915: Update the condition to ignore firmware backlight change=
 request

Alexandru M Stan (1):
      i2c: rk3x: fix 0 length write transfers

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Andy Gross (1):
      i2c: qup: Fix order of runtime pm initialization

Arnd Bergmann (1):
      cpufreq: integrator: fix integrator_cpufreq_remove return type

Bruno Pr=E9mont (2):
      x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga=
_fixup()
      vgaarb: Don't default exclusively to first video device with mem+io

Chris Wilson (1):
      drm/i915: Flush the PTEs after updating them before suspend

Greg Kroah-Hartman (1):
      Linux 3.16.5

Hans Verkuil (1):
      media: vb2: fix VBI/poll regression

Hans de Goede (4):
      uas: Only complain about missing sg if all other checks succeed
      uas: Log a warning when we cannot use uas because the hcd lacks strea=
ms
      uas: Disable uas on ASM1051 devices
      uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs

Johannes Weiner (1):
      mm: memcontrol: do not iterate uninitialized memcgs

Josh Triplett (1):
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Mel Gorman (2):
      mm: migrate: Close race between migration completion and mprotect
      mm: numa: Do not mark PTEs pte_numa when splitting huge pages

NeilBrown (1):
      md/raid5: disable 'DISCARD' by default due to safety concerns.

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Rafael J. Wysocki (1):
      cpufreq: pcc-cpufreq: Fix wait_event() under spinlock

Stefan Kristiansson (1):
      ASoC: ssm2602: do not hardcode type to SSM2602

Steve French (1):
      Fix problem recognizing symlinks

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

Waiman Long (1):
      mm, thp: move invariant bug check out of loop in __split_huge_page_map

Xiubo Li (1):
      ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNwKdAAoJEDjbvchgkmk+z4UP/2+U/+O/pSgMW+1gdpMsvHsu
08D6b8NwKbZ0reQjcgO/0UQuzhAYbJ6fF+jodWLtIHuF2Q+7XDpWeoLteRYDLYag
EAkosxwWd+wRYW4Cqdx03wiJkif9/ewrsXWl6o/42P0BEfpsJFceISqI+rLeG4FX
9EPOR8wvgg316e1uawXFKnh7lbtwda7MXtcm8rWYnpjSjJLnXS8acHlqLytsNmpe
QxXCmDlWKLwW8tyGIAr48qgLCyxTpuoRDELFePSap6lHLCrsJDaZcKHbwWbTLaED
g4Ctl/5D8NuRHcsJ1fDogMolaWrhek99cO7OZLiebTNqyTN5PDC6FlS4UFGxlVEy
nVE2K7iUrbnxuR4SQLaSiQ3SfXC22JClm+XrE+4daXEDXvcG8g1shvsIG+zHdZd5
I1FGX5b00XEY8UtF89i1GbaL5Gn7cBs/6hPmMqILv41Jtbs8wybNRQP8lKNOdbDy
Gdh6bDjk2fFIXMhkL4xTT8lf8N47y3wMumHU5aYv61NuaSb7zouOHMSYjJYBMBcO
hl0srKMYf1i3WGzYNx4wsHaN6MDf75SiM5jtDcyr1ou3lpCu5QYOjzaEqIGPyRAz
hPLbB1C3jqpXTMiY0aBNCzweHrobLBG3bELWyaXf0XhNVom/kmG0e5PYySYqwXOb
2/bDTNcz7/HcyJCxy9jE
=lE/x
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
