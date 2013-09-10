Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3IJMpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:45:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IJMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:45:17 -0400
Date: Tue, 10 Sep 2013 08:44:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.12-rc0-tag-two for v3.12-rc0
Message-ID: <20130910124448.GA5038@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.12-rc0-tag-two

This pull I usually do after rc1 is out but because we have a nice amount
of fixes, some bootup related fixes for ARM, and it is early in the cycle we
figured to do it now to help with tracking of potential regressions.

The simple ones are the ARM ones - one of the patches fell through the cracks,
other fixes a bootup issue (unconditionally using Xen functions). Then a
fix for a regression causing preempt count being off (patch causing
this went in v3.12). Lastly are the fixes to make Xen PVHVM guests use PV
ticketlocks (Xen PV already does).

The enablement of that was suppose to be part of commit
816434ec4a674fcdb3c2221a6dffdc8f34020550
(Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)

	Pull x86 spinlock changes from Ingo Molnar:
	"The biggest change here are paravirtualized ticket spinlocks (PV
	spinlocks), which bring a nice speedup on various benchmarks. ..."

but unfortunatly it would cause hang when booting Xen PVHVM guests.
Yours truly got all of the bugs fixed last week and they (six of them)
are included in this pull.

Please pull!

 arch/arm/xen/enlighten.c | 14 +++++++++++++-
 arch/x86/xen/enlighten.c |  1 -
 arch/x86/xen/p2m.c       | 10 ++++++----
 arch/x86/xen/smp.c       | 28 +++++++++++++++++++++++-----
 arch/x86/xen/spinlock.c  | 45 ++++++++-------------------------------------
 5 files changed, 50 insertions(+), 48 deletions(-)

Boris Ostrovsky (1):
      xen/p2m: Don't call get_balloon_scratch_page() twice, keep interrupts disabled for multicalls

Julien Grall (1):
      xen/arm: disable cpuidle and cpufreq when linux is running as dom0

Konrad Rzeszutek Wilk (6):
      xen/spinlock: Fix locking path engaging too soon under PVHVM.
      xen/spinlock: We don't need the old structure anymore
      xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
      xen/spinlock: Don't setup xen spinlock IPI kicker if disabled.
      Revert "xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM"
      xen/spinlock: Don't use __initdate for xen_pv_spin

Rob Herring (1):
      ARM: xen: only set pm function ptrs for Xen guests


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSLxQ8AAoJEFjIrFwIi8fJ/NEIAMBclaI36cW/cA8oQ/ZrDLc/
cvRSAmRO7G6cDhtHoU3W75UEK0R2rvFK18coLj8WG3MaxfbHx8XDsLZzI685IAoC
wzanBdSGldBjQ1Z5EYWUUSicPs+jrO6pG1TcqW2P0gN/ybtjwL+zTdmiR7HUso4/
0lz7EdJSBtCeolFY8VPIfLAW7temya0x+jPNCk+9wr35FnPJSOFwscIYmsgC401k
S3WbnwJ/BSIU7HHUkgogY5rX1C+0KuyXVj6mFmeQJn3KqYav5Wgy2ojWMOCG/UIb
LbYFkz4PU+IS/Abl3ppa1hvbIkK4xcoSo6yAj0m5/Xm+L9LQL8U1JOQiYwn+vSk=
=GmsM
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
