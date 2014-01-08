Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaAHJIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:08:32 -0500
Received: from ring0.de ([91.143.88.219]:60551 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbaAHJIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:08:17 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 8 Jan 2014 10:08:08 +0100
From: Sebastian Reichel <sre@debian.org>
To: Roger Quadros <rogerq@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding
 information
Message-ID: <20140108090808.GB16313@earth.universe>
Mail-Followup-To: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com,
	tony@atomide.com, balbi@ti.com, arnd@arndb.de,
	linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
 <1389161742-10533-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <1389161742-10533-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 11:45:38AM +0530, Roger Quadros wrote:
> diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Do=
cumentation/devicetree/bindings/mfd/omap-usb-host.txt
> index b381fa6..5635202 100644
> --- a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> +++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> @@ -32,6 +32,10 @@ Optional properties:
>  - single-ulpi-bypass: Must be present if the controller contains a single
>    ULPI bypass control bit. e.g. OMAP3 silicon <=3D ES2.1
> =20
> +- clocks: phandle to 60MHz functional clock to the USB Host module.
> +
> +- clock-names: must be "init_60m_fclk"
> +
>  Required properties if child node exists:
> =20
>  - #address-cells: Must be 1

I have some questions:

What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Should=
n't
all of those be provided by via the DT phandle?

Should the clk_get be changed to of_clk_get()/of_clk_get_by_name() in the
driver? This would potentially remove the need of the init_60m_fclk name.

$ grep clk_get drivers/mfd/omap-usb-host.c
    omap->ehci_logic_fck =3D clk_get(dev, "ehci_logic_fck");
    omap->utmi_p1_gfclk =3D clk_get(dev, "utmi_p1_gfclk");
    omap->utmi_p2_gfclk =3D clk_get(dev, "utmi_p2_gfclk");
    omap->xclk60mhsp1_ck =3D clk_get(dev, "xclk60mhsp1_ck");
    omap->xclk60mhsp2_ck =3D clk_get(dev, "xclk60mhsp2_ck");
    omap->init_60m_fclk =3D clk_get(dev, "init_60m_fclk");
    omap->utmi_clk[i] =3D clk_get(dev, clkname);
    omap->hsic480m_clk[i] =3D clk_get(dev, clkname);
    omap->hsic60m_clk[i] =3D clk_get(dev, clkname);

-- Sebastian

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSzRV4AAoJENju1/PIO/qaDfQP/iqaqgXj6esvJbBlNZwvtyUj
LTUkqoR1fXs5ydxJ839KjVK4GiWKZbqGkwLzOBzuIPYXmVtI/HTC5JMEVqAO6hQV
be1IBSBqFqS0+FETlJ/H9UcoX46ml2NllZg/eyFWBR8lPebAc0Gyqu9LSo0vk7A6
nmjn1z5nC96MlPvmv9yk9k6cNyVicqMpQ5/8tji/onLAn+LJQ0PCxR6Tqa4BwK48
d5a84NAL4TVIAFf3d5p6z+5+Dww+RzcqcuT5xoPIqbye7mFsyXaGzjdop44xLUYc
vMmTnaycdtiaZ4aIznoLGyZRQKD+xQPrLYxM82Wbykw8lVjJLAU3kJVtKgs1FNAA
iN+6SJ8k5EbZvkHfpeCKJJ5No8mRRtzGz2tCDma8+rIVr6lSFw4UQv0slxrTZA+c
pf/r5Zn+KFu6fNtIistCSw+JYmlLCS16OvsmCN02LuvXP5WRKsPA+1FyDzZcgyRM
BGy2RHigWIW2/Imky1PY7+KZCvkPXSEHD0tYOyLMSl9bzIVoya+14h2R2IAach4d
+hrsbK3M1pcvrbw2DS0/uWzD2hFvB8D6972LX02VVvMz/NwJb5N4RODw4Gfe2usS
+O600SA6YX693ySwRLYPxUk+1RnYLrRfwmfBdwqRqL+xfEpQ3O0d6I4cCV/TjlZ+
9IDaDbRevvtZ1/c/WFNY
=YwMn
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
