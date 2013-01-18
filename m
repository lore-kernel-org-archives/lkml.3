Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3ARDuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:50:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3ARDue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:50:34 -0500
Date: Thu, 17 Jan 2013 22:49:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.8-rc3-tag
Message-ID: <20130118034928.GA6319@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.8-rc3-tag

which has fixes that have been accumulating since rc0<signed tag>
Fixes:
 - CVE-2013-0190/XSA-40 (or stack corruption for 32-bit PV kernels)
 - Fix racy vma access spotted by Al Viro
 - Fix mmap batch ioctl potentially resulting in large O(n) page allcations.
 - Fix vcpu online/offline BUG:scheduling while atomic..
 - Fix unbound buffer scanning for more than 32 vCPUs.
 - Fix grant table being incorrectly initialized
 - Fix incorrect check in pciback
 - Allow privcmd in backend domains.
</signed tag>

You will find that I had to pull in my tree 'v3.7' as the original
root of the 'stable/for-linus-3.8' was based on v3.7-rc3, but there are
fixes (the ones from Daniel and Andres) that are dependent on the v3.7-rc6.
To make it easier I merged the v3.7 in the 'stable/for-linus-3.8'.

You are still going to have a merge conflict in the arch/arm/xen  - but
that one is fairly easy to fix (just remove the two functions with XXX and
leave the EXPORT_SYMBOL_GPLs). I did a resolution in #linux-next-resolution
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next-resolution
in case you want to double-check yourself.

Please pull!

 arch/x86/kernel/entry_32.S        |   1 -
 arch/x86/xen/smp.c                |   7 --
 drivers/xen/cpu_hotplug.c         |   4 +-
 drivers/xen/gntdev.c              | 130 ++++++++++++++++++++++++++------------
 drivers/xen/grant-table.c         |  48 ++++++++------
 drivers/xen/privcmd.c             |  89 ++++++++++++++------------
 drivers/xen/xen-pciback/pciback.h |   2 +-
 7 files changed, 167 insertions(+), 114 deletions(-)

Andres Lagar-Cavilla (1):
      xen/privcmd: Fix mmap batch ioctl.

Andrew Cooper (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.

Daniel De Graaf (3):
      xen/gntdev: fix unsafe vma access
      xen/gntdev: correctly unmap unlinked maps in mmu notifier
      xen/gntdev: remove erronous use of copy_to_user

Jan Beulich (1):
      Xen: properly bound buffer access when parsing cpu/*/availability

Konrad Rzeszutek Wilk (1):
      Revert "xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while atomic."

Matt Wilson (1):
      xen/grant-table: correctly initialize grant table version 1

Tamas Lengyel (1):
      xen/privcmd: Relax access control in privcmd_ioctl_mmap

Yang Zhang (1):
      x86/xen : Fix the wrong check in pciback


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJQ+MY0AAoJEFjIrFwIi8fJalAH/2f716C+Hr30erFggIPD7cg8
IHncZHWbz9GjwXLhy5KSr1x56RfGzFKtD9fytzvcLMqEKnRI3pmLaBNMz5GDbIL1
lawq5WzInoGtypepgwi36AWi+jkUxlETleeOZCxO7jYhDgnaGduSw9+PAPfXCzTh
RV0LVLjhQiiouykwrpighR/058HFpW3AoXltAuPzDfaTIFeAxMy4I3xd5K60SCe5
6s343eFXjy4NuqbHf2W6n0SwyT0FnPIi7axvAF1QvI/jH3CfjyVFoN001ZzWlY8n
BNameAo0RjFDfcpOqbqswsUmGYLqp+5knsRd1jlzQDAl1RplD9vs8AwsdInBn7k=
=EGaA
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
