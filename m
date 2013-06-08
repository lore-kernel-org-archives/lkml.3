Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3FHGNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 02:13:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52960 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3FHGNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 02:13:06 -0400
Date: Sat, 8 Jun 2013 09:11:14 +0300
From: Sergei Trofimovich <slyfox@gentoo.org>
To: gentoo-dev@lists.gentoo.org
Cc: ryao@gentoo.org, Kernel development list <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, gentooligan@gmail.com
Subject: Re: [gentoo-dev] dm-crypt reordering BIOs across barriers?
Message-ID: <20130608091114.441c5f17@sf>
In-Reply-To: <51B2A955.4010906@gentoo.org>
References: <51B2A955.4010906@gentoo.org>
Reply-To: gentoo-dev@lists.gentoo.org
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fo7M09A2dxvn/n99HU_TveV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fo7M09A2dxvn/n99HU_TveV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Jun 2013 23:47:33 -0400
Richard Yao <ryao@gentoo.org> wrote:

> When you use dm-crypt, block IO requests to a dm-* device will invoke
> dm_request_fn() -> map_request() -> crypt_map(). If a BIO is a write
> barrier, crypt_map() will return DM_MAPIO_REMAPPED to map_request(),
> which will immediately queue it to the device.
>=20
> If a few dozen IOs are queued in rapid succession with multiple write
> barriers, all write barriers will be executed before any actual write
> BIOs occur because the write IOs will be processed asynchronously in a
> work queue. Since the barriers will be long gone by the time the write
> IOs are queued, they can be queued in any order.
>=20
> Am I misunderstanding this or is dm-crypt ignoring proper write barrier
> semantics?
>=20
http://www.saout.de/pipermail/dm-crypt/2012-April/002441.html
http://lwn.net/Articles/400541/

--=20

  Sergei

--Sig_/fo7M09A2dxvn/n99HU_TveV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGyywYACgkQcaHudmEf86qSNwCePybnYkljHZgbPS2hTdks3mOp
ZUAAn2z23+P8ndmybC4CF/QgXTPluT4t
=QXSG
-----END PGP SIGNATURE-----

--Sig_/fo7M09A2dxvn/n99HU_TveV--
