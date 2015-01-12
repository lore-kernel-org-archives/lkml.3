Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbbALA0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:26:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbbALA0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:26:49 -0500
Message-ID: <1421022401.19708.40.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 072/168] ARM: 8109/1: mm: Modify pte_write
 and pmd_write logic for LPAE
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Steve Capper <steve.capper@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Hou Pengyang <houpengyang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Mon, 12 Jan 2015 00:26:41 +0000
In-Reply-To: <1418653622-21105-73-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	 <1418653622-21105-73-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SrnQ/zKgVOeGcQkYhJTn"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SrnQ/zKgVOeGcQkYhJTn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-12-15 at 14:25 +0000, Luis Henriques wrote:
> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: Steven Capper <steve.capper@linaro.org>
>=20
> commit ded9477984690d026e46dd75e8157392cea3f13f upstream.
>=20
> For LPAE, we have the following means for encoding writable or dirty
> ptes:
>                               L_PTE_DIRTY       L_PTE_RDONLY
>     !pte_dirty && !pte_write        0               1
>     !pte_dirty && pte_write         0               1
>     pte_dirty && !pte_write         1               1
>     pte_dirty && pte_write          1               0
>=20
> So we can't distinguish between writeable clean ptes and read only
> ptes. This can cause problems with ptes being incorrectly flagged as
> read only when they are writeable but not dirty.
>=20
> This patch renumbers L_PTE_RDONLY from AP[2] to a software bit #58,
> and adds additional logic to set AP[2] whenever the pte is read only
> or not dirty. That way we can distinguish between clean writeable ptes
> and read only ptes.
>=20
> HugeTLB pages will use this new logic automatically.
>=20
> We need to add some logic to Transparent HugePages to ensure that they
> correctly interpret the revised pgprot permissions (L_PTE_RDONLY has
> moved and no longer matches PMD_SECT_AP2). In the process of revising
> THP, the names of the PMD software bits have been prefixed with L_ to
> make them easier to distinguish from their hardware bit counterparts.
>=20
> Signed-off-by: Steve Capper <steve.capper@linaro.org>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Hou Pengyang <houpengyang@huawei.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

This one also looks suitable for 3.4 onwards, except that THP was not
supported before 3.11.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-SrnQ/zKgVOeGcQkYhJTn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLMUwee/yOyVhhEJAQrpHg//aI5Neo2T5cT0DcbCEdgYTcn+QxFsbz0N
rLxbnpt8opkiSJYZwAkTPu3LXaA2cQzzwBxowmq/JXFyVpX+vDScCdSz8XnqS23T
5fu44gq/jNvKGQgpmZO4jcGjL4SN2uNmkpo6XcifRZFCLsadxRNlR/3EjKLAwxuM
AtT+t4gCGw4HnOu0Zn4zREGj6ccNQ7baAroAJgV+bykSTW28sWsaoURrIH45oUgd
cLjvIZc0MZQcPllueiLYpCRyxnYsJoKOdsL0fdjps4syb7qLNcEIVgbi4Lh1D3IU
oRSOexVdLv8WsAAlUZnMu0qvYizuVdG3Y6TGeIbSaHRYT45znKnz3yxrIIdprcaU
qoS6oTIxsoK0bYHrkpIJBFE90bGHw2Knl1AQTQZE/lVUhQsoHjBfH1MpBKaviPda
kGMTddPEEYZDHCAl2NlS7tLacYF3sqTRYm1bUMB5A4MG0dLD6xqhsnA9+Gbt9O4X
vjqW2FWhByNrOXaS3udUUHqmO99PMMDzNk5d/ljkg+PN2KM2o4q/1LvBioXFtK7u
e7whVDJgHOs2y+kcu/bZuGlclN2GQRfQKOqcGaAz2qH3wHp/qgdS5bGb5iqFlxwV
1NXt2ZfslntEFNOvBQAJ7XdahPoQauMQqULZv091ARh3WTxLpcduFx7IBX0hLZx0
C7d/O6MjXzI=
=sKJF
-----END PGP SIGNATURE-----

--=-SrnQ/zKgVOeGcQkYhJTn--
