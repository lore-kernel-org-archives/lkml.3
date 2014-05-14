Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaENPxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:53:47 -0400
Received: from sauhun.de ([89.238.76.85]:40862 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbaENPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:53:46 -0400
Date: Wed, 14 May 2014 17:53:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] i2c-designware: Mask all interrupts during i2c
 controller enable
Message-ID: <20140514155341.GB12911@katana>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FF93E0@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FF93E0@ORSMSX110.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 11:03:19PM +0000, Du, Wenkai wrote:
> Hi all,
>=20
> Updated problem descriptions from Mika's feedback and new test data:=20
>=20
> There have been "i2c_designware 80860F41:00: controller timed out" errors
> on a number of Baytrail platforms. The issue is caused by incorrect value=
 in
> Interrupt Mask Register (DW_IC_INTR_MASK)  when i2c core is being enabled=
=2E=20
> This causes call to __i2c_dw_enable() to immediately start the transfer w=
hich
> leads to timeout. There are 3 failure modes observed:
>=20
> 1. Failure in S0 to S3 resume path
>=20
> The default value after reset for DW_IC_INTR_MASK is 0x8ff. When we start=
=20
> the first transaction after resuming from system sleep, TX_EMPTY interrup=
t=20
> is already unmasked because of the hardware default.
>=20
> 2. Failure in normal operational path
>=20
> This failure happens rarely and is hard to reproduce. Debug trace showed =
that
> DW_IC_INTR_MASK had value of 0x254 when failure occurred, which meant=20
> TX_EMPTY was unmasked.
>=20
> 2. Failure in S3 to S0 suspend path
>=20
> This failure also happens rarely and is hard to reproduce. Adding debug t=
race
> that read DW_IC_INTR_MASK made this failure not reproducible. But from IS=
R=20
> call trace we could conclude TX_EMPTY was unmasked when problem occurred.
>=20
>=20
> The patch masks all interrupts before the controller is enabled to resolv=
e the
> faulty DW_IC_INTR_MASK conditions.
>=20
> Signed-off-by: Wenkai Du <wenkai.du@intel.com>

Fixed the commit message and improved the comment to:
	/* enforce disabled interrupts (due to HW issues) */"

Applied to for-current, thanks!


--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTc5GFAAoJEBQN5MwUoCm2p+YP/1cc1fFM7NIC6itbZOgCv1YY
qLaDsPK1KubCDls98cL6OEXVR7UCEF1QvnQW1KiW79r8jyooG4vaXhNhSbI+nCD+
GNlR0uSdCSVDfw2X/vaAl7GQDOIwqZfMRhi2miNP28py9LsV/OH1QajzWnfcq4ir
5E7uWA1cBKnE7CoAnHY2g9qj5geCTWeXrYQiCYmI0C8wszpwe8QOffvXnlGZWwa7
GUBhORwjrYKOb5EXPye/S7IAkN8AVV6Q4/hX9me01G38rIomCSOp3u4h/TDwgiFF
E0RRnyfGC8xk24a8tS8kINtlhwI9YIpHsQi5fEbGtephsNFwQEFYTaln9EkbhKEq
eLk0oneqFgM2Gpk+aUufcjiZe1UlDXYLAjqTNWzQmXGqVKZJCH90iCyohJREKCqn
RMr/qRwnIJTrZO6pzJSPnqGuq9JOB/dNM4A+oXwbpoc1d4etgCf4M82dq+QPJsId
krbywNaYHKIGxvrAWe+8xHQNoshLwK4/oXfLVLqsuwQAntM/k0lO3GWuU6DYDWht
ASXM8cel1XcwxADFS4B4ejRzOydYX/DW4Vhxk7q4metv1i6bYBWUqireyUsF0Oyl
mAMhaCaw5RwqSnpXKaxEY2pRswrYFY0EoEGuSFuESKhbh0b6AsU2eOg7lFJhJd5X
27wP/AENDPRCHDEKfB9r
=gSO5
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
