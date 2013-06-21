Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423013Ab3FUOhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:37:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51889 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369Ab3FUOhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:37:50 -0400
Date: Fri, 21 Jun 2013 15:37:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130621143745.GV27646@sirena.org.uk>
References: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
 <1371818017-5215-4-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hFEw+uh9kF5V6COn"
Content-Disposition: inline
In-Reply-To: <1371818017-5215-4-git-send-email-t.figa@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/3] mfd: max8998: Add support for Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hFEw+uh9kF5V6COn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2013 at 02:33:37PM +0200, Tomasz Figa wrote:

> +	- EN32KHz AP: 32KHz clock output for application processor
> +	- EN32KHz CP: 32KHz clock output for call processor

The clocks should be supported using the clock API not the regulator
API, they shouldn't be present in the DT regulator binding.

> +	if (iodev->dev->of_node) {
> +		ret =3D max8998_pmic_dt_parse_pdata(iodev, pdata);
> +		if (ret)
> +			return ret;
> +	}
> +

Might be neater to have the check inside the function?

>  		if (IS_ERR(rdev[i])) {
>  			ret =3D PTR_ERR(rdev[i]);
> -			dev_err(max8998->dev, "regulator init failed\n");
> +			dev_err(max8998->dev, "regulator %s init failed\n",
> +							regulators[index].name);

Print the error code (the original doesn't but since you're changing
it...)?

> index 46f2301..042a873 100644
> --- a/drivers/rtc/rtc-max8998.c
> +++ b/drivers/rtc/rtc-max8998.c
> @@ -253,7 +253,7 @@ static const struct rtc_class_ops max8998_rtc_ops =3D=
 {
>  static int max8998_rtc_probe(struct platform_device *pdev)
>  {
>  	struct max8998_dev *max8998 =3D dev_get_drvdata(pdev->dev.parent);
> -	struct max8998_platform_data *pdata =3D dev_get_platdata(max8998->dev);
> +	struct max8998_platform_data *pdata =3D max8998->pdata;
>  	struct max8998_rtc_info *info;
>  	int ret;
> =20

Probably better to split out this refactoring into a separate patch.

--hFEw+uh9kF5V6COn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxGU2AAoJELSic+t+oim9dp4QAIXr+FjNooQcUHsMbTyQ3Ua4
MR8M4uqcduKhK922GLE7zoZx+ZadW5hkY9P+OLIC5OFJjmaQlVlWO6JYnA8RfjLh
73h+e0go/FFoOdenDfkFJpH+fP6p439PYY7fxdkqQ4hZ4eQhAqsAuZwuxJMN1jrX
++k08+sjukBPGAntHSHKveIMGWdZuPy3IKsMmyDnrbEeSeNXTUlN+xT3oeemFVdr
i4qq1WOyHA4x6PjaSDGkpHaSvJ+W6khAKt7FBX381pFd4Noj6AGM943LQxj3hboP
8y/QfI/zjlzu5xKVtY3gYKRpKlJrA19zLDzzf+zqk6o6m9Rv7ythA/j2mIxRjqub
cUILlw1tvQGzgloDPmMlOzdZA/H5lYDR7zFWtub1vzY6VZ6EuR40nVEjWxPVUpDP
PHHTX47D9aUcit8et4T+esXFpUOTrre+sxE66Z5aXHfA5RbjT1n8DEjfrtQLh/uv
IRBDVL+a7O7wrlRbdHcx9HS74i7pfZdCASZr9OmWvUqeoJox780pc46WEbBE30fc
PJGVi/i9EDGPBMR1TzHqZjgxugVohH02flQeCJ3MJOb/otCHCZRQwrG7ogsHMT6s
2bEoBGlwtd9S6sR/lbOY1Lv2J0OGflt8lYpkZx6aQ3nEbC/mVt80QNlM4V+V4dGy
GTKrq3SP3gUM7eeSDw6P
=IBRy
-----END PGP SIGNATURE-----

--hFEw+uh9kF5V6COn--
