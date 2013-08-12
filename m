Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3HLSIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:08:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3HLSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:08:20 -0400
Date: Mon, 12 Aug 2013 13:08:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Philippe De Swert <philippe.deswert@jollamobile.com>
CC: <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget/composite : Avoid crash with bad gadget
 drivers
Message-ID: <20130812180804.GE27954@radagast>
Reply-To: <balbi@ti.com>
References: <1376072588-2881-1-git-send-email-philippe.deswert@jollamobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7CZp05NP8/gJM8Cl"
Content-Disposition: inline
In-Reply-To: <1376072588-2881-1-git-send-email-philippe.deswert@jollamobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7CZp05NP8/gJM8Cl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2013 at 09:23:08PM +0300, Philippe De Swert wrote:
> Some bad gadget drivers do not check the return status of usb_add_config.

fix the gadget driver

> Thus they get a not correctly initialized config and when this gadget gets
> deactivated the whole kernel crashes. Since on initialization failure cdev
> is set to NULL it can be used to detect this problem situation. It can be
> argued that the faulty gadget driver should be fixed, but imho it is bett=
er
> to avoid crashing the kernel and letting the gadget developer know he/she
> is making a mistake. And have the developer of said gadget driver then fix
> the problem of course.
>=20
> Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
> ---
>  drivers/usb/gadget/composite.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composit=
e.c
> index 55f4df6..e019bb5 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -848,12 +848,18 @@ void usb_remove_config(struct usb_composite_dev *cd=
ev,
>  {
>  	unsigned long flags;
> =20
> +	if (config->cdev =3D=3D NULL) {
> +		pr_warn("Calling usb_remove_config without a matching usb_add_config!\=
n");
> +		goto end;
> +	}

I would take a WARN() only, but let the crash happen and fix the gadget
driver.

--=20
balbi

--7CZp05NP8/gJM8Cl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCSSEAAoJEIaOsuA1yqREeRwP/jmZEiaiaUzL8jIkr140kIdq
asMvJcsL2eDZwDhEQ1NcnrbIYydzE9CQnpvUBgMUe+1FafY9JTHlgKrXpedy3bnU
QMTAEH05ZYKYYPCEeTUbQX4JzqtqerTxTzaJgoHbFMEVBp8lHFGpqBVdmTnhOc1f
NC6Yn3jPuYr+1M8tgz7R4jOGancPjvkv5dCngxtV9F7Re2pPDdzgstJWmohWxHfv
i32GOp1rXSN+F5fLisq/HLJc2dgJI/dqaHFWt3zAFMgCrciNHkqoLPmz8ypBNxTL
csOpRphOreWqu3OLSSbASQMKecWQZ/OeqEYX0YihIbbIYdnc8ZUDvzvLoIRjI/I1
sRhOkFTxhTJW8/iYae63/gpXSV+3Y6+adfJEk+UL8THPX8XWqHCGuPNYILSVZXDD
rmaFDfiIDq89Y1EWQIc3UY52UFC6SfitU0Y6FTQIYzEw406SF9ly+l2tarXpcQ3A
YtyZjMg0lTgxUzmvI+U/qMc/IaiYRvXyaLEhYktCYKH9DjruSZWc/AR0I4ICXjSp
4GQL2TNwKITqiT2vbZWZjKsdD1YNZW3Xw0z9Bnkp8sMWWWbMgIh7pFvDhxTfl3GU
N4sONqGXyem2d3aaARnlP8eqclSKihgewoM8E6/q7Zruhw/EsPVXGkSIHJLsHyMa
XJyrNX696/a3zLJ4FrgD
=a9UF
-----END PGP SIGNATURE-----

--7CZp05NP8/gJM8Cl--
