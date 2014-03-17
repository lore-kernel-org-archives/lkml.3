Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaCQLPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:15:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57202 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932754AbaCQLPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:15:06 -0400
Date: Mon, 17 Mar 2014 12:12:45 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/2] irqchip: sun4i: simplify sun4i_irq_ack
Message-ID: <20140317111245.GH27873@lukather>
References: <1394895894-8891-1-git-send-email-hdegoede@redhat.com>
 <1394895894-8891-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
In-Reply-To: <1394895894-8891-3-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 15, 2014 at 04:04:54PM +0100, Hans de Goede wrote:
> Now that we only ack irq 0 the code can be simplified a lot.
>=20
> Also switch from read / modify / write to a simple write clear:
> 1) This is what the android code does (it has a hack for acking irq 0
>   in its unmask code doing this)
> 2) read / modify / write simply does not make sense for an irq status
>   register like this, if the other bits are writeable (and the data sheet=
 says
>   they are not) they should be write 1 to clear, since otherwise a read /
>   modify / write can race with a device raising an interrupt and then cle=
ar
>   the pending bit unintentionally
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTJtitAAoJEBx+YmzsjxAg3mcP/jo/WWcPP92yJ7zpc4Hoylil
Yq0sZP3W/d9OHoLx/xpERuTmw3kVo7nwCqWKMIEtOIEn/3EVwtrW5npa8OMzdVvg
sAkPWJvwnP8iEtJX+AWBXRGYsrUyoVN7edGXQLtB2FKE9/hPKdw+H30RfpTrCJWZ
9coFyAVkCh3C0WAspykm5zAxhCobiDV/BWXdt5WinEVTFsgdMqsspoxK3y5U0uco
3lIkgoqB7xLNXmZowMSbqR71ZJK2YSyg1u8G14ufNmIojOZPpbkmgXWs90+h5Q0a
lELhNMleGOU3q2AQYy1W3j3RQ4ONwoYpHlvrtjdI3PuSVFru59xcqPMDjF9laOIV
5D22cRCq0sjzT22dtSdUE2eYfy/ZGrY84BplMntnRMcUrCGmDnUxJV6NQR/ztFPg
wWNqzgLlSvldmChFXp+Q70wCPCkw+F98pcahsKmx273uwLpeS+KoxJJ+6xsY9aEj
5RBaWZWaiv5bBxRgvhWIhFX1JySp8obaIhy0qCKLLwtNx/2b6cTClQXiqYMYWUao
WHdFF+wB7mOrvkeed07PPXHgbb1FPZFUO8Cmbi1TIILvVUCuWi1ec3jzOmnS98vL
3I292RbHtBRvK0aH32daM8Qi6228HlW7BxqjUcpGLdI1sR/zrX26NEgdqbUHmYAd
ZFFF/F3tGR5Wd1OMp0Q9
=WWSa
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
