Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab3JAVdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:33:18 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:32808 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JAVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:33:14 -0400
Date: Tue, 1 Oct 2013 23:31:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 09/10] pwm-backlight: Use an optional power supply
Message-ID: <20131001213120.GG9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-10-git-send-email-treding@nvidia.com>
 <524B17ED.1080806@wwwdotorg.org>
 <20131001205310.GD9201@ulmo.nvidia.com>
 <524B37BF.2090300@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
Content-Disposition: inline
In-Reply-To: <524B37BF.2090300@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 02:59:43PM -0600, Stephen Warren wrote:
> On 10/01/2013 02:53 PM, Thierry Reding wrote:
> > On Tue, Oct 01, 2013 at 12:43:57PM -0600, Stephen Warren wrote:
> >> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> >>> Many backlights require a power supply to work properly. This
> >>> commit uses a power-supply regulator, if available, to power up
> >>> and power down the panel.
> >>=20
> >> I think that all backlights require a power supply, albeit the
> >> supply may not be SW-controllable. Hence, shouldn't the regulator
> >> be mandatory in the binding, yet the driver be defensively coded
> >> such that if one isn't specified, the driver continues to work?
> >=20
> > That has already changed in my local version of this patch.
> >=20
> >>> diff --git a/drivers/video/backlight/pwm_bl.c
> >>> b/drivers/video/backlight/pwm_bl.c
> >>=20
> >>> @@ -253,6 +264,16 @@ static int pwm_backlight_probe(struct
> >>> platform_device *pdev) } }
> >>>=20
> >>> +	pb->power_supply =3D devm_regulator_get_optional(&pdev->dev,
> >>> "power");
> >>=20
> >> ... so I think that should be devm_regulator_get(), since the
> >> regulator isn't really optional.
> >>=20
> >>> +	if (IS_ERR(pb->power_supply)) { +		if
> >>> (PTR_ERR(pb->power_supply) !=3D -ENODEV) { +			ret =3D
> >>> PTR_ERR(pb->power_supply); +			goto err_gpio; +		} + +
> >>> pb->power_supply =3D NULL;
> >>=20
> >> If devm_regulator_get_optional() returns an error value or a
> >> valid value, then I don't think that this driver should transmute
> >> error values into NULL; NULL might be a perfectly valid regulator
> >> value. Related, I think the if (pb->power_supply) tests should be
> >> replaced with if (!IS_ERR(pb->power_supply)) instead.
> >=20
> > All of that is already done in my local tree. This actually turns
> > out to work rather smoothly with the new support for optional
> > regulators. The regulator core will give you a dummy regulator
> > (assuming it's there physically but hasn't been wired up in
> > software) that's always on, so the driver doesn't even have to
> > special case it anymore.
>=20
> OK, hopefully it (the regulator core) complains about the missing DT
> property though; I assume you're using regulator_get() not
> regulator_get_optional(), since the supply really is not optional.

It doesn't always. There's a pr_warn() in _regulator_get(), but that's
only for non-DT (since for DT, has_full_constraints is set to true in
regulator_init_complete()). Actually that would mean that the regulator
core will complain as long as init isn't complete. But since, like many
other drivers, pwm-backlight could use deferred probing it's likely to
end up being probed after init.

Cc'ing Mark Brown.

Thierry

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSz8tAAoJEN0jrNd/PrOhv0gP/ieeNUf9Ps2XqYD1G3O8YB97
3KPaGRxbrlpvDzSkanaJ3kxrSx7ZLjRHGSFKiUF2LzKV3hMh3zi2j2RPOAGWeyIc
dhERNIaNdaySD4uEiM3jtQSVnOXF9Cg8CeQz9vgayDXtB9GIEhSS95d4AuB0odWT
EZ6cAXeoN7/sNNo8/POw/E3uS3X/vUGmcr1lLsFRVS8onmlCW2gvLiFn7nDpb+mE
OCvURhEmzjcq+pyVD81qvtlWxj/D7vnvt4mexSqPVh3lDVCtX40rYC4l7hyVio2g
VZRfhaHggWAWwHqChWgg7dY47dMO6xsL1giRCZ4BBLcLc0DlXn+vgMZjAzdDgqFC
t3kkuXz576fHRzGaegM6WHJzMHB7oJ28+qki21ITxKqiZ2UYY1vHf2mR15DF++Cl
jia5Zb2VjNcYMKoiHFePpzxNMKexJLhgIm+37ZpN9kN0KAuntr4bazHAe2g9RIt7
AJQr+Rw+XGWFb04HCLml9vk/EzHgPrs9HyNwpIVO8tyj7r9A7UGmq/BGTM+ZuWLt
pDcah1I33FMqyL/UvLvngy02539Nwla6y9flbUW/5amnvHHLlJwy1n33v3mW+IGB
is2YdRngeXgCo4719YKAGuw4bWRoO7dzqc4e7MdOJ/bk1IMDv8O0Y1g3FyZyPIcT
TjR4ebBaWU1ca2mvF4li
=lgk1
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
