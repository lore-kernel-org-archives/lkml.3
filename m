Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaJOFAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:00:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37277 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaJOFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:00:30 -0400
Date: Wed, 15 Oct 2014 00:00:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Message-ID: <20141015050022.GA2378@saruman>
Reply-To: <balbi@ti.com>
References: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 14, 2014 at 01:15:05PM -0700, David Cohen wrote:
> ERRATIC_ERROR interrupt is an event that needs more attention from
> developers than currently implemented, since this indicates a serious
> stability issue. The only way to get warned about it is by selecting the
> maximum driver's verbosity.
>=20
> This patch increases a bit the error's verbosity.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/dwc3/gadget.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 3818b26bfc05..132e761d62e4 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
>  		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
>  		break;
>  	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
> -		dev_vdbg(dwc->dev, "Erratic Error\n");
> +		WARN_ON_ONCE(1);
> +		dev_dbg(dwc->dev, "Erratic Error\n");

how about:
		WARN_ONCE(true, "Erratic Error\n");

instead ?

>  		break;
>  	case DWC3_DEVICE_EVENT_CMD_CMPL:
>  		dev_vdbg(dwc->dev, "Command Complete\n");
> --=20
> 2.1.0
>=20

--=20
balbi

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPf9mAAoJEIaOsuA1yqREXnoQAIpk4MmlP90eT9otywy9lfoc
PSOadRi486q8u3P/NGeFeRmsEXUu07FtcybewGVGMfK5AHPJuw9nc473o2zbX1Gx
vdCWVpTDzJZEsuCylxea7zS2nSiNuocoWV0EaH8Xauej9YQX8DhjTJPyJxtmJSX9
IabdjIS0KDtxlHAbNIfGFJazlLjeKBthe3OsjWVmQZ0wWqFRQU8n3F40qD4YR2sw
sqEDtKqYQphOI+XUGVDsOztgsXwQeW6ByVjASSjtQ5+8jBePsZXgcQZjcpS5qLqi
i2Qgrkj3qduAqYubPWXBN7zRuvxaNl7S04HzfSI9xVIaJC2kTbCdkL26WeMiv1vf
M1BiBWZbtNtfquFhAlf4GyjukrLEC4du0/1noGxHBcouoQwumj6ePQFrVV1Q5eqS
r4PElb525wdAGhBGnxsSHNQSuyR09uPLijhM0apg4ea4Bu+fA3SGrHX3e37e5cjz
1dnQAsNowErpdeQSrF60M07hcZt2wfu3fVv7LtiNRgFgzj9l7il05p9y3xtIQ9qj
APIAytmzDa2jGNCUmdewTfwi6sYTjm8iA+imGo0oqr3+lhoMYLcBGO6ijVFiADyx
BsGkAe2vLh653bA6dE8beGrD12RCB1Faopu4xemFsqamEWkfaQOJQfj4FrQJ52+7
RflBnP3sNjyAQ6F6LjHl
=5a3h
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
