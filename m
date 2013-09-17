Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3IQMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:23 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34426 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3IQMoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:13 -0400
Date: Tue, 17 Sep 2013 14:43:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/9] of/irq: Defer interrupt reference resolution
Message-ID: <20130917124300.GB6757@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <52383B07.5030806@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <52383B07.5030806@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 01:20:39PM +0200, Alexandre Belloni wrote:
> Hi Thierry,
>=20
> On 16/09/2013 10:31, Thierry Reding wrote:
> > Hi,
> >
> > This small series allows interrupt references from the device tree to be
> > resolved at driver probe time, rather than at device creation time. The
> > current implementation resolves such references while devices are added
> > during the call to of_platform_populate(), which happens very early in
> > the boot process. This causes probe ordering issues, because all devices
> > that are an interrupt parent for other devices need to have been probed
> > by that time. This is worked around for primary interrupt controllers by
> > initializing them using a device tree specific way (of_irq_init()), but
> > it doesn't work for something like a GPIO controller that is itself a
> > platform device and an interrupt parent for other devices at the same
> > time.
[...]
> I believe this will solve the issue I was hitting back in June where
> of_i2c_register_devices() failed to get the IRQ while doing it at probe
> time was working fine:
>=20
> http://www.spinics.net/lists/linux-i2c/msg12523.html
>=20
> I couldn't test your patches yet though. I'll try to test as soon as I
> get some free time.

Yes, this series precisely aims at fixing situations as those. It'd be
great if you could give the series a spin to verify that it really works
for your case.

Thierry

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOE5UAAoJEN0jrNd/PrOh3voP/1hw9WEb6DSu58FjkPwBUHq9
hTmxcJnZu17WBZenis03iBhLbriJkARhFifMNEGsVtPF2lw7hIq56r1edgzX5iC+
ktSmzJoR2D51SDdwxYPTtJRtJKX6DF6TC1s6rGBVZsuwK+R2aIBwmHB6lDaQQcOG
a8phB8yCknKBAGE7RJ4rIzesltd3z7SjMuhha7x10pYCMxjhgGnQ4AqG2SXdcMwZ
bGak47drOWWvVrjQvZ+fjmy309rK79SoWfpvRPTL06erWHsrSLQRyGBew+uZQmt0
G6iIHcxr9MUeO2WtQeLkb2E3nIPzBNaADT/M1Ow+VNhSIILW6rSBVIlD+EstROp6
hXvrohTJp5i4NJjAD/Y/71lPLpUH8S0+DGh8xv/cK1HbE56XImPqraVn9vuY+8UA
BRC5jsiqswVvdjGJrYtM30oNkxJJH1tPHwAhxN1XtWtX1X6wJlf+dPFlhIwsy1L4
5uLLvTFTrXvZVV0FMTAheVyeoNOYZf3iXF1IkBdAbVhHCFaGd3J7eNq7pm98nJo1
Y/M9DNefMa7BagU54ZuJO97oF+sY30EjEspeCjiFnMPOcSPPj0gml+rr/Gj8/am8
7F9RA+31coPCsel/EY+vRDUT/aHQIP4uWrfeAolL1uo9dzamaGRUZMoHIJsIid/s
Px/lRrlyE326OtkqeyUH
=PMhD
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
