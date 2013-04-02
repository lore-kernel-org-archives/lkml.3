Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab3DBHRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:17:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47310 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3DBHRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:17:30 -0400
Date: Tue, 2 Apr 2013 18:17:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: greg@kroah.com, arnd@arndb.de, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cs5535-mfgpt: Add another reset method
Message-Id: <20130402181728.1c3f92fc8727a39e1145c688@canb.auug.org.au>
In-Reply-To: <1364885197-17212-1-git-send-email-richard@nod.at>
References: <20130402172950.1fd8d6653a4c79b319945212@canb.auug.org.au>
	<1364885197-17212-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_18_17_28_+1100_eiU.wpd+hvXLL/bn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_18_17_28_+1100_eiU.wpd+hvXLL/bn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Tue,  2 Apr 2013 08:46:37 +0200 Richard Weinberger <richard@nod.at> wrot=
e:
>
> The CS5535/CS5536 MFGPT has no support to reset the device.
> The current method uses an undocumented bit but does not work on all
> devices. At least on my ALIX board it completely freezes the board.
>=20
> This new method tries to soft reset all timers by unconfiguring them.
> But this does not clear the RO setup register and therefore it has to
> be ignored while probing.
>=20
> Resetting the timers is not only needed on broken BIOSes also when
> kexec is used. Otherwise the new kernel will find preconfigured timers
> and odd things will happen.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/misc/cs5535-mfgpt.c | 41 +++++++++++++++++++++++++++++++++++++--=
--
>  1 file changed, 37 insertions(+), 4 deletions(-)

Greg will probably want an incremental fix patch as he does not rewrite
his trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_18_17_28_+1100_eiU.wpd+hvXLL/bn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWoYIAAoJEECxmPOUX5FErHcP/1vmVLA88ffCCUSg60M5nNWA
2dBtr8JBQeWwt6h8UFno686JMxc7qLj4mVbVWHWuSJgTetOPo13kcSVQU1JUZ//F
eguxWYcM9+X9AIAjJTkRtl2su9OrfArZr+R7WpU14hRTw7l7QeoYYkfghMi7QJZH
Z3kLG4NWJMw41S/VsLvdr1DHCqPoW5waOFVqJ8LwdVLbmNXKHofvKlMe1r1/zBiH
gYe1jlY2oMsy20X0Oxr49mkb0q8QGZWDiv7xkN0O0oWZTT84r1HwYeCBT1Ccb3Li
EXzgZMURiXzC1NpJ96385L9B4caVBscI3Vr5ftburgf60yEAC+eIIAwB6GqO1nZH
wZ0x/8lvtepNLnXFE6JcCuZvpJfD8oq5VTQPI+oFiTqb2XqrN4XGFcK/5epU0kTi
6Q2hvEwD/btVp7pHJlpW+OFQdRbHsnkH/k2+Y0QyoE1RMuAVH33kCTusge+d1Yrs
MebR2W6dCjExTuSCpo+j4lkpSUauueJFX1r69t5AHWyRIIFFZ2iCtlj61pz33cto
CZA8eX1cyk0qqPCvFGoCuZYnCkzTw7+P1H8e+pNTfnEdenJ95M6swKSyFDufKgZR
yaq4k6rPRVAjnNKhfuzCnV5QGgWtmtRn7ewKo1VTuZ6ZjxcMYdteYoi/luUJnTzm
8JYKocxHXgF1yLORYPuv
=Pca0
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_18_17_28_+1100_eiU.wpd+hvXLL/bn--
