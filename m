Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaEZGa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:30:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:10644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaEZGaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:30:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,911,1392192000"; 
   d="asc'?scan'208";a="517675368"
Date: Mon, 26 May 2014 11:44:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20140526061435.GB21128@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DWg365Y4B18r8evw"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DWg365Y4B18r8evw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the pull request for slave dmaengine for 3.15. We have three small
fixes. First one from Andy reverts the devm_request irq as we need to ensur=
e the
tasklet is killed after irq is freed, so we need to do free irq in our code.
Other two from Arnd are fixing the compilation issue in omap and sa11x0
drivers with ARM randconfigs

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:
  Linus Torvalds (1):
        Linux 3.15-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Andy Shevchenko (1):
      dmaengine: dw: went back to plain {request,free}_irq() calls

Arnd Bergmann (2):
      dmaengine: omap: hide filter_fn for built-in drivers
      dmaengine: sa11x0: remove broken #ifdef

 drivers/dma/dw/core.c    |   11 ++++++-----
 drivers/dma/sa11x0-dma.c |    4 ----
 include/linux/omap-dma.h |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

--=20
Thanks
~Vinod

--DWg365Y4B18r8evw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTgtvKAAoJEHwUBw8lI4NHu6UP+wdZH2bTvkSpIAbUgI7C1MJN
NdPE7kOTc1YUNmuBScqWL4EKqmDXOO88i37P5zdmXJKX/31SS2gonAoKGr3+x5Gc
sKIasVa94iXj3uRn5WONwBNZWtUdVlSF3+uT78+tDBfyZdZgdimoXhhEjWTkWV71
mZuUYpt5ghItE82BLpRQJuYFSWfbRIPUhRGC7kAZfpGrSGd6HbK7z9SMeS2zOYlH
cw+ZL56V8z34x9+9ht0nxa4wDyxo8vbpGD27BKFRhJyCj8jwbBBta4tWnz3dIG0K
Pnwwa0J4ARR7iDyqvWv6cucsCTYNd/E4E5eiUtnZXuSeR6v/qTJu/qXs2PGBrfFP
Qrj+l/suRF8doW8QZy8L7+s4QhUNkS0YNZaaxSHmj91sTDK5lR80LAyZY/ZsUwHR
jJ2UkVtcopdtYM02W2HmA9Sz9Uhx1/1WtBM1ASAquqtUSKD5/aYIc8JhSRlS+YVx
TLGw9kaQYs0ZGfJt3ZxhPQPKKuU/mCdPIv/C8gfJgZyvuRMCVzdX6OdQJu9RqNp/
tQcVtkv9tPzCK0P7EqX/eN7PXspTR54371FSpFVj6dxjBXJx2dayCMMNh4zAD0v4
0QjKkSX8JnMGLZ2R3TXPj+BVqSDzPl8FGNTQF4jW15iSIteN/xA938yMzNCmKtld
du0tUrv/nlfaLOnNz1R9
=SG8/
-----END PGP SIGNATURE-----

--DWg365Y4B18r8evw--
