Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3FZJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:02:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45757 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3FZJCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:02:21 -0400
Date: Wed, 26 Jun 2013 12:02:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: host: xhci-plat: Enable XHCI_SPURIOUS_SUCCESS quirk
 for xhci-plat
Message-ID: <20130626090213.GQ12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MOeiELSuYwpLEKvX"
Content-Disposition: inline
In-Reply-To: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MOeiELSuYwpLEKvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 26, 2013 at 02:28:57PM +0530, George Cherian wrote:
> Synopsis xhci controllers with hci_version > 0.96 gives spurious success
> events on short packet completion. During webcam capture the
> "ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
> The same application works fine with synopsis controllers hci_version 0.9=
6.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/host/xhci-plat.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 93ad67e..e63c6d3 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -25,6 +25,16 @@ static void xhci_plat_quirks(struct device *dev, struc=
t xhci_hcd *xhci)
>  	 * dev struct in order to setup MSI
>  	 */
>  	xhci->quirks |=3D XHCI_BROKEN_MSI;
> +
> +	/*
> +	 * In some xhci controllers which follows xhci 1.0 spec gives a spurious
> +	 * success event after a short transfer. This quirk will ignore such
> +	 * spurious event. Hit this issue in synopsis xhci controllers with
> +	 * hci_version > 0.96
> +	 */
> +
> +	if (xhci->hci_version > 0x96)
> +		xhci->quirks |=3D XHCI_SPURIOUS_SUCCESS;
>  }

doesn't look like the correct way to do this. What if enabling that
quirk on hosts which don't have the quirk cause problems ?

I would suggest adding a platform_data which (in our case) dwc3 will
pass to xhci-plat. Then you can do proper revision detection of the
synopsys controller and set the quirk only on the failing hosts.

BTW, do you have the STARS number for this errata ?

--=20
balbi

--MOeiELSuYwpLEKvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyq4VAAoJEIaOsuA1yqRE1pwP/A/mF/CXYUzPy+UCLNJVq2ar
X+hR/mQXQs4ARYlyJeUqzZ0yCNdt3a3X6OHkE8dx3kr4DtdihYUPfRMG2iPEoE4p
Ak24/v0/d3lTcoVwimnyj0Bo3I9vOMveRIaSILfZhzVzXI8Yh+CNA1ag627vDYUd
G1DuSUM9Y8XCk6jKXiP6WDg7Ych29yt9eCETLGvjxwwVpdxe00T2UhXgBqKXdzUH
hxE9EK425lzvWpp1Pxz8ROb9jU3MyM/tDobiWMyFolalzrwxcdFKclOXyG9/vhmr
8v7mLyevyyUnTj+xaKUyAB4iiqEPxHQ9KaWRn9cFsFC4tVOQrdhT9RUjpRMKuYSx
14rYHlM1lweEvOKnaJb01rdTzpKU85JHk64UhAG1Pj8/G52qI/pBWYeoV0++KONT
a47ovqQowwn2weTyHP/QgoOxMd8f8kem/GUeESKRvOXoC895C4MSoyI+CcwvxaZA
VhMTbOevwnjnYnV6oY+zJswScLhCDScV2FBjEhlRr4lqfDC04RHmKwZ53GgtDjZZ
SuJR3UotK0KEgLHamw7FeLqO38rE77oIL73OlB8nnKQ0GNv3FxigjDa5NNaGpjpy
HBUFp588EfbgU8dhQXlNlbvf4yprd4gtMeZFlBAe1JJWvlyt1ynVscOg1pcCh7LG
dy7ajunnFFnMt+oT8jVC
=VYtq
-----END PGP SIGNATURE-----

--MOeiELSuYwpLEKvX--
