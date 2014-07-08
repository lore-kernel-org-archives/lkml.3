Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaGHP4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:56:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:50068 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaGHP4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:56:21 -0400
Date: Tue, 8 Jul 2014 17:56:14 +0200
From: Sebastian Reichel <sre@kernel.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140708155614.GA12945@earth.universe>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
 <20140703145617.GA23309@earth.universe>
 <20ADAB092842284E95860F279283C56422F95A3E@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C56422F95A3E@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 06:07:29AM +0000, Tc, Jenny wrote:
> > > +static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
> > > +		int temp)
> > > +{
> > > +	int i =3D 0;
> > > +	int temp_range_cnt;
> > > +
> > > +	temp_range_cnt =3D  min_t(u16, pse_mod_bprof->temp_mon_ranges,
> > > +					BATT_TEMP_NR_RNG);
> > > +	if ((temp < pse_mod_bprof->temp_low_lim) ||
> > > +		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
> > > +		return -EINVAL;
> > > +
> > > +	for (i =3D 0; i < temp_range_cnt; ++i)
> > > +		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> > > +			break;
> > > +	return i-1;
> > > +}
> >=20
> > pse_mod_bprof->temp_mon_ranges > BATT_TEMP_NR_RNG is not allowed, so I
> > suggest to print an error and return some error code.
> >=20
> min_t takes care of the upper bound. The algorithm process BATT_TEMP_NR_R=
NG
> even if the actual number of zones are greater than this.

Right, the function will not fail, but the zone information table is
truncated. I would expect at least warning about that. I think it
doesn't hurt to have a small function, which validates the zone
data as good as possible. Using incorrect temperature zones is a
safety thread and we should try our best to avoid exploding
batteries ;)

Maybe something like that:

static bool check_tempzones(struct psy_pse_chrg_prof *pse_mod_bprof)
{
    int i =3D 0;
    int last_temp =3D ;

    /* check size */
    if (BATT_TEMP_NR_RNG > pse_mod_bprof->temp_mon_ranges)
        return false;

    /* check zone order */
    for (i =3D 0; i < pse_mod_bprof->temp_mon_ranges; i++) {
        if (last_temp < pse_mod_bprof->temp_mon_range[i].temp_up_lim)
            return false;
        last_temp =3D pse_mod_bprof->temp_mon_range[i].temp_up_lim;
    }

    return true;
}

-- Sebastian

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTvBSeAAoJENju1/PIO/qacsQP/3NRSlZxI2X3DxP07ivLKUOp
WAnBnx1W8eoa1lFFOUcTAIlLUAnD7jmfJnGxyzAxM26O8AVoR6KZoLjTbjp0NkoO
/g1i+E2h6eWUO8Osl7WwqHU3081J5qxEveW3BFqFrVVPY1xw9FGPcBIXaPqxdGv1
E15m14IOUNgVvTnBttFVMr9wEXeoIFdRilodcIuxC93RwZFVpVwhzibrfq4HhKO+
ARJIBLh0QZk0OReRpFuD9AS1RyN/qkp+RybQ1fFtfBszdGWg+ote7D0TlDF8zSIu
PqxdEFblvT6S3mxR/GQ5fSDnf3bSfyTtNMlgwx5gXN7ss0QPX9tyyjhkYTiUenLw
yQVu+0dxJqd2TIPZI4XXTM0G2nFCnNgf4uDft1rSto/c2H9Zc6T7mAyi3MWtJME+
u++ZBAoaVTZ8huMM6W5myI2R64xFL9CTCP7/0d9EkuKKuO9dH4p2ZnZKauFmqxmq
HzlFe+Jpfn74L9LywPmSyn0iP+khm73/3feIx3FG5f4POWOUvwdJVSb7exdcL4//
fkHQeJAlBdxr/+eHatSOL1R9JRZ0xGaGYn6N3oTii3tAEvJXwye3u/v6L6fhGwOM
T5bzEHULMPJN2m8kyvEvCr57AMy2Ig+Qu2mNVAAfLNgz2Lwrw4FWOt9ND/cjW4Fd
jo212uclG8JsU3eGo+wS
=x703
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
