Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbbAWOTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:19:16 -0500
Received: from sauhun.de ([89.238.76.85]:45204 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbbAWOTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:19:14 -0500
Date: Fri, 23 Jan 2015 15:18:53 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V4 2/2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20150123141853.GA9592@katana>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1421313137-1613-3-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1421313137-1613-3-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Mostly good, except one thing:

> +config I2C_DESIGNWARE_BAYTRAIL
> +	bool "Intel Baytrail I2C semaphore support"
> +	depends on I2C_DESIGNWARE_PLATFORM
> +	select IOSF_MBI

This needs some dependency on something Baytrail specific. Otherwise, it
causes lots of build errors:

With ARM allnoconfig, I can select this option but there are no headers
for iosf.

With x86_64_defconfig and disabled ACPI, I can select this option but it
fails over "implicit declaration of function =E2=80=98acpi_evaluate_integer=
=E2=80=99".

An incremental patch will do for me, the rest looks good.


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwlhNAAoJEBQN5MwUoCm2rkUP/iYlfnu/9Kxz6dGnXV+BJCXC
DTs/nJfuL07/Tpw7Dtgk0QWfEVrdqZFazDt2rCMpXNKTj+BI8DxrXmKRvf1Jk2NT
oQoexr8Ua32pbjEk3ab0Mzt0tOiny4ePhVJRHGXneOUsj4hPLiNQjzd7cJQn0iRu
dwZZjtB3a3da0e1P77cWIkSPn7F794bgALFShhg8BodPNatLkTtYMMEEDQEaO4Lo
aClDzF1VTii+Y9TkDiRMb3Cn3zgA+QszGOvpRO4A8dd5RtAKbYnMM7fuDJPCJ1wn
a7kvt6coE5n1nTNzspaIcRAVz48uvpG8nMwmn2Ul64trj4hU6BnCoOYtMavaHx0O
J7yPk6S8HjV2c+uwiO6ciGGi8HbYsZxTgJFquQmZhzi0itWGsFhD155vxFJwtgc8
QpsffIgVhTO3yfCTP958pJVZPjJvO06LtieAyf3KVSsaKk/tOfL0jUa4zJ1sv5rq
e9IrRdn+TgsMeC/hzPC8QzJpQebRtOiozeukSLfAUPsQNkgk/MZ7lIdZi9I4l/65
4M3UUSowGNoLCUhaSmMzQ0MbHMwXcm3LrOrgJTUX5mLqSNlOdtZ+W9I1psMsE422
jIx0CyFFJLn0S3o6IcwEsrcU04zHTP21tQdINNESJfcGn8I9URAKzQvZVcZFuzQF
Gys86cNje2tf0RBHgEhR
=hydN
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
