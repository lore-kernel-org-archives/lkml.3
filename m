Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaJ0Scl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:32:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:56584 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaJ0Sck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:32:40 -0400
Date: Mon, 27 Oct 2014 19:32:33 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/2] power: charger-manager: Avoid recursive thermal
 get_temp call
Message-ID: <20141027183232.GE10897@earth.universe>
References: <1412696857-14803-1-git-send-email-k.kozlowski@samsung.com>
 <1412696857-14803-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <1412696857-14803-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 05:47:37PM +0200, Krzysztof Kozlowski wrote:
> The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
> as a thermal zone if any of these conditions match:
> 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
> 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
>    the fuel gauge temperature property).
>=20
> However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
> is not set) the charger manager forwards its get_temp calls to fuel
> gauge thermal zone.
>=20
> This leads to reporting by lockdep a false positive deadlock for thermal
> zone's mutex because of nested calls to thermal_zone_get_temp(). This is
> false positive because these are different mutexes: one for charger
> manager thermal zone and second for fuel gauge thermal zone.
>=20
> Get rid of false lockdep alert and recursive call by setting
> 'no_thermal' property for this power supply class. The thermal zone for
> charger manager won't be created (user space does not use it anyway).

also pulled into next, will also be included in 3.18-rc pull request.

-- Sebastian

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTo/AAAoJENju1/PIO/qaZr8P/3HwAnw5yV1GVUOxJUtFwAvX
qRriDhVSrg6NqenMIXNYbt8lpASHoxYyp+/kidO5NYTIIXehsbBYK0kZgC3QAYT4
HwDNUMJJTmCyFqKJsSRtWtv+a4xluB424b8Fdp67YEraQwy6vUttIMuHahnWJIvR
FhnSqSkKKSCf9Pm+cJJ/mktlX+FVoNWWgxdtcFBehLO81KuNA/t8d231DJ6e+JDF
O+E8MDSsRuGqefgkbGe2QOpzEzMbD0bFbT5d/Ibnr+4yaew3JSCLh2GoJ4mUt7+h
asfPICgDFcFFrr54Jtkx9G3R7RA1YgrI3BuDMo8crdwdT2+MI8thAzFVsXiSLu5I
8TTXVMcCLuGifQE3b33EC8CyhECk/90NNxgobtdyA2L007eHyKe/3uLAtWXqwJBj
QVd/7qiI1xTA5F4Bdo8oVtVQrub8Bl0kEoPTS+TLFdYIlDmdsZKsQE3aYeLKRDAY
1/koaMVrGoDTbMTOH0xiMRa3/a3nY0IX/i5CJsOvtvv3ITj67C3K+7XT5gF7oqSH
Janq2bYf6wqMDg7bNiopUhAIgw7wPs0hgY643kmAvQMdDHfZGfk26GwEJTweYI9X
Md4YWcBK99IuO7jqbTxSVDo9Bc6JXQlX+I9btYOUyeCxX6aWg2ytXv0fKuE9AXG9
Cf4nYEX+RZbhSsNI0BJj
=GGo5
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
