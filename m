Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaJQOuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:50:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49219 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbaJQOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:50:19 -0400
Date: Fri, 17 Oct 2014 09:50:00 -0500
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
Subject: Re: [PATCH v2 08/16] usb: dwc3: add u2exit lfps quirk
Message-ID: <20141017145000.GD26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-9-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-9-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:33PM +0800, Huang Rui wrote:
> AMD NL needs to enable u2exit lfps quirk.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 4 ++++
>  drivers/usb/dwc3/core.h          | 1 +
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 25db533..7322d85 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -467,6 +467,10 @@ static int dwc3_core_init(struct dwc3 *dwc)
>  		reg |=3D DWC3_GCTL_DISSCRAMBLE;
>  	else
>  		reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> +
> +	if (dwc->quirks & DWC3_QUIRK_U2EXIT_LFPS)

this should be:

	if (dwc->u2_exit_lfps_quirk)

> +		reg |=3D DWC3_GCTL_U2EXIT_LFPS;
> +
>  	/*
>  	 * WORKAROUND: DWC3 revisions <1.90a have a bug
>  	 * where the device can fail to connect at SuperSpeed
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index d58479e..3d27f10 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -166,6 +166,7 @@
>  #define DWC3_GCTL_SCALEDOWN(n)		((n) << 4)
>  #define DWC3_GCTL_SCALEDOWN_MASK	DWC3_GCTL_SCALEDOWN(3)
>  #define DWC3_GCTL_DISSCRAMBLE		(1 << 3)
> +#define DWC3_GCTL_U2EXIT_LFPS		(1 << 2)
>  #define DWC3_GCTL_GBLHIBERNATIONEN	(1 << 1)
>  #define DWC3_GCTL_DSBLCLKGTNG		(1 << 0)
> =20
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index bbe946c..cdb9b04 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -149,7 +149,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD && pci->device =3D=3D
>  			PCI_DEVICE_ID_AMD_NL) {
>  		dwc3_pdata.has_lpm_erratum =3D true;
> -		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL;
> +		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL
> +			| DWC3_QUIRK_U2EXIT_LFPS;
>  	}

should be combined and the last patch in the series.

--=20
balbi

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQSyYAAoJEIaOsuA1yqREmN4P/0F+vpunTtvNYWSnuyUZ6i+w
ybRtq3dH943md/4TlAZ4if+dAiJ+FQTvjTHCsbuAeTotql6Th2g9RHHhMAgAfLyi
2+HCWphymkUpaHfR8WLcHvfvNXU1GHKG55s1pC2otjaQujEncCd/qiHLi6MTd7C2
7KmJjK/uhNgeS6tXtNLjG8h8j54fahJ0UjNblB9Da+T4ZTL4pe0KtnoV6aA2KNRS
Lf6yItOQXvnS8jIpuolSXEXpeHDZvTLYod8XjZABAi7pGkKU4X02jSZMl8y79USq
owD6u8pZil71PSd7+F6QMfDXVkmKECG/Hi0WwwMmunLw3NF7UYkfUgTngqGiLiPb
AfW7PuzqwVeswU4p6NIoV8xbsysagv+45RuRJ2/i8hOtIYXpuicepGxflzXSJZz1
4KhWaOgpJ+Ndhakesjc+aXIJDngPedJjfg6HuhjEcs/xQGhUTjUr0jvrjeI5ftnT
onILaOQQc/y5sX4XqblKoTgROgydbA0PfmsLy8KIB3dPPfFwy4EdXYjp/8BTxjLN
slIZgPEDhvwGI03rTQF31tfQsY1M22GX7cw3PzeZsjBBECumaySjvbUkVsoilo4c
gjaAktdKFssHEplEz6amrcwzpjYAUSMsT1hMtzK3XBZ1DOS9qPA85LGHCj0lelrh
ggByirP1nn8kUrUi3lCc
=wK/w
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
