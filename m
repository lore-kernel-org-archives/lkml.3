Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbaGPRsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:48:03 -0400
Received: from sauhun.de ([89.238.76.85]:58322 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759960AbaGPRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:46:09 -0400
Date: Wed, 16 Jul 2014 19:46:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        adi-buildroot-devel@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 00/16] i2c: drop class based instantiaion for selected
 drivers
Message-ID: <20140716174604.GI2759@katana>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QDIl5R72YNOeCxaP"
Content-Disposition: inline
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QDIl5R72YNOeCxaP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 01:46:20PM +0200, Wolfram Sang wrote:
> Some drivers were flagged to remove class based instantiation soon to imp=
rove
> boot-up time. Originally, I was planning for a longer deprecation time so=
 users
> could switch over to some other kind of instantiation. However, the deman=
d for
> the speed up is high enough and class based instantiation is used rarely,=
 so
> the removal takes place now. To make up for the deprecation time, another
> warning is added to the i2c core pointing out that the behaviour has now
> changed:
>=20
> +	/* Warn that the adapter lost class based instantiation */
> +	if (adapter->class =3D=3D I2C_CLASS_DEPRECATED) {
> +		dev_dbg(&adapter->dev,
> +			"This adapter dropped support for I2C classes and "
> +			"won't auto-detect %s devices anymore. If you need it, check "
> +			"'Documentation/i2c/instantiating-devices' for alternatives.\n",
> +			driver->driver.name);
> +		return 0;
> +	}
>=20
> A branch can be found here (with two other cleanups -> driver removals):
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/deprecate=
_stuff
>=20
> I hope this meets all the needs. Please comment, ack, test...
>=20
> Thanks,
>=20
>    Wolfram
>=20
>=20
> Wolfram Sang (16):
>   i2c: add debug info when class instantiation was dropped
>   i2c: i2c-at91: Drop class based scanning to improve bootup time
>   i2c: i2c-bcm2835: Drop class based scanning to improve bootup time
>   i2c: i2c-bfin-twi: Drop class based scanning to improve bootup time
>   i2c: i2c-davinci: Drop class based scanning to improve bootup time
>   i2c: i2c-designware-platdrv: Drop class based scanning to improve
>     bootup time
>   i2c: i2c-mv64xxx: Drop class based scanning to improve bootup time
>   i2c: i2c-nomadik: Drop class based scanning to improve bootup time
>   i2c: i2c-ocores: Drop class based scanning to improve bootup time
>   i2c: i2c-omap: Drop class based scanning to improve bootup time
>   i2c: i2c-rcar: Drop class based scanning to improve bootup time
>   i2c: i2c-s3c2410: Drop class based scanning to improve bootup time
>   i2c: i2c-sirf: Drop class based scanning to improve bootup time
>   i2c: i2c-stu300: Drop class based scanning to improve bootup time
>   i2c: i2c-tegra: Drop class based scanning to improve bootup time
>   i2c: i2c-xiic: Drop class based scanning to improve bootup time
>=20
>  drivers/i2c/busses/i2c-at91.c               |  2 +-
>  drivers/i2c/busses/i2c-bcm2835.c            |  2 +-
>  drivers/i2c/busses/i2c-bfin-twi.c           |  2 +-
>  drivers/i2c/busses/i2c-davinci.c            |  2 +-
>  drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
>  drivers/i2c/busses/i2c-mv64xxx.c            |  2 +-

Applied to for-next, thanks!


--QDIl5R72YNOeCxaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxrpcAAoJEBQN5MwUoCm2WtEP/i6iS+LXxbARgxhigYAWFkUr
klsJEY41o723X7V6MWVXK5ud2s+1GWY3Z74PTHS8Y2bY79V1mDdq4Sa+FegKM3Q8
9aOD5VXJBWWyiEufSsqUsJGxxWSz81eLX5n3b4olGWclu8BYKZ73jAt9PNF7SAP4
G1i8DFZadoBxUbVW/hXk86IULb7Lmq3GOMmNIHJ1PFykI/dq7rogSo5yLccked9r
Ho3kvEWIHeumRYdDsnlUqUayysl+yTvaJRhuXN+NrfDyH5ZB2/MY/4ZK+poV/cUM
HrkhvF7Yok4udMtvpcGWaga/GKo5sLZZdz33uZutV09Iek7ce/guPsOuX4/yP+0t
gjwPpMblPPGhC95aM7rDEELYZ434nszEpHLlE7amPONcCxbjrSYu8Qkg76ZjC/N+
qaxq0l0QL6292ZBZOa366SxtlY3e8sg/YCJ4SE2Iw2/1aM60W2Gb5M3sqGkzaDZf
TQTQiKuQbM8OTxiBXT6xKOM5h1n/hX780mJvuCXLdzWC5CbsUob0GHkDOBoDpY9r
Jf2VXoJ7NYj0bUPEaXOWrn0k+BhBc8rXKaIET6m6Oi3AqhQPFO3OlCamlywOCozi
90OHHciXrVxLlvWTPbx3H/tM+swlHGlGt+oKvvDxhAUnE/zMnbfM/sDC11+7Vlko
q8c/leBJlfax/IyaZ3wv
=2yuG
-----END PGP SIGNATURE-----

--QDIl5R72YNOeCxaP--
