Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3FYLMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:12:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58833 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3FYLMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:12:44 -0400
Date: Tue, 25 Jun 2013 14:12:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130625111234.GJ15407@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5me2qT3T17SWzdxI"
Content-Disposition: inline
In-Reply-To: <1372149330-24335-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5me2qT3T17SWzdxI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 25, 2013 at 11:35:30AM +0300, Luciano Coelho wrote:
> Add device tree bindings documentation for the TI WiLink modules.
> Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> modules is supported.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>=20
> I created a new directory under net to contain wireless bindings document=
ation.
>=20
> The actual implementation in the driver will follow separately.
>=20
>  .../devicetree/bindings/net/wireless/ti-wilink.txt |   46 ++++++++++++++=
++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wil=
ink.txt
>=20
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt=
 b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> new file mode 100644
> index 0000000..d8e8bfbb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> @@ -0,0 +1,46 @@
> +TI WiLink Wireless Modules Device Tree Bindings
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The WiLink modules provide wireless connectivity, such as WLAN,
> +Bluetooth, FM and NFC.
> +
> +There are several different modules available, which can be grouped by
> +their generation: WiLink6, WiLink7 and WiLink8.  WiLink4 is not
> +currently supported with device tree.
> +
> +Currently, only the WLAN portion of the modules is supported with
> +device tree.
> +
> +Required properties:
> +--------------------
> +
> +- compatible: should be "ti,wilink6", "ti,wilink7" or "ti,wilink8"
> +- interrupt-parent: the interrupt controller
> +- interrupts: out-of-band WLAN interrupt
> +	See the interrupt controller's bindings documentation for
> +	detailed definition.
> +
> +Optional properties:
> +--------------------
> +
> +- refclock: the internal WLAN reference clock frequency (required for
> +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> +  following:
> +	0 =3D 19.2 MHz
> +	1 =3D 26.0 MHz
> +	2 =3D 38.4 MHz
> +	3 =3D 52.0 MHz
> +	4 =3D 38.4 MHz, XTAL
> +	5 =3D 26.0 MHz, XTAL
> +
> +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> +  following:
> +	0 =3D 19.200 MHz
> +	1 =3D 26.000 MHz
> +	2 =3D 38.400 MHz
> +	3 =3D 52.000 MHz
> +	4 =3D 16.368 MHz
> +	5 =3D 32.736 MHz
> +	6 =3D 16.800 MHz
> +	7 =3D 33.600 MHz

DTS files are pre-processed, so you could add defines in a header and
share the header between DTS and driver. Could help you having:

tcxoclock =3D WILINK_19_200MHz;

instead of

tcxoclock =3D 0;

--=20
balbi

--5me2qT3T17SWzdxI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyXshAAoJEIaOsuA1yqREI/kP/Anb/WgcZ8t4LW9t+gT/DbFR
n7Z0VUSfs0P7+lq52eNWKPaxHSnqcS+kN7Ao9UI8qC3O/LWckz1NKRDgA33W6h40
37uT7rh3xpe3QKpXrYhxyjgEzwkr4cbxeEyjW9s1uHbcqWLAd/kL2ON4FxvT3vm+
6p2TBOnORp07PG7Hw/+SlzxP54vkq/CextoGpkK/xnzn3G0HJPOmpUCaOIB6nFqB
O9hKB0u7mHYUxtAhhdM396pN8c2OZNiQq8D5UhrGg//f/QouLEIOY+Z5/56zpvh1
zKXeMJQTYpJ7VbbHse6qlrwZBtJL8Two3FAXLd0J3SGpdHXSZUZydZfmnsax++Py
1bKuhA9elrrLD2TUfry1kxrtV/FjnNrsvsJeRdfN0nEuF1B9NTW0OsBehkXhn11W
8dJiXUU6Q6P+uWdtj8I1ikO99+nDjUj9xmHQi/Bhi2i537ik9fAPTQkHW3zHhtmS
rbo6YdKCHpmm1ndeu/4unnk0ZY0SbuUsGRL6d8roRrEoKmntGVgipjABgwCXPHPN
T5jpTGXz0/wg/JXXTAsrOmxUOfGMBntDeZ3SFSCzkCXcs88VuSrvDZc95JoRpfzL
4C7pYG5VPqHnH+2Lj72PBp6BagFRQOawe2vjrgGjgH/GNObvHwMDI0ZLO9hFcQgB
gyfoq4+8UI5lG82BitCj
=4ZiW
-----END PGP SIGNATURE-----

--5me2qT3T17SWzdxI--
