Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBYT2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:28:13 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41990 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYT2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:28:12 -0500
Date: Tue, 25 Feb 2014 11:28:02 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, Pekon Gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [GIT PULL] MTD fixes for 3.14-rc
Message-ID: <20140225192802.GA4194@ld-irv-0074>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140225

for you to fetch changes up to bb38eefb6858ce16b34716145b9597a5680aa54c:

  mtd: nand: omap: fix ecclayout->oobfree->length (2014-02-23 14:49:57 -0800)

----------------------------------------------------------------
Two main MTD fixes:

 1. Read retry counting was off by one, so if we had a true ECC error (i.e., no
    retry voltage threshold would give a clean read), we would end up returning
    -EINVAL on the Nth mode instead of -EBADMSG after then (N-1)th mode

 2. The OMAP NAND driver had some of its ECC layouts wrong when introduced in
    3.13, causing incompatibilities between the bootloader on-flash layout and
    the layout expected in Linux. The expected layouts are now documented in
    the commit messages, and we plan to add this under Documentation/mtd/nand/
    eventually.

----------------------------------------------------------------
Brian Norris (1):
      mtd: nand: fix off-by-one read retry mode counting

Pekon Gupta (3):
      mtd: nand: omap: fix ecclayout to be in sync with u-boot NAND driver
      mtd: nand: omap: fix ecclayout->oobfree->offset
      mtd: nand: omap: fix ecclayout->oobfree->length

 drivers/mtd/nand/nand_base.c |  2 +-
 drivers/mtd/nand/omap2.c     | 61 +++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 22 deletions(-)

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTDO7CAAoJEFySrpd9RFgtdrMQAKnJZGCp9UNp/F47Wnh+lGiK
kXY9XBpRSzJSSLGtf53wgbw8dbtDyx50gW9prXZ4VaIPJ2GCoXXYL+EWDMfp/BiB
7NtKn+QL2hsUDPIOp9/Gpb2gZNOunxUWCr0o8DXFoYN+cVOhnfiNBlGegECRjox9
hQ/ZIrNV/hzUdg3GzDmJgMs/MpX9IWZQZh8oiWXiQRIt1zecPZ6Ml2PW2jeqWQk9
r9dleGztpREkDcsVmHY3iYN5PdvaJHgXB0ygZdDqR0/ssaHf5raRz1F6A9S8/x35
3Vn6PbJyoHRab3tCGqy6mQeoAutgy+Hm7z7S5GMgdnWZvspMq9YizKAT632WyLRy
lGaXIQ+j1eu4/2MC2uJOzdL0oanKdgUiuk1ezX1XuV0urlwC6Xmt0xTbVKg8ubwZ
xwF8TVz/C7PsSUAzu5cDa/2mlbYTi+m08nBPUnGoCan/4HSEmNbHVT7ZiLqS8rnF
7POHd9w1AilUYYBCaX4spKJH+h+Qyy5zgJjeGmB6xjn5mIVldWFfLkRK5NgqapaU
4zragee7NT6K5TUSSzRVO3tjEiwGAc+yD8w53m6KrTRgA53ry9OlhNLA8hElAOj2
YUjJOZ2PjyIRNbby9fku2X8bozNZXMZgijhf9+lQmOYcI5yF1FqoIf2MNLQIWSlL
sS12vcPuzu5s4j1K/Rtm
=s7u3
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
