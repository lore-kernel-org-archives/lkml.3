Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaGHEDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:03:04 -0400
Received: from ozlabs.org ([103.22.144.67]:53416 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaGHEDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:03:00 -0400
Date: Tue, 8 Jul 2014 14:02:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: linux-next: build failure after merge of the iommu tree
Message-ID: <20140708140246.72b72682@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wYju90pWi_NtUsj2=dqeIY_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wYju90pWi_NtUsj2=dqeIY_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

After merging the iommu tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/built-in.o:(.opd+0x29e8): multiple definition of `io=
mmu_device_destroy'
arch/powerpc/kernel/built-in.o:(.opd+0x5628): first defined here
arch/powerpc/platforms/built-in.o: In function `.iommu_device_unlink':
(.text+0x13240): multiple definition of `.iommu_device_unlink'
arch/powerpc/kernel/built-in.o:(.text+0x2b240): first defined here
arch/powerpc/platforms/built-in.o: In function `.iommu_device_create':
(.text+0x13210): multiple definition of `.iommu_device_create'
arch/powerpc/kernel/built-in.o:(.text+0x2b210): first defined here
arch/powerpc/platforms/built-in.o: In function `.iommu_device_destroy':
(.text+0x13220): multiple definition of `.iommu_device_destroy'
arch/powerpc/kernel/built-in.o:(.text+0x2b220): first defined here
arch/powerpc/platforms/built-in.o: In function `.iommu_device_link':
(.text+0x13230): multiple definition of `.iommu_device_link'
arch/powerpc/kernel/built-in.o:(.text+0x2b230): first defined here
arch/powerpc/platforms/built-in.o:(.opd+0x2a00): multiple definition of `io=
mmu_device_link'
arch/powerpc/kernel/built-in.o:(.opd+0x5640): first defined here
arch/powerpc/platforms/built-in.o:(.opd+0x2a18): multiple definition of `io=
mmu_device_unlink'
arch/powerpc/kernel/built-in.o:(.opd+0x5658): first defined here
arch/powerpc/platforms/built-in.o:(.opd+0x29d0): multiple definition of `io=
mmu_device_create'
arch/powerpc/kernel/built-in.o:(.opd+0x5610): first defined here

Caused by commit c61959ecbbc6 ("iommu: Add sysfs support for IOMMUs").
CONFIG_IOMMU_API is not set for this build.  Forgotten "static
inline"s :-(

I have used the iommu tree from next-20140707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wYju90pWi_NtUsj2=dqeIY_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTu21sAAoJEMDTa8Ir7ZwVOc8P/30DE2ot+kzjMus4lresXAKD
/UvSmRb7OvT2WY7felMJ/LRfGUOvYkvxIlVXTAyI51LCjTf5Jow5LqKnBo3gr58s
Nw842DoWklFP4dmV6FEtqmSpQk6V5k4QaDVG28xnHOaS+vvPpoXJ9Fsk574mTrJ+
yfZi4kEj+FuzRcNXtWEzEgyanEkey5DqiPeIIrHGzpDq7pficQhNKYpW+5kduYRs
3LzZjHQ72+3+WnngbRvrxSN3sNJpMgp6NTVGXsI426LJ+xW/klV3ktv8k0qLHfOg
UW4/9nUu9hzA5eCabSrQUatD26w5wBER5yp2gQMZQglaFP3DabCMwKJkUvq/u0KT
gp17zEBGvXw143X4pSqoQMv0az5l+/clDzxR3/GMqp1zbpnlR/iXFHjhDlOE9inA
6Le2181/e34lUxcCMH6RRHQhP+GkRCoAJ5aCAYcVpoRqle6sJeoKWvVOTyFk+ZAt
EeU2tbxPnUZpaPIh2bfj+o9FQEMo+7h0rkCW0cObp8/Xbj7WwfdljuGyC6lbNgLq
TzZDGvp5/SVNPAAlqtLipkTJa7VE1MPcTbAjio7D6S2z6bWaSG0n2ssFgWo+M9ox
oktCKCqhU1tpxkRAYqQZcCIgsXtyh2eBpTudw7WYi6xOfPASkEzGP9YZ2E3HwS/Y
ohxFNsqe7xFcn/tpTss/
=pmJJ
-----END PGP SIGNATURE-----

--Sig_/wYju90pWi_NtUsj2=dqeIY_--
