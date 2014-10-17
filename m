Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaJQPAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:00:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57854 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaJQO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:59:58 -0400
Date: Fri, 17 Oct 2014 09:59:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Message-ID: <20141017145942.GL26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YIleam+9adpUeYf+"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-17-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YIleam+9adpUeYf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simulation
> board.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 7 ++++++-
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 3ccfe41..4a98696 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
>  		reg |=3D DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> =20
> +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)

should be:

	if (!dwc->suspend_usb3_phy_quirk)

> +		reg |=3D DWC3_GUSB3PIPECTL_SUSPHY;

IIRC, databook asks us to set that bit anyway, so the quirk is disabling
that bit. Am I missing something ? Paul ?

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 146eb2f..71401a3 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -157,7 +157,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			| DWC3_QUIRK_DEPOCHANGE
>  			| DWC3_QUIRK_LFPSFILT
>  			| DWC3_QUIRK_RX_DETOPOLL
> -			| DWC3_QUIRK_TX_DEEPH;
> +			| DWC3_QUIRK_TX_DEEPH
> +			| DWC3_QUIRK_SUSPHY;

last patch

--=20
balbi

--YIleam+9adpUeYf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS7eAAoJEIaOsuA1yqREDxAP/3bP1YOorM6RVqpBx7ZEA62O
iGV2bXRYyULHEEX0VG/Y/CtXPeVoUz+/mdD9Vwf8LUv+kj0GfuH6cRgiCKPhIZco
SGr8yBFnm2OzWOnMSEnopqnBqNw5mS7Lk8hf97C5s/hAhW/JVd0oobyrlbAGgt+V
qmAcAYCv88bJLM2jCpNk9BQX44tRXB8aGqqsGxX4ROlKBmoH6LP6nHhxA9XToOPu
2lh97qBjXr+II+nldEi5v0KBRQCBfkTusImVKY7gO/BEToph938Nz+B/aLSkte7d
uxChDTBRdpb2e6EWD44zSlHtaUaUswOZJ1bGBBz3NlQQO/3IzWMDwF6KY7D8ZIg5
lo1ZmmAMnp1cw33ad7xym8fr4pYCbiCftaEsFPIfG6GYoGD8jQGAajwYcUgYEAmo
aArbiRYD1MRgnYZGECl3zq4avm3Y4GYUuTgAPC/sgw/sfuKmvgx09MQELUhl+B7+
2lFJIJzGdQvfwubATk7WlkNm7dPVJrThMEaQdNnfex5G0CDcymZCeoCj9Sr82c/6
KiUewj7aV55nI60Ls7id/qb3E+UdYdiI4NU423wcXVSL//+0E4ZmA6P+8Rl4uZ0e
UzC6iPCIdI9zud8ptYNNBAKnILVOXa0cc/D1WiZBEnqyTNsa2nS4vZuf8R06BMVo
v/Gx4AB4JqJpLWnADspv
=LGaU
-----END PGP SIGNATURE-----

--YIleam+9adpUeYf+--
