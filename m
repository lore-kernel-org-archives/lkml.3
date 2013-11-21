Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3KUCVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:21:39 -0500
Received: from ring0.de ([91.143.88.219]:58264 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab3KUCVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:21:36 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 21 Nov 2013 03:21:27 +0100
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20131121022125.GA2445@earth.universe>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
 <20131121013858.GK10317@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20131121013858.GK10317@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, Nov 20, 2013 at 05:38:59PM -0800, Tony Lindgren wrote:
> * Sebastian Reichel <sre@debian.org> [130915 13:56]:
> > +
> > +Example for Nokia N900:
> > +
> > +ssi-controller@48058000 {
> > +	compatible =3D "ti,omap3-ssi";
> > +	ti,hwmods =3D "ssi";
> > +
> > +	reg =3D <0x48058000 0x1000>,
> > +	      <0x48059000 0x1000>;
> > +	reg-names =3D "sys",
> > +		    "gdd";
> > +
> > +	interrupts =3D <55>;
> > +	interrupt-names =3D "gdd_mpu";
> > +
> > +	#address-cells =3D <1>;
> > +	#size-cells =3D <1>;
> > +	ranges;
> > +
> > +	ssi-port@0 {
> > +		compatible =3D "ti,omap3-ssi-port";
> > +
> > +		reg =3D <0x4805a000 0x800>,
> > +		      <0x4805a800 0x800>;
> > +		reg-names =3D "tx",
> > +			    "rx";
> > +
> > +		interrupt-parent =3D <&intc>;
> > +		interrupts =3D <51>,
> > +			     <52>;
> > +		interrupt-names =3D "mpu_irq0",
> > +				  "mpu_irq1";
> > +
> > +		ti,ssi-cawake-gpio =3D <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
> > +	}
> > +}
>=20
> These should be in the omap3.dtsi file and not nested but separate. I'm a=
lmost
> certain that these are completely independent hardware modules and this
> means they can live their own PM life independently.
>
> So can you please do a minimal patch for omap3.dtsi that just sets up
> the standard resources separately for both modules the same way we have
> for other hardware modules in omap3.dtsi do?
>=20
> One of them should be called ssi, no idea what the other module name shou=
ld
> be as those register ranges show up as reserved in the docs I have.

In the public documentation of the omaps all SSI related stuff is
missing and memory areas are marked as reserved. I could not find
out how to receive the NDA version, so the following is purely
speculation based on the code.

If I understand it right the HW looks like this:

+-----------------+
|    GDD (DMA)    | <- this one is currently called ssi-controller
+--------+--------+
| Port 1 | Port 2 | <- these are currently called ssi-port
+--------+--------+

I think the GDD part must be enabled while Port 1 or Port 2 is
enabled. The last RFC driver from Carlos did not even split up the
irq/memory areas into different platform devices, but just requested
all of them in one ssi platform device.

> The other binding pieces can be added later on as they get are ready.

Sure. They are almost finished btw. I was able to get a gsm network
scan.

-- Sebastian

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSjW4lAAoJENju1/PIO/qaTvEP/iTEpmtsp7dHaU3g7xfesGzA
H0BS2vvAQNS8fWHhdhfMtHwvPDNgQvwFyGOCdu55YkDgrFAzQkQfHNKLgu441XT8
oVPEvLvzRwUbnkoCAw1JA/3/NancNuJoxmFmPyEXYN5n/Ac/++Wctj9QOLLnzYIO
pOmCxh0FCTgzB2Sb69t8Pm1EQEw1OwOCXWrUU7yL3iYOqbcyASC9/7ToxcNvfAIC
i2LNyYZGB51QYoDIVDZYjlFDVQCdYgzja+AYQDqc0xMqzN+ZWkc1Lt4CZvCJCTbh
Vl7L6p5Wgm2Z3YazxoFlOt8V0ndz9nZzZo6Hi9BZMIsJ52ZSxG/AMkkebTZe34XZ
BKMFV4abw+rrkQBr2PGrY59I/r/eR9Txhv2s/f55Z3KL1Jf/PB6a2d+AJVUm4LfJ
ai3vIQRnayVLa5jUrKqG1R/BiIM6jVUSOZEj6SrS+ij/e7o4icROYUTXK3g0zdEL
DfhP2jmcYnwi84qTItcHuYp5G84z0ArgyX1/9DRPLP6KUXs0bd00Aw3zC1GeB8lH
goutI7gqB6scuJSug5EFrPQ+UCm//3OIeUWl9EbS8P1nHrQD4pKVLn3QLSpaBliW
Clp38D2g/qCOfzzjnEhZMsafF/dfkvI2R56u1CF+ckmwCaTgn81wpG0OYGCghYsV
sH9sRwjTmeDUi4dyZf7e
=pE2B
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
