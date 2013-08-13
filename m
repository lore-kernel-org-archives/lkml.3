Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3HMTs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:48:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54825 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3HMTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:48:27 -0400
Date: Tue, 13 Aug 2013 14:48:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (usb-gadget tree related)
Message-ID: <20130813194803.GA11075@radagast>
Reply-To: <balbi@ti.com>
References: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 13, 2013 at 06:17:19PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc allyescon=
fig)
> failed like this:
>=20
> drivers/usb/phy/phy-am335x-control.c: In function 'am335x_control_usb_pro=
be':
> drivers/usb/phy/phy-am335x-control.c:117:2: error: implicit declaration o=
f function 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
>   if (IS_ERR(ctrl_usb->phy_reg))
>   ^
> drivers/usb/phy/phy-am335x-control.c:118:3: error: implicit declaration o=
f function 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
>    return PTR_ERR(ctrl_usb->phy_reg);
>    ^
>=20
> Caused by commit 3bb869c8b3f1 ("usb: phy: Add AM335x PHY driver") from
> the usb-gadget tree.  Forgot to include linux/err.h.
>=20
> I have reverted that commit for today.

damn, I didn't catch that. Sebastian, can you send a patch ?

--=20
balbi

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCo1yAAoJEIaOsuA1yqREQfEP+wS2HyvwAyY1/Hn3jF660aH4
f0Q6n8vM3OIJqr8zICuRJO697nOtpp8GPvb+iePiHDcl4pO48bYC1TnuEyumDvAh
ZCaJNfnSp94G9FSMPgSVRsz3qCcohn4dUCgERHwayolOO5Vec6pGsCwnTfIvLhPd
aka33Hbi2h872xi7DCRl/3USgKTNSeBDdzq6LFa4GRkmSmHnb39mrddw/nZ882Yk
FfDxQDnswc6FmpAGPz9a/IsEmqkKGmcWbQvlRotcacmlKUD1982BonZbk8QUc9ja
1MEKmoiN7L0Cajvat9fMX6TbIV2NZwy9UonW3/zqIInttgBtW4dEbSqaVk7AOK+V
WeU0wlSdD0Xix4Koqo1s3Z2ri1c8KcNnU7Xa9evD9f4KlDCXvH3d2HrAjy8MTmoW
FHBLSobfwJgRvnBE17Tn7OuWVOHCbqZ/mmz4ws8OqUaRsCkmr1/NviY9IxTxoyOc
Ukq7HDSqzRzYGtnGzcJGCCf1q+m0N/pd/x8N4ZWbjOv0RR+eICw99bg1hdIDIT51
krvSkjFAMZ6f9+1IbriVONgaeARfIjP4ia/iSfiAPSLNBq+5R3MZYJIZsyMwTbf3
CTN7CfkwfqvJOXMBu7U9b338H32s7iOAR1E0YpfR0CcWmwKt/hYjVxEaWj5lPdpz
/stK34ZANCzIrg/mzWpD
=aCVv
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
