Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3ICP43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:56:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28920 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3ICP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:56:28 -0400
Date: Tue, 3 Sep 2013 11:56:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-3.12-rc0-tag
Message-ID: <20130903155618.GA2560@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.12-rc0-tag

which has a couple of features and a ton of bug-fixes. There is also some maintership
changes. Jeremy is enjoying the full-time work at the startup and as much as
he would love to help - he can't find the time. I have a bunch of other things
that I promised to work on - paravirt diet, get SWIOTLB working everywhere, etc,
but haven't been able to find the time.

As such both David Vrabel and Boris Ostrovsky have graciously volunteered to
help with the maintership role. They will keep the lid on regressions, bug-fixes,
etc. I will be in the background to help - but eventually there will be less
of me doing the Xen GIT pulls and more of them. Stefano is still doing the
ARM/ARM64 and will continue on doing so.

That is it. And back to our scheduled GIT PULL:

<blurb from signed tag>
Features:
 - Xen Trusted Platform Module (TPM) frontend driver - with the backend in MiniOS.
 - Scalability improvements in event channel.
 - Two extra Xen co-maintainers (David, Boris) and one going away (Jeremy)
Bug-fixes:
 - Make the 1:1 mapping work during early bootup on selective regions.
 - Add scratch page to balloon driver to deal with unexpected code still holding
   on stale pages.
 - Allow NMIs on PV guests (64-bit only)
 - Remove unnecessary TLB flush in M2P code.
 - Fixes duplicate callbacks in Xen granttable code.
 - Fixes in PRIVCMD_MMAPBATCH ioctls to allow retries
 - Fix for events being lost due to rescheduling on different VCPUs.
 - More documentation.
</end>


 CREDITS                            |   1 +
 Documentation/tpm/xen-tpmfront.txt | 113 +++++++++
 MAINTAINERS                        |  16 +-
 arch/x86/include/asm/xen/events.h  |   1 +
 arch/x86/xen/enlighten.c           |  15 +-
 arch/x86/xen/irq.c                 |  25 +-
 arch/x86/xen/p2m.c                 |  22 +-
 arch/x86/xen/setup.c               |  29 ++-
 arch/x86/xen/smp.c                 |   6 +
 drivers/char/tpm/Kconfig           |  12 +
 drivers/char/tpm/Makefile          |   1 +
 drivers/char/tpm/xen-tpmfront.c    | 473 +++++++++++++++++++++++++++++++++++++
 drivers/tty/hvc/hvc_xen.c          |   6 +-
 drivers/xen/balloon.c              |  74 +++++-
 drivers/xen/events.c               |  30 ++-
 drivers/xen/evtchn.c               | 191 ++++++++-------
 drivers/xen/gntdev.c               |  11 +-
 drivers/xen/grant-table.c          |  13 +-
 drivers/xen/privcmd.c              |  83 +++++--
 drivers/xen/swiotlb-xen.c          |   8 +-
 drivers/xen/xen-selfballoon.c      |  54 +++--
 include/xen/balloon.h              |   3 +
 include/xen/interface/io/tpmif.h   |  52 ++++
 include/xen/interface/vcpu.h       |   2 +
 lib/swiotlb.c                      |   8 +-
 25 files changed, 1060 insertions(+), 189 deletions(-)

Andres Lagar-Cavilla (1):
      Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.

Dan Carpenter (1):
      xen/evtchn: double free on error

Daniel De Graaf (1):
      drivers/tpm: add xen tpmfront interface

David Vrabel (5):
      xen/p2m: avoid unneccesary TLB flush in m2p_remove_override()
      xen/evtchn: improve scalability by using per-user locks
      x86/xen: disable premption when enabling local irqs
      x86/xen: during early setup, only 1:1 map the ISA region
      xen/events: document behaviour when scanning the start word for events

EunBong Song (1):
      swiotlb: replace dma_length with sg_dma_len() macro

Jingoo Han (1):
      xen: replace strict_strtoul() with kstrtoul()

Joe Perches (1):
      hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc

Konrad Rzeszutek Wilk (5):
      xen: Support 64-bit PV guest receiving NMIs
      MAINTAINERS: Update the Xen subsystem's with proper mailing list.
      MAINTAINERS: Add in two extra co-maintainers of the Xen tree.
      MAINTAINERS: Remove Jeremy from the Xen subsystem.
      drivers/xen-tpmfront: Fix compile issue with missing option.

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Stefano Stabellini (4):
      xen/balloon: set a mapping for ballooned out pages
      swiotlb-xen: replace dma_length with sg_dma_len() macro
      xen: fix ARM build after 6efa20e4
      xen/m2p: use GNTTABOP_unmap_and_replace to reinstate the original mapping

Vaughan Cao (1):
      xen/pvhvm: Initialize xen panic handler for PVHVM guests

Wei Liu (1):
      xen/balloon: don't set P2M entry for auto translated guest


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSJgZ1AAoJEFjIrFwIi8fJb4wH/31LcCJWzJJ+FaHXlB15X3/3
r6saR62d78wcZDTwdyRAk+v8TTQb2IqtKa/QHM2ZSxqQI54vys7CjMpxEQmWV61A
Rln7HNmyqIBRfOWgwrhDOoraTpl8HBGsQ1ZossnqwML4WDK0wzQpr9iNyx2VIyHM
hxnGVR0dLhxE7qnujz7bYCj1g2+KZERDAdqEsI2F5ykx6StMWy6V+xLmt9o/+M/B
Ql3vgEU+9ZIy8FV6nQIgB0V/CBrDPjJy4RnVkaLeL0M/39sFJtFlXrhRyWL9t8GR
YQG9xAzaeSvZa2flCH78beA5Ib7ny/yGodKuQBxZv4nGQ75Ysqcc6u8xmAvKFBE=
=I4c8
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
