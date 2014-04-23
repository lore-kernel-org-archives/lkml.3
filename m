Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaDWKqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:46:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46687 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaDWKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:46:08 -0400
Message-ID: <5357999F.6010200@ti.com>
Date: Wed, 23 Apr 2014 13:44:47 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <plagnioj@jcrosoft.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        <hns@goldelico.com>
Subject: Re: [PATCH 1/2] omapdss: panel-tpo-td028ec1: Add DT support.
References: <1398201168-25275-1-git-send-email-marek@goldelico.com> <1398201168-25275-2-git-send-email-marek@goldelico.com>
In-Reply-To: <1398201168-25275-2-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="DwPKl9r4Shf3fKlmmjVbo0Jtpl6kGSx4L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DwPKl9r4Shf3fKlmmjVbo0Jtpl6kGSx4L
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/04/14 00:12, Marek Belisko wrote:

>  static int td028ttec1_panel_probe(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata;
> @@ -418,6 +436,10 @@ static int td028ttec1_panel_probe(struct spi_devic=
e *spi)
>  		r =3D td028ttec1_panel_probe_pdata(spi);
>  		if (r)
>  			return r;
> +	} else if (spi->dev.of_node) {
> +		r =3D td028ttec1_probe_of(spi);
> +		if (r)
> +			return r;
>  	} else {
>  		return -ENODEV;
>  	}
> @@ -463,6 +485,13 @@ static int td028ttec1_panel_remove(struct spi_devi=
ce *spi)
>  	return 0;
>  }
> =20
> +static const struct of_device_id td028ttec1_of_match[] =3D {
> +	{ .compatible =3D "toppoly,td028ttec1", },

We need to hack a bit here for the time being. You need to have
"omapdss," prefix for the compatible string in the driver, and add the
panel's compatible string to arch/arm/mach-omap2/display.c:
dss_compat_conv_list.

The reason for this is that the drivers are omap specific, but the DT
data is not.

Otherwise looks good to me.

 Tomi



--DwPKl9r4Shf3fKlmmjVbo0Jtpl6kGSx4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV5mfAAoJEPo9qoy8lh7128IQAJrx+jxEdlDpr09EJExenS4g
8AXWsMcK/2LWL+QMqkUTnLL797LXNxU7FwfkORfVzREbat/EmI1jXU5fJ90MwQzH
94E16d+RCOMARWepY13H8WG70st4KZ3ApT1C5+k7kK3WsXkxxm6tovfRy75jMtFR
7oWJRKzR/bSCveJ3deBmnWazY8Reat9zWGXZB7tTxQ8MWrn+KLJl3AnKhhCUL9mD
fHe6rIlSrpQVAEuIh82rDBRR1m5EPIjiDHQWBz+/hhrldsd4b/A5GnykCf6USjAQ
SFvYdtZpYdI15a4VZUkaKy88ImApsNGKQcUP45dQ+3wxfU57/OMfeUPL+yzS2CP0
A6gTfs33qotHWIoGDpIW72w2lATfILI7LHfRavFh0GCZlwNywYhq32URJW5ZHwSk
kt7/VT3IW9tv48p59knr0MG1czKFg8c2s4+hmCa53kuRCSMuinWt9+Sv4GpuOOkC
j8KRK9PVl4WMAyswMRdxRQW3zota1kd7TJtjJgpSaqTaUlqR81b4qlZKnXXqDCOX
OTB0PdGcVxNIL0NWKBtkZdvfWOKec9qkJFRWsuSheoyA1jXlNNlT/TT8mfZb+uSS
uqP2rrbC3ZmGtTmxmsR3K9LvBZMAYFOir0nh5uzQukXrqIxdVg21pYtPzRmjFW4L
nkGa+0zGXgkLcD/XjU2Y
=qULE
-----END PGP SIGNATURE-----

--DwPKl9r4Shf3fKlmmjVbo0Jtpl6kGSx4L--
