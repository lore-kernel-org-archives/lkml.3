Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaJ3QiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:38:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53160 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415AbaJ3QiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:38:14 -0400
Date: Thu, 30 Oct 2014 11:37:43 -0500
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
Subject: Re: [PATCH v4 20/20] usb: dwc3: make HIRD threshold configurable
Message-ID: <20141030163743.GJ10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-21-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <1414663725-2195-21-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 06:08:45PM +0800, Huang Rui wrote:
> HIRD threshold should be configurable by different platforms.
>=20
> From DesignWare databook:
> When HIRD_Threshold[4] is set to 1b1 and HIRD value is greater than or
> equal to the value in HIRD_Threshold[3:0], dwc3 asserts output signals
> utmi_l1_suspend_n to put PHY into Deep Low-Power mode in L1.
>=20
> When HIRD_Threshold[4] is set to 1b0 or the HIRD value is less than
> HIRD_Threshold[3:0], dwc3 asserts output signals utmi_sleep_n on L1.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc3.txt |  3 +++
>  drivers/usb/dwc3/core.c                        | 17 +++++++++++++++++
>  drivers/usb/dwc3/core.h                        |  6 ++++++
>  drivers/usb/dwc3/gadget.c                      |  6 +-----
>  drivers/usb/dwc3/platform_data.h               |  3 +++
>  5 files changed, 30 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentati=
on/devicetree/bindings/usb/dwc3.txt
> index feaf2c8..5b99755 100644
> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> @@ -34,6 +34,9 @@ Optional properties:
>  			LTSSM during USB3 Compliance mode.
>   - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
>   - snps,dis_u2_susphy_quirk: when set core will disable USB2 suspend phy.
> + - snps,is-utmi-l1-suspend: true when DWC3 asserts output signal
> +			utmi_l1_suspend_n, false when asserts utmi_sleep_n
> + - snps,hird-threshold: HIRD threshold
> =20
>  This is usually a subnode to DWC3 glue to which it is connected.
> =20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index a28ed1c..f4172ab 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -729,6 +729,7 @@ static int dwc3_probe(struct platform_device *pdev)
>  	struct dwc3		*dwc;
>  	u8			lpm_nyet_threshold;
>  	u8			tx_de_emphasis;
> +	u8			hird_threshold;
> =20
>  	int			ret;
> =20
> @@ -790,12 +791,22 @@ static int dwc3_probe(struct platform_device *pdev)
>  	/* default to -3.5dB de-emphasis */
>  	tx_de_emphasis =3D 1;
> =20
> +	/*
> +	 * defalut to assert utmi_sleep_n and use maximum allowed HIRD

default

--=20
balbi

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmlWAAoJEIaOsuA1yqREX38P/0vRdfmp9nEwyb+cLlk4lbLI
/ShZCybrSc3nyRTuvb9IZQpU64NEXrSjUO8M4jmgpBmfX6phlvYkHpqE0dyroazb
sqY5ugYu+K10XOvqolOhtnGvEFr44MZ31LSWx+7KY6iTSzZuQWUrcabxGN6Tuekw
o4Pj6JKtcrC6C+AKG7jHKol0Tu7elBH4wo+SO0Ufz8sJJmtgOPr9CVBe/aeBmACq
v0ZxDxCQeHpaDous65lCK8gfgQU42A7jodub82GnP5O4CW8xAMR88TWC7tTecrRQ
quSzPBubYLc9ZGSn/FytoPG3hmU/sHuGhz3Poyz5YzSEIIXnxAioAodGBE0ic9LO
O6wFzwMT0WzDbivIaNopKc2YgoZcwO1Ewt10QA0jor7rwzbU5uSG8/WvQnXwb8KG
mwdmYdTIzRXXlb+XgFnYiXoAxkG2l1COhLQr53F6hhIKQ6kwrLuh2JCJngH8mEHc
MtY8Potf0jHCnCRczeZl1NB6x5o9uTkPgBbI/vE2oSkR8rdSw6ddjeq/IJHIsFkP
9SM79w4uUXVI6jMNmfpCCAHoJExP/8yDxeuDEpJKEeqS73O1KvWBGISznyXwJzoi
L0LC2+BrZYggiHofnlS9wrrcImb+H5/+lzi2p3YiZ76a0i0EB42GymGcRXAVIX/M
itmYQSSKHekYkoos0cNR
=hbzq
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
