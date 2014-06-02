Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaFBQMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:12:47 -0400
Received: from sauhun.de ([89.238.76.85]:46600 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbaFBQMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:12:46 -0400
Date: Mon, 2 Jun 2014 18:12:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Yao Jin <yao.jin@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: designware: No need to disable already disabled
 controller
Message-ID: <20140602161234.GG2654@katana>
References: <1400164644-3222-1-git-send-email-mika.westerberg@linux.intel.com>
 <1400164644-3222-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GdbWtwDHkcXqP16f"
Content-Disposition: inline
In-Reply-To: <1400164644-3222-2-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GdbWtwDHkcXqP16f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 05:37:21PM +0300, Mika Westerberg wrote:
> If the controller is already in desired state (enabled/disabled) there is
> no point in setting its state again.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---

Does it have a side-effect when setting then enable bit again? Otherwise
it will exit the loop immediately on the first try. Not too bad IMO
given the additional code saved.

>  drivers/i2c/busses/i2c-designware-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index b58ecf19e767..b0792675b970 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -258,6 +258,10 @@ static void __i2c_dw_enable(struct dw_i2c_dev *dev, =
bool enable)
>  {
>  	int timeout =3D 100;
> =20
> +	/* In case the controller is already in desired state */
> +	if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) =3D=3D enable)
> +		return;
> +
>  	do {
>  		dw_writel(dev, enable, DW_IC_ENABLE);
>  		if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) =3D=3D enable)
> --=20
> 2.0.0.rc2
>=20

--GdbWtwDHkcXqP16f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjKJxAAoJEBQN5MwUoCm2JwwP/jUWlMJJU92m8Xyj9gTqi0Kw
ASi+nB+ODGjOt30rI4eGxOvzrJYAHhSP4isO6ZKv73e9nbkQh032NzKitU0cXpS5
QESfr8r1gKdtNGGqHDYWCz6PC91T1crtS1PxrdHXFekrngzITC3gCUoQSblu6wBS
rHafasSKIs7FnISvzJqx25roU7oAF7bharfnhkrZkWPnuladv9AyLX+v/DCE0xuY
c5vPCSXTkGLBJlYWSGI59irVOSjCoPsuaMQrL/H9q+PCDttrhgxCEVIlesBwhosT
cZvAojYyS0X0VwWHA9lMbrZi+d3iXSW0D38IE7X/ulxpIznrJkoEhJhUdozWCSIx
WFqEOzKwWlVm+ifqNjJd23zeb3Rw2d5je4Zxf00pV0kCJSks9GeDwCqKHxb1b50X
Ihpd95PShKTjXHA4i8CkJez3CeF4d2jGP8TExjEYXDcM0S3/KrgNZPkNqNb97brs
SzZcnlDrlP8vSOdsHDfPwkCSQPjcHLTvH50mhs3nK7erIiAJNKEnaa69eC3Pgk7m
plabCXQyJ0S9j1IZwHn767yp4goLFOeb2+tRDmOLmp2ZDZM7SEbSKpPm7ENIPvzf
4Qup/ycnzzOS3/B8LWv00fLJxibmysIcORQr+HmOjH914+s80N3F8V6HINIU0Jxy
/bwxx79cbAElWVf2crj9
=FdRx
-----END PGP SIGNATURE-----

--GdbWtwDHkcXqP16f--
