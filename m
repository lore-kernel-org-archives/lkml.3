Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaEFNrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:47:48 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52170 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaEFNrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:47:47 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_9189EA54-F5A5-46AD-97F1-6828321A632E"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: IMA & truncate
From: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javigon.napster@gmail.com>
In-Reply-To: <5368E46B.9050708@samsung.com>
Date: Tue, 6 May 2014 15:47:40 +0200
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, viro@ZenIV.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <5A7C7E18-F8E0-43C4-B2FF-F28B91BBCD2C@gmail.com>
References: <5368E46B.9050708@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_9189EA54-F5A5-46AD-97F1-6828321A632E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi,

> I have discovered one IMA related issue.
>=20
> IMA file hash is re-calculate if needed on file close.
>=20
> It works with ftruncate(fd, length) syscall, because it operates on
> "opened" file.
> Recalculation is happening on file close.
>=20
> truncate(path, length) syscall works with path and no file open/close
> takes place.
> Recalculation does not happen.
> IMA denies file access later.
>=20
> It looks like vfs_truncate() should possibly call IMA to recalculate =
the
> hash.

I have had the same issue in an integrity module I am working on to move =
the hash (and generally encryption) operations to a secure processor =
(e.g., TrustZone).
After a discussion with Al Viro I was convinced that file_close is not =
the right place to associate a hook in order to recalculate the hash.

I am now using the LSM hook associated with vfs_truncate to recalculate =
the hash and it seems to work good. I am still running some performance =
tests to calculate the overhead of attacking an operation here, so I =
don=92t have data yet.=20

Best,

-------------------------------------------------/--
Javier Gonz=E1lez

IT University of Copenhagen
Rued Langgaards Vej 7, 2300
K=F8benhavn S, Danmark=20
Office: 4D23

http://javigon.com/
Skype: javigon.napster
(+45)31376927

-------------------------------------------------/--

On 6 May 2014, at 15:32, Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> Hi,
>=20
> I have discovered one IMA related issue.
>=20
> IMA file hash is re-calculate if needed on file close.
>=20
> It works with ftruncate(fd, length) syscall, because it operates on
> "opened" file.
> Recalculation is happening on file close.
>=20
> truncate(path, length) syscall works with path and no file open/close
> takes place.
> Recalculation does not happen.
> IMA denies file access later.
>=20
> It looks like vfs_truncate() should possibly call IMA to recalculate =
the
> hash.
>=20
> - Dmitry
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_9189EA54-F5A5-46AD-97F1-6828321A632E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJTaOf8AAoJEGn/+wzNTX/a6psH/13rKvVdRniWvuOT3g5ctPto
T1SoeDsOeyKk4jyn7g9nYETGvU+209672wQTSKSe4UumlUlZ1Dq4KdTWh06Lu+TZ
nTlWlfYWbnBHJAK+e3HB3faLgRijF/FMiAzcmu07SuzUOfVo5Ng9qcJ2OJUR8eiM
7m5LqsSTIaXoZd43Kd7RJij91IuFxsp9ZrK2z7dQ/vfZbOoBfRTtZ4x+kelxduRS
8JsycfBEbCTbvqDAAATtlYb0OaijScuqKx4CybA+P2iYBRZJ+nwEJOccayJY1WAV
GdpQoxXNmRUMgPx6esMtyDrkx5I9QfXTjx9XPtdHJz6oY667cAHefphEtd0L4Xs=
=aOs3
-----END PGP SIGNATURE-----

--Apple-Mail=_9189EA54-F5A5-46AD-97F1-6828321A632E--
