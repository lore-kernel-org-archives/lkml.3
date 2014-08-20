Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaHTSAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:00:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35485 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHTSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:00:36 -0400
Date: Wed, 20 Aug 2014 13:00:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <balbi@ti.com>, <lee.jones@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 2/3] usb: dwc3: dwc3-st: Add st-dwc3 devicetree
 bindings documentation
Message-ID: <20140820180005.GU24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4yrq4dHtCqH+JvC"
Content-Disposition: inline
In-Reply-To: <1406734091-16202-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V4yrq4dHtCqH+JvC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 04:28:10PM +0100, Peter Griffin wrote:
> This patch documents the device tree documentation required for
> the ST usb3 controller glue layer found in STiH407 devices.
>=20
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/usb/dwc3-st.txt | 69 +++++++++++++++++=
++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/dwc3-st.txt
>=20
> diff --git a/Documentation/devicetree/bindings/usb/dwc3-st.txt b/Document=
ation/devicetree/bindings/usb/dwc3-st.txt
> new file mode 100644
> index 0000000..de3fea3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/dwc3-st.txt
> @@ -0,0 +1,69 @@
> +ST DWC3 glue logic
> +
> +This file documents the parameters for the dwc3-st driver.
> +This driver controls the glue logic used to configure the dwc3 core on
> +STiH407 based platforms.
> +
> +Required properties:
> + - compatible	: must be "st,stih407-dwc3"
> + - reg		: glue logic base address and USB syscfg ctrl register offset
> + - reg-names	: should be "reg-glue" and "syscfg-reg"
> + - st,syscon	: should be phandle to system configuration node which
> +		  encompasses the glue registers
> + - resets	: list of phandle and reset specifier pairs. There should be t=
wo entries, one
> +		  for the powerdown and softreset lines of the usb3 IP
> + - reset-names	: list of reset signal names. Names should be "powerdown"=
 and "softreset"
> +See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
> +See: Documentation/devicetree/bindings/reset/reset.txt
> +
> + - #address-cells, #size-cells : should be '1' if the device has sub-nod=
es
> +                                 with 'reg' property
> +
> + - pinctl-names	: A pinctrl state named "default" must be defined
> +See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> +
> + - pinctrl-0	: Pin control group
> +See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
> +
> + - ranges	: allows valid 1:1 translation between child's address space a=
nd
> +		  parent's address space
> +
> +Sub-nodes:
> +The dwc3 core should be added as subnode to ST DWC3 glue as shown in the
> +example below. The DT binding details of dwc3 can be found in:
> +Documentation/devicetree/bindings/usb/dwc3.txt
> +
> +NB: The dr_mode property described in [1] is NOT optional for this drive=
r, as the default value
> +is "otg", which isn't supported by this SoC. Valid dr_mode values for dw=
c3-st are either "host"
> +or "device".
> +
> +[1] Documentation/devicetree/bindings/usb/generic.txt
> +
> +Example:
> +
> +st_dwc3: dwc3@8f94000 {
> +	status		=3D "disabled";
> +	compatible	=3D "st,stih407-dwc3";
> +	reg		=3D <0x08f94000 0x1000>, <0x110 0x4>;
> +	reg-names	=3D "reg-glue", "syscfg-reg";
> +	st,syscfg	=3D <&syscfg_core>;
> +	resets		=3D <&powerdown STIH407_USB3_POWERDOWN>;
> +			  <&softreset STIH407_MIPHY2_SOFTRESET>;
> +	reset-names	=3D "powerdown",
> +			  "softreset";
> +	#address-cells	=3D <1>;
> +	#size-cells	=3D <1>;
> +	pinctrl-names	=3D "default";
> +	pinctrl-0	=3D <&pinctrl_usb3>;
> +	ranges;
> +
> +	dwc3: dwc3@9900000 {
> +		compatible	=3D "snps,dwc3";
> +		reg		=3D <0x09900000 0x100000>;
> +		interrupts	=3D <GIC_SPI 155 IRQ_TYPE_NONE>;
> +		dr_mode		=3D "host"
> +		usb-phy		=3D <&usb3_phy>;
> +		phy-names	=3D "usb2-phy";
> +		phys		=3D <&usb2_picophy2>;

why are you using different binding for usb2 and usb3 phys ? Why can't
you just:

	phys-names	=3D "usb2-phy", "usb3-phy";
	phys		=3D <&usb2_picophy2>, <&usb3_phy>;

??

--=20
balbi

--V4yrq4dHtCqH+JvC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OIlAAoJEIaOsuA1yqRE+v8P/AtsnJUARlKiU9RBWK0rvQ6N
JSaI0n2VgXVvFX2XWKujp95+ZU2Ytks6MM5rhLt2yZtqP44T//4mmhuSnQoUeE0K
PGjnCz0r1ebU2G3aEat8OQB7jq4AN/Q458Ak214YCQh985EoMAEkc9ZXIyvXOeDi
krJIdU3eZ3avrsWlCWMNC79EzRN12/z8wRXeOm54Y/WN0BrqK6zyvumfT0ZueDDV
uUODPxNMdkNqHS1CAJNMsN2uo9KT10AY57IWGqHghnvBkRhMC18MI9CZNnnuI2qV
N639eIzxNpF+BmSPd6sGbNiq+Wx9VGnoaqK/EcwTOApTP/8Mt18qgPivvC9h4HSb
FYXtDfGp28ZA//R3Fv9Y3lT3UGYGLaZuc2GLw8Q6PQA5Iu7QObX7UnCoOtyYqefe
/c2mkNzd/xzB4W3yIwJZK1gr/4k1dyLQVzc2qYfTgBGYlu+zDrVOjvfiyv0TZuDN
f932rJvt1vadcKs3w6ZSWzFJBPEPhcwGfO7YB7limvfUuyXAkLOLzyIzoiyz4Jfq
tRV1fjRmcuL/c4rHMW1Xasp0jeYv+hVjz7COQMHhlO6FeHiqfvaNtiSKY8hy4lNU
4ZOiaJXpcLGRF1ds+ckQlmy/GfsKUYbqopxmMwcciGw11n4h4T+n4mOC5MZkffWA
CYFA/v+cvRvINq2/l1wN
=VvSM
-----END PGP SIGNATURE-----

--V4yrq4dHtCqH+JvC--
