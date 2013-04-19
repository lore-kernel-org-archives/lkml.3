Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755Ab3DSPcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:32:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41737 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030594Ab3DSPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:32:49 -0400
Date: Fri, 19 Apr 2013 11:32:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xensource.com
Subject: [GIT PULL) xen (stable/for-linus-3.10-rc0-tag) for v3.10 merge
 window.
Message-ID: <20130419153241.GA22185@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

I am heading out for a week of vacation but would hate to have missed
the merge window. Hence sending it out early in anticipation that you
will release v3.9 on Sunday.

With that said, please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.10-rc0-tag

which has just a couple of features and mostly bug-fixes. Here is the blurb
copied from the signed tag:
<tag>
Features:
 - Populate the boot_params with EDD data.
 - Cleanups in the IRQ code.
Bug-fixes:
 - CPU hotplug offline/online in PVHVM mode.
 - Re-upload processor PM data after ACPI S3 suspend/resume cycle.
</tag>

Please pull!

 arch/x86/pci/xen.c               |  6 +--
 arch/x86/xen/enlighten.c         | 57 +++++++++++++++++++++++++++-
 arch/x86/xen/smp.c               | 21 ++++++----
 arch/x86/xen/spinlock.c          | 25 ++++++++++++
 arch/x86/xen/time.c              | 13 +++++--
 drivers/video/Kconfig            |  2 +-
 drivers/xen/events.c             | 33 +++++++++++-----
 drivers/xen/xen-acpi-processor.c | 82 +++++++++++++++++++++++++++-------------
 include/xen/events.h             |  3 +-
 9 files changed, 188 insertions(+), 54 deletions(-)

Andrew Jones (1):
      xen kconfig: fix select INPUT_XEN_KBDDEV_FRONTEND

Ben Guthro (2):
      xen: Re-upload processor PM data to hypervisor after S3 resume (v2)
      xen: resolve section mismatch warnings in xen-acpi-processor

David Vrabel (1):
      x86/xen: populate boot_params with EDD data

Jan Beulich (1):
      xen: drop tracking of IRQ vector

Konrad Rzeszutek Wilk (9):
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
      xen/events: Check that IRQ value passed in is valid.
      xen/time: Add default value of -1 for IRQ and check for that.
      xen/spinlock:  Check against default value of -1 for IRQ line.
      xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM
      xen/smp/pvhvm: Don't initialize IRQ_WORKER as we are using the native one.
      xen/smp: Unifiy some of the PVs and PVHVM offline CPU path


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRcWOUAAoJEFjIrFwIi8fJ4LUIANf/NGS7vOXmGumM31D4Tjm8
8Xa6IQuijLkygAAICac+AWozHdx1VPvOpf5ykLoCrn/Ye8DJhZ21nqVQ4KyI19mE
9q3jkZN4NP4krVy6b6GFdtYEeXV4ueaVW+SsxStm4jP4x0trtypPpI7Zwoq7GWv8
rwcug4zab7m/bGMA5RPy6m1TMHLxH+PKCd+SqybzwhfsWwyowiaIH2jJlcgql0pV
5Jd0HiCHQ5ANW0H2ABfGaS+kSfTwYKQjgnKrYdJxfNjL34t20GK0dNKfktNXPKX2
K1dAhFH1bP/RqeWJ0lOhE9eZmF6vnSJ2Aah0/SfWpy3A07eVIteohSqBZUNKqfs=
=XUda
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
