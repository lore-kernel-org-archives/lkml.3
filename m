Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaANQND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:13:03 -0500
Received: from sauhun.de ([89.238.76.85]:55775 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaANQNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:13:00 -0500
Date: Tue, 14 Jan 2014 17:12:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Phil Carmody <phil.carmody@partner.samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: Re-instate body of i2c_parent_is_i2c_adapter()
Message-ID: <20140114161254.GA6442@katana>
References: <1389648544-4201-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1389648544-4201-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 02:29:04PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> The body of i2c_parent_is_i2c_adapter() is currently guarded by
> CONFIG_I2C_MUX instead.

This paragraph sounds strange to me. I'll update it a little. After that
I'll go looking for a brown paper bag...

> Among potentially other problems, this resulted in i2c_lock_adapter()
> only locking I2C mux child adapters, and not the parent adapter. In
> turn, this could allow inter-mingling of mux child selection and I2C
> transactions, which could result in I2C transactions being directed to
> the wrong I2C bus, and possibly even switching between busses in the
> middle of a transaction.
>=20
> One concrete issue caused by this bug was corrupted HDMI EDID reads
> during boot on the NVIDIA Tegra Seaboard system, although this only
> became apparent in recent linux-next, when the boot timing was changed
> just enough to trigger the race condition.
>=20
> Fixes: 3923172b3d70 ("i2c: reduce parent checking to a NOOP in non-I2C_MU=
X case")
> Cc: Phil Carmody <phil.carmody@partner.samsung.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied to for-current, thanks for catching this one!


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1WIGAAoJEBQN5MwUoCm2fgIP/jxjNkl/nRcy5JSZvcJ0DDLb
eJl1ZXZXM12ZNLsJrhzo2Vwu5JoKhRaozJjdsSjMHfqa4w11i6QOT362hN22iHeD
fphck/Gf5HoLwAlTtWNXwFq48TdyYz8eW13OsbonkVeYegLxvsX8k+l0i2hcOgcF
L1zHIR0rLLyEt/ID7kafkSckv8jgd7KXgKmodHyr6UzcDBE7730ZexMMryLavTvo
K2N+mTRYdCsU4/W76quiXck5cBsx/2zbRahEafZaQEKSdPFJvqontZ/L011TxgvH
qowj7ejKUJS5sxeoEp38NWCIqSNJh7U+u4U8tCP6y7sij1fGLhO7bzT81TQR0Qwe
nrZ3eoXZwA9Ej9F6ARk+p028WC9SdWUzI72grpIUWja2QFdePqlFTzTVvVl2dUAI
QtxsIbfmX3CxhKx4CnYeyvanDMp4ga9faNioiyBQXCJCOKOS+hvS+G+LNnbuRU3A
GryB0ZvmfLGuo6aXJfJr5MlZnszU3KO9Jw5Ae6AFipTpiIwR9nebcJxz+ea4ruUt
oo+RNPf8v/h/imcAZcjMYSJNH2DlEjCaYsHR3gLF9yupXT7mpFZZraWbDnMyvGtO
hgIyNJLD2Px7cp05Ak9JRyFf1tmiNrOeqSuvd9eXt4CSkDCEyyTDrdTk2v/is+Hd
Y9pJokwq0a5/2kkebe4M
=gq0B
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
