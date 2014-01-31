Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaAaV1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:27:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38292 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaAaV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:27:49 -0500
Date: Fri, 31 Jan 2014 15:26:23 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "xinhui.pan" <xinhuiX.pan@intel.com>, "bo.he" <bo.he@intel.com>,
        Felibe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2] gpio-intel-mid: fix the incorrect return of idle
 callback
Message-ID: <20140131212623.GA2502@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140131205007.GB26770@psi-dev26.jf.intel.com>
 <1391202481-19533-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1391202481-19533-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 01:08:01PM -0800, David Cohen wrote:
> From: "xinhui.pan" <xinhuiX.pan@intel.com>
>=20
> intel_gpio_runtime_idle should return correct error code if it do fail.
> make it more correct even though -EBUSY is the most possible return value.
>=20
> Signed-off-by: bo.he <bo.he@intel.com>
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Cc: Felibe Balbi <balbi@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/gpio/gpio-intel-mid.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
> index 41218e93b9fe..55688d0548e9 100644
> --- a/drivers/gpio/gpio-intel-mid.c
> +++ b/drivers/gpio/gpio-intel-mid.c
> @@ -369,8 +369,8 @@ static const struct irq_domain_ops intel_gpio_irq_ops=
 =3D {
> =20
>  static int intel_gpio_runtime_idle(struct device *dev)
>  {
> -	pm_schedule_suspend(dev, 500);
> -	return -EBUSY;
> +	int err =3D pm_schedule_suspend(dev, 500);
> +	return err ?: -EBUSY;
>  }
> =20
>  static const struct dev_pm_ops intel_gpio_pm_ops =3D {
> --=20
> 1.8.4.2
>=20

--=20
balbi

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS7BT+AAoJEIaOsuA1yqREvwgP/j4N0kYDn8cbcPNewczgZ+/x
P95VrwlKLUpHDed3W/bqt75nOeTa7wAfN+GfZe3N06WinNFCqFzm0FIO+LGqrsM8
xpsajbFXD60bHb+2w5splsGepR1rxjZcGFhB6FXDHlUlveZcI3YM17QCqXv+aSCa
xQKS8eECBLXoSr6iVSapyGdRMiGQoyRNWSJmoxLO8Yme7YX5apmaOFmeGm3p9N2j
z6DjEXhNMimPXq7aK2OREBo24aZU4Mu0PrHSOKmkorDyR0BhUvdmheO2AX0SkHhi
oJgcBy5bapWvsbg85HfWoVUXGiGkDw/3s7NM0r97BmyUgulTqnXGl+PpnRzP7Cym
qCZO6JlHJtK6apXZVStapqa67HdRNu2/R+Wbd+zAMlrWoWZD+sCBSaKqL9pd83i4
Umia2r84eFXmXyWcuelazv9XHXxiTgOGPF+4WclGRNzbMXlm9EU+Di0Vvt0kIAaU
WsE4Kr9Dxv94S1dypKtNEXCtl7iOyQVma10wbB9tSaATSqbL3yWHLHmYiG9QJQey
N4lH6of3JywVnNlTji4AM7V2Jc7M8UzB/SuNuU3O/uOq1saCVIytofwF+NHG3dXS
5hr41SlLkAzxkS+uo2FKGAb5JnVWAS3RNbBlLaYbayPmJx6QjL1FBXNYjPXf7hEz
v70QjzIT8hTngqnpyS2J
=I6W4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
