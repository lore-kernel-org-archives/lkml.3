Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3JQVY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:24:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33578 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3JQVYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:24:25 -0400
Date: Thu, 17 Oct 2013 22:23:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131017212319.GS2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo/uxZtUN5p1coZJ"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the tip tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo/uxZtUN5p1coZJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Today's linux-next merge of the kvm-arm tree got conflicts in
mm/mprotect.c between c3d16e1652 (mm: migration: do not lose soft dirty
bit if page is in migration state) from Linus' tree and e920e14c (mm: Do
not flush TLB during protection change if !pte_present &&
!migration_entry) from the tip tree.

I've fixed up as below and can carry as required.

diff --cc mm/mprotect.c
index a3af058,a0302ac..0000000
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@@ -100,12 -89,11 +90,12 @@@ static unsigned long change_pte_range(s
  				 * just be safe and disable write
  				 */
  				make_migration_entry_read(&entry);
 -				set_pte_at(mm, addr, pte,
 -					swp_entry_to_pte(entry));
 -
 +				newpte = swp_entry_to_pte(entry);
 +				if (pte_swp_soft_dirty(oldpte))
 +					newpte = pte_swp_mksoft_dirty(newpte);
 +				set_pte_at(mm, addr, pte, newpte);
+ 				pages++;
  			}
- 			pages++;
  		}
  	} while (pte++, addr += PAGE_SIZE, addr != end);
  	arch_leave_lazy_mmu_mode();

--xo/uxZtUN5p1coZJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYFVEAAoJELSic+t+oim9sgQP/jO/dWHf//UdGgyRKG3patoQ
/KF8h8WS+OeecTneIJ6QSaqAwt4C6twGGMBK3O+BVpKaWVxNRNS/sP8L5inn9LDn
99aeJB2rM1gPe/lcI8vYofXu9Obp+Io4piB3wZmP3ndjY10EVuibYF7eO3dXDGPw
mSPmF2uBPBDo+0IvtKKLPIOCwfTgMau8aLvLj4av/NfSENe4O01nbtQVK1AFHZcn
8egDQOVkiPgMy1CbbDlsEH+146kYCuhxmgCfj8oaUOOgS0MTFDRNTdJixK1/Ou8+
9nvb5HqiyFiBcnuIJM9ZDUujwlx0r9s+xYKJVTC0pM/doS1RoBaKKXqwUT3GO+nH
OmoXsMKqL+tRItV87yuKAHOTWcl1UXzCNOa0UxP1K/4EolJsMMKzutc8J3ayqiPy
M4euEus8DcsCmmlz//MkOvgRtulXRJip4u6O0cmtkchNRg4znxlcjaWL9WnBhUyK
VmwneuxolgPSWaMVsMIS4FJRXCCDGI0Rq0qMBpYiYhekXEUGJE2T/kQm6IP5LjXH
nqufEUb/9eq2vXpIX86M95DdVxkft5I8b0FQLCrbQYCQPjmGFfAEPJVcW2kf+/WG
I54vWwln0PqqGYDQzdHUTU2ZoH3blMQLtKMmPjE02j00VFDzTH55UWA1O2E5K0dj
vFi+jqhnVt1zG6xVeK2t
=Q6YX
-----END PGP SIGNATURE-----

--xo/uxZtUN5p1coZJ--
