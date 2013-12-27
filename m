Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3L0SLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:11:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab3L0SLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:11:08 -0500
Date: Fri, 27 Dec 2013 12:10:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH v4 01/15] usb: phy: msm: Move mach dependent code to
 platform data
Message-ID: <20131227181009.GF7819@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
Content-Disposition: inline
In-Reply-To: <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 12, 2013 at 04:51:36PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> This patch fix compilation error when driver is compiled
> in multi-platform builds.
>=20
> drivers/built-in.o: In function `msm_otg_link_clk_reset':
> ./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
> ./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'
>=20
> Use platform data supplied reset handlers and adjust error
> messages reported when reset sequence fail.
>=20
> This is an intermediate step before adding support for reset
> framework and newer targets.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Acked-by: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

this really looks like you should be using reset framework
(drivers/reset/), then your phy driver would simply reset_assert() and
reset_deassert().

--=20
balbi

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSvcKBAAoJEIaOsuA1yqREhCQQAIKZHasuHx1aZ5z9ZcSzS5Ia
KiTE8tPz5sgSyrKpyNDCwMDKRWeXSuVhBCIz4HuZtIJqLxz4qfBNkGE2aUTS0Pdo
G/0zi80+9Q0PYg/lB+sevUkfqSaHc9OdgZx1qZ11RYgXIFhF0UYS0huaIyg3jsPY
sEe3S9KbtX4SUUSv2NP23BNehbXb2M6LQYM863IUibh/SgA7VdotJWahMBx2YJK5
dq47SmZNiqpxppFs49esB6taJ0wLngdLiY24inKaAxx9f57XdXbvgUfyW8EFhvlH
535FLrOW49F46348zbLDLE8GFZBwiMQslR/vBX3NH2PRPbi1ZjhwgDa00onyNX9C
PPpNQMspO4Zu4hu/C4PnoV8SrHAGdSECbh4Z0MY4FNOIIkaIZWkELu4F4+EEYvyg
D1azgvo1skemq+VuU40wwrRHHO2w0zEPCqlTDQAE4doPkch74CvDKsTUFHiCvJYC
vFCSNgkD2We4FTfWX/D0PfWJstXbe6fBRZJnshGQeVHEA+PpkWHf4AyTFooxgWzc
H01c02OrxXlVdYUATEG6nOFyP/qgaGzwlozLQA7asDo0eW1OXBpECVeiJ5zoMTaz
DOOqBWlnJCBo3waTD0nS7ZGaMuKCzhWgIKoHY92u/p8WnCKax5y019ctfwwQbwIX
Yk0lIoNS9LUrMOdg+FA9
=6DbC
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
