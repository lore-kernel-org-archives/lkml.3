Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaHTMgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:36:37 -0400
Received: from sauhun.de ([89.238.76.85]:46687 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbaHTMgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:36:35 -0400
Date: Wed, 20 Aug 2014 07:36:18 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "skuribay@pobox.com" <skuribay@pobox.com>,
        "Romain.Baeriswyl@abilis.com" <Romain.Baeriswyl@abilis.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
Message-ID: <20140820123617.GB1373@katana>
References: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
 <20140820092257.GA21174@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20140820092257.GA21174@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +
> > +		ret =3D of_property_read_u32(pdev->dev.of_node,
> > +					   "clock-frequency", &bus_rate);
> > +		if (!ret && (bus_rate <=3D 100000))
> > +			speed =3D DW_IC_CON_SPEED_STD;
>=20
> This looks a bit odd.
>=20
> If the device only supports two particular speeds why do we accept any
> other speed in the clock-frequency property?

"clock-frequency" is the default binding for specifying i2c bus speeds
today. Some controllers can be programmed to do various speeds, some can
only do a set of fixed values.

> Surely we should at least warn that something was off?

Yes, I was going to say the same until Romain's old patch showed up
which does that.

Thanks,

   Wolfram


--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9JZBAAoJEBQN5MwUoCm22TsQAISfSofiMFAxoAXGsj+R5SPI
3NPq6TSgjwv/VrrB5PjiSE+qt3qbcaHLxAA1UU33mMA5Zj9QT+1LCFZ0v3Kv6TBl
XIcUp7JVIQJ343V/XgLiYKPV99uRCM+BulRE5zurF+p2QRjOcV66rUAjdqCYmASW
ItRNxxEIcvrM4vBGzhWHRDe4iPl4D6J2QNxZaUE9gmdkbUIiTYF3vasf/5+eBaNx
3YodLSng+HSirXkVKNAi5vCYvaNu3Rc6dTsOHLlI5Bn0xtkiTVI8zvQ49tR+3uJQ
Ad8VBZuPhzyaALwdqiqM+kDJQW3uYoQtFeQsZJVEZz9SwX/Oo8xRKdB+zP4Pgu67
HQKo8HmwzazlnfNfQs4LxsiR12RvnmGIlmS+3S3l55dK0J1Jex1qHZH23YT5Cseo
rO9Jc356lsZK/E2gCgAigw9CuSvuHgg1vgtqMjTBj+64LfphnWFrsUzlrAsza+35
KfdkROGypxkCMXtjHrOsCWMZ2XY6Of/Qxa76iofV+7bTc5SD5MT56d9o1CJiSkCB
QrDqDcDwaq0alzJWwNLIHe/OLJolSZi2jyNkYqhH1Xkf+K8JplmkxQe3bHBj++DU
YS3hfPAe3+XZ6sNrIJaC8vQWCMNkc0rOTztJNLszVIBPoyVCqom0+VqXt4nY39D7
Z8LLOaVtvFzCoWdSiJe3
=iqcS
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
