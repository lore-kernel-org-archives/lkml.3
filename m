Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbaJ3QkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:40:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53717 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759279AbaJ3QkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:40:16 -0400
Date: Thu, 30 Oct 2014 11:39:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 16/20] usb: dwc3: add disable usb2 suspend phy quirk
Message-ID: <20141030163943.GL10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-17-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MsEL38XAg4rx1uDx"
Content-Disposition: inline
In-Reply-To: <1414663725-2195-17-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MsEL38XAg4rx1uDx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 06:08:41PM +0800, Huang Rui wrote:
> This patch adds disable usb2 suspend phy quirk, and some special platforms
> can configure that if it is needed.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc3.txt | 1 +
>  drivers/usb/dwc3/core.c                        | 7 +++++++
>  drivers/usb/dwc3/core.h                        | 2 ++
>  drivers/usb/dwc3/platform_data.h               | 1 +
>  4 files changed, 11 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentati=
on/devicetree/bindings/usb/dwc3.txt
> index 3720fca..feaf2c8 100644
> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> @@ -33,6 +33,7 @@ Optional properties:
>   - snps,tx_de_emphasis: the value driven to the PHY is controlled by the
>  			LTSSM during USB3 Compliance mode.
>   - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
> + - snps,dis_u2_susphy_quirk: when set core will disable USB2 suspend phy.
> =20
>  This is usually a subnode to DWC3 glue to which it is connected.
> =20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index fdc715a..a28ed1c 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -423,6 +423,10 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->revision > DWC3_REVISION_194A)
>  		reg |=3D DWC3_GUSB2PHYCFG_SUSPHY;
> =20
> +	/* FIXME will move FPGA flag when AMD NL taps out */

no need to mention AMD NL here. We still want to have is_fpga flag, just
dwc3-pci will be patches once AMD NL tapes out.

--=20
balbi

--MsEL38XAg4rx1uDx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmnPAAoJEIaOsuA1yqREOKYQAIIe8r593ur0DYjQMBjEGJau
QNQK7elaWJ6IpjnN9oe+Nejc53Nr5yT1n8qfBebbJzLIVknO5ZYZD4TAT4daBviM
gsgShOUaFDm4ZZfnjBz477paGZ7kUpOhAd3hWY6qJwTR7mltb+ROFVqe66/yy84V
6Luzv+Doj6scZkmkCtbNF9NKaGUa95QwegCPPgeBSohCxv6j7070fnRWhp2DAxPG
JXKVlh55qZqjAuqQZ0f4lMCMNfEh2YoHjmuL9mbcaFAph4mjIReTqoQoyWtrOUFn
SvNbIlYLOPFsT+odFRaEc+nH+UmFpLf0buu/EUCqncK3xcs7BZrEuJU2XvD/xGAL
numV6PBJpMQBEyvs7/qij072TJ4glgG3IXXZ3hTxloFCBwqUjy6eqItf6KT7nata
1KuRvgiwwGLv9u611tHg/tZgcHity/uED5atO1MSaEfZrpPuWX9JVyLKumdUyQFK
9MVj//i+OWVo58wTOhWHASmGxCU/4AlekL3OyVWnV2rGqrfGIK4BugwQQudosVo0
HaLBle3iOjVSN+vD6GRTaWyqZ9hljtBoMryOqSHJeewdOjVu42TjeAtSyE/Wub3u
yhqbqzYbjeez+S/kbYWNmYojbZVtJ1umC3d0GAmbh7m6Fus+gANBSe1iKzlRSyU5
Wm7eJQwZR9NtccHdwQki
=PIJK
-----END PGP SIGNATURE-----

--MsEL38XAg4rx1uDx--
