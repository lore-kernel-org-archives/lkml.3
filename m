Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbbASOxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:53:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbASOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:53:00 -0500
Date: Mon, 19 Jan 2015 08:51:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v2 4/5] xhci: Platform: Set Synopsis device disconnection
 quirk based on platform data
Message-ID: <20150119145147.GG20386@saruman>
Reply-To: <balbi@ti.com>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1421654209-6486-5-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <1421654209-6486-5-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 03:56:48PM +0800, Sneeker Yeh wrote:
> If an xhci platform has Synopsis device disconnection errata then enable
> XHCI_DISCONNECT_QUIRK quirk flag.
>=20
> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> ---
>  drivers/usb/host/xhci-plat.c     |    3 +++
>  include/linux/usb/xhci_pdriver.h |    4 ++++
>  2 files changed, 7 insertions(+)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 08d402b..40beb95 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -147,6 +147,9 @@ static int xhci_plat_probe(struct platform_device *pd=
ev)
>  	if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
>  			(pdata && pdata->usb3_lpm_capable))
>  		xhci->quirks |=3D XHCI_LPM_SUPPORT;
> +
> +	if (pdata && pdata->delay_portcsc_clear)
> +		xhci->quirks |=3D XHCI_DISCONNECT_QUIRK;
>  	/*
>  	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
>  	 * is called by usb_add_hcd().
> diff --git a/include/linux/usb/xhci_pdriver.h b/include/linux/usb/xhci_pd=
river.h
> index 376654b..a37a3a5 100644
> --- a/include/linux/usb/xhci_pdriver.h
> +++ b/include/linux/usb/xhci_pdriver.h
> @@ -18,10 +18,14 @@
>   *
>   * @usb3_lpm_capable:	determines if this xhci platform supports USB3
>   *			LPM capability
> + * @delay_portcsc_clear:	determines if Synopsis USB3 core has errata in
> + *				"DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1" hardware
> + *				configuration.
>   *
>   */
>  struct usb_xhci_pdata {
>  	unsigned	usb3_lpm_capable:1;
> +	unsigned	delay_portcsc_clear:1;

previous patch won't build before this is applied. That's a problem.
Please shuffle things around so that each and every patch builds and
works on its own.

We cannot break bisectability ;-)

--=20
balbi

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvRoDAAoJEIaOsuA1yqREwZQP/Ro63nKCR+jAvXhaP6unSFTr
bygIfDSB6whT/q6GcM58rIDhj5fWkYKxbBYNYBtLcrtQlVYqCT0jVA2D1EAGt6S+
kgCHMROb1l1WapfigaZPytW67QlAlS528JC9vS1R1N4iDor4JdkpR/MAHwQlgCKT
j4HMk/Rc6g40m4AiT0AYf06ae405NjqSmo2xesnxoY/t0o5yZu70VvavKPg7sBFG
dlKEyTaL8c2Iw+FVLvDfLPyG4v70xf0lYKl1riNobFEoBQF8DraO+bxfuzWbkCGi
CsoxIPDKMmlhdbUD2/+AXZgT0Kd4efdP4tjrUNkTvWxfb/dkqtjP5Vrr8LhtyfPC
oiopgFKGJBmGyaWoRtlW+CYGYqdxc2dBi4YTrGiMPYofo6DFqFPDijuGGk7rf6Il
AKjhAV/51E48tR7U4Y5KLv+0PYaP3ZTPe6/5Mug0pphipOsmmh5+igu0rE1M8tUg
7Spc/Lt6UDBSlcNkSs8mSpkDVrn67VyOXAF/GZdh47jgKoPQuRQFqnVEPZ2+swj7
qnNEH1ElHYasYNpOs3Lccs2JE4lDstMKJ30NCZq4x7gjEPN4e5IpfQczPdyYiFau
Pnh08J8UBfNrDPet12d1WCkmK8yfKjGvDx8x+P9Xcwsycw8itWQ7YqQvr9TdlTSo
D06i0ZYEibQlZbyhVpRV
=oscX
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
