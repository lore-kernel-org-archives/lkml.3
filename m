Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3J3Rf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:35:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50742 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3J3RfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:35:25 -0400
Date: Wed, 30 Oct 2013 12:35:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stern@rowland.harvard.edu>,
        <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 3/3] usb: dwc3: add quirk
 USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget driver
Message-ID: <20131030173553.GP12193@gimli>
Reply-To: <balbi@ti.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
 <1383152778-30739-4-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJEqbsikIZBgizPR"
Content-Disposition: inline
In-Reply-To: <1383152778-30739-4-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UJEqbsikIZBgizPR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2013 at 10:06:18AM -0700, David Cohen wrote:
> DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
> This patch adds necessary quirk for it.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/dwc3/gadget.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 5452c0f..528c7d7 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2600,6 +2600,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>  	dwc->gadget.name		=3D "dwc3-gadget";
> =20
>  	/*
> +	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
> +	 * on ep out.
> +	 */
> +	dwc->gadget.quirk_ep_out_aligned_size =3D 1;

just to make it look cooler and neater, could you set to 'true' instead
:-)

--=20
balbi

--UJEqbsikIZBgizPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJScUN4AAoJEIaOsuA1yqRE5owP/0aawOmkL/V4b7H4yuAuqZPh
uv5ogDDbypX8UhXfvX48oTXxxHLy5Xoo4sJYqb30pREHFmszErjbAdmSRGkji/Lv
AEs6R8JteaIb1O9FjOqHvI3rVb51OPjIzkNJsGcHv4jpMd+wPClxtAGHEi7Aa/UT
Ecwl8RXXVctHLMJH8mfFJp0qv17ukb4D79rIjfZIlbLc+/zK2Zd50bY6pEaZmSTK
g/3t5J8gUEyLa42xDqsUc4Ozq4nWF1QxqlPLskqfMEtx9WJvXbHeBmlrk0CZ2XwG
gPaWrmgqyc6d0MNpNlww4ZUYtaRFKmkrGvYWcnqz5631MUz8GabY8cU8YBMrUGQw
n9nKxQ12Hm/CS1e4yNgBc5VbSn8BXQ8xlXM13Rnj+EY49grrLALLavOTHfMANr4Q
95/HUCB0GAbBt2IK40GCPMEtTefH5JH087VZgYg/60avZaPZP7E2nG65JoZSo+VZ
bWIJzyCwaybJmp0twrUOB7E7KM0npYOXRGhvcvMinK/Ducy6IpY4AEJW6gIO2vyL
DFvbJxu/wrJnnncM84Htl2kcry6PHBjRH+9zXNVoaFrPh9ok+YYOoFOewAAOfZxe
hZkhLnkifwQiXJKYlOnNB7TCr9MtL3FmiaKQNbAd92O0bkn/hAo7pxSNAglt6/kp
dIxf35u8dkajDocoem2w
=55EW
-----END PGP SIGNATURE-----

--UJEqbsikIZBgizPR--
