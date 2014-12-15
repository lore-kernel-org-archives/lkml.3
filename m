Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaLOSFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:05:00 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41713 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:04:57 -0500
Message-ID: <548F22C5.70401@cantab.net>
Date: Mon, 15 Dec 2014 18:04:53 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <Boris.Ostrovsky@oracle.com>
Subject: [GIT PULL] xen: additional features for 3.19-rc0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.19-rc0b-tag

xen: additional features for 3.19-rc0

- - Linear p2m for x86 PV guests which simplifies the p2m code, improves
  performance and will allow for > 512 GB PV guests in the future.

Thanks.

A last-minute, configuration specific issue was discovered with this change
which is why it was not included in my previous pull request.  This is now been
fixed and tested.

David

 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/include/asm/xen/page.h      |   64 +-
 arch/x86/mm/pageattr.c               |   20 +
 arch/x86/xen/mmu.c                   |   40 +-
 arch/x86/xen/p2m.c                   | 1172 +++++++++++++---------------------
 arch/x86/xen/setup.c                 |  441 ++++++-------
 arch/x86/xen/xen-ops.h               |    6 +-
 7 files changed, 779 insertions(+), 965 deletions(-)

David Vrabel (1):
      Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Juergen Gross (13):
      xen: fix some style issues in p2m.c
      xen: Make functions static
      xen: use common page allocation function in p2m.c
      xen: Delay remapping memory of pv-domain
      xen: Delay m2p_override initialization
      xen: Delay invalidating extra memory
      x86: Introduce function to get pmd entry pointer
      xen: Hide get_phys_to_machine() to be able to tune common path
      xen: switch to linear virtual mapped sparse p2m list
      xen: Speed up set_phys_to_machine() by using read-only mappings
      xen: introduce helper functions to do safe read and write accesses
      xen: annotate xen_set_identity_and_remap_chunk() with __init
      xen: switch to post-init routines in xen mmu.c earlier
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJUjyK/AAoJEFxbo/MsZsTR2sQIAKpHjcGBVCKFoOGzfMjKGlab
cB/dAoTJD3iqde0ic0CH9hz2ZVHGz2yDA3PSBmuJf4QPMX2uCmE8K0RVZAtzntFj
YPsHWXDrsJBfBKBpi7gnmsNwA1VEVTW+3KYumPVprKOoAgYlVPzI/NdJxW+hucCo
gg8/f74OtEiyq8lOBo1Z7gYjh5nv4lc+1WgsaBGSWYWnn0zma6TGmB3jtBdryIuN
/KnPO4cFfkbx/nFwhlJ/mpMeC/ZI7aTU1u5Y1wAlcK3a9fItJT/WsD5orsGANddQ
rgeOceBCegd6YIQ6Q/CAu4uEqjNFgKz8G+0NyYI327/KaAQDykh8sKYQqUiK1Ew=
=UBAl
-----END PGP SIGNATURE-----
