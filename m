Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaE1LUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:20:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45343 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaE1LT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:19:58 -0400
Date: Wed, 28 May 2014 12:19:45 +0100
From: Mark Brown <broonie@kernel.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Message-ID: <20140528111945.GJ12304@sirena.org.uk>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com>
 <20140523174925.GH22111@sirena.org.uk>
 <5382D8A7.7010704@linux.intel.com>
 <20140526145127.GM22111@sirena.org.uk>
 <5383E0FA.5060509@linux.intel.com>
 <20140527112024.GS12304@sirena.org.uk>
 <538533EF.6080101@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7zn/zMRAdE+UkrBU"
Content-Disposition: inline
In-Reply-To: <538533EF.6080101@linux.intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7zn/zMRAdE+UkrBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 08:55:11AM +0800, Zhu, Lejun wrote:

> Oh I see. Sorry I missed your point. So you are saying "int
> intel_soc_pmic_readb(int reg)" is bad, but if I have:

> int intel_soc_pmic_readb(struct intel_soc_pmic *pmic, int reg)
> {
> 	int ret;
> 	unsigned int val;
>=20
> 	ret =3D regmap_read(pmic->regmap, reg, &val);
> 	if (!ret)
> 		ret =3D val;
>=20
> 	return ret;
> }

> And have the caller (device or core) look up and pass *pmic in, this
> will be OK?

Yes, that's the more common pattern - normally the caller will need
*pmic for some other purpose anyway so it saves an additional regmap
lookup if that's desired.

--7zn/zMRAdE+UkrBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThcZOAAoJELSic+t+oim9ArAP/0vE3WidvhXZxcV2mowMGTNp
TJuqtKjz0s2Hb2KQ1YMyb2AObQfmLwi4pFfy8ZTlOjl2L4ZYy4pQhZcJ5UL0iRQk
a2AboQcB/qdRre3yJxoGVWXeWKEIouFEEl5yFTr1wuRN35dgUrfp78unP+QyUs/8
xSQPM/Vw45VT/i5pG/4z1wG7gpzHEjYq9GjKwgQBAR7LRwqQYrCwKTlK8rzumSJR
bCVH0R09XLiEI81OcGx52xu7YyVO5Tgz+7vBm88lCU8Wuhzr+XypS3Aqy//qgbqQ
31S5+1Q27Pdh7sfErnPCkRU/pkZZXD+GrYuYC0TePFc9sYOsjcv9SgNo4UAw2BZ4
v8QkAMsmZBo/C1gClgBbecoa4ZppZCSZTQsI5CWRE/mTCC95aFYJTg2UHhsuWoPb
cXlR0aEDTmW0mTr4meQyPGJyeffrmGidh0JF4WANMPVW3FywIVLB5AlTnUuaTO3N
GxtMJGMLIt9HURIDO5L83aGaDJVSBwwGi9T2xV4FPfVwpmEXepocTQN2hfamQXpC
h+V1o6hqd8+Ci3HvP/AI7xc6AkD82tmKTyFh5UGUNzJFi50OLj/iVqTXmxuYMqoG
TIfoM1lNJADi1mQrA+Azj8IFtYQyzw9vnRw5YnuhSGs+4fZLl7wga9VkSPsgWfMW
7hb2ugcGeULRDwmSlzhy
=9ZAK
-----END PGP SIGNATURE-----

--7zn/zMRAdE+UkrBU--
