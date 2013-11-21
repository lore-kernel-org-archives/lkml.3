Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3KUXjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:39:06 -0500
Received: from ring0.de ([91.143.88.219]:35697 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab3KUXjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:39:01 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 22 Nov 2013 00:38:48 +0100
From: Sebastian Reichel <sre@ring0.de>
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
Message-ID: <20131121233847.GB9772@earth.universe>
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
 <20131121022125.GA2445@earth.universe>
 <20131121204654.GB10023@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20131121204654.GB10023@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2013 at 12:46:55PM -0800, Tony Lindgren wrote:
> * Sebastian Reichel <sre@debian.org> [131120 18:22]:
> > On Wed, Nov 20, 2013 at 05:38:59PM -0800, Tony Lindgren wrote:
> >=20
> > In the public documentation of the omaps all SSI related stuff is
> > missing and memory areas are marked as reserved. I could not find
> > out how to receive the NDA version, so the following is purely
> > speculation based on the code.
> >=20
> > If I understand it right the HW looks like this:
> >=20
> > +-----------------+
> > |    GDD (DMA)    | <- this one is currently called ssi-controller
> > +--------+--------+
> > | Port 1 | Port 2 | <- these are currently called ssi-port
> > +--------+--------+
> >=20
> > I think the GDD part must be enabled while Port 1 or Port 2 is
> > enabled. The last RFC driver from Carlos did not even split up the
> > irq/memory areas into different platform devices, but just requested
> > all of them in one ssi platform device.
>=20
> Might be worth checking. If these blocks have the revision and SYSC
> register in the beginning of their address space like all omap modules,
> then they are completely separate blocks and can idle independently.

This does not seem to be the case.
I think this is just one big IP-Core, which provides two ports.

> The fact that they have separate interrutps makes me think that's the
> case, otherwise there would be just interrupt(s) at the ssi-controllel
> level.

The original driver from Carlos had all IRQs in one big platform
device. I created the ports subdevices, since it looked cleaner
than naming resources "port1_mpu_irq0".

-- Sebastian

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSjpmHAAoJENju1/PIO/qafX0P/RthfLl7kCxXOEZT11RLuyrh
uf49kagc8yNjtRaOK25ft8EYbmQbxCyZtrqEm+Xnv3PF/us9EjTYeTrDmVJ7Sh/0
1mLtDZHyS4yq11m1u3z1xfQtOwdJWTHmLeWNBGvOfaFHa0xa7AaVK8D/4FBes2tA
/7NHh2oEU4SzJCyHtQLWUOxJ7tONoNZxdhQZD5g9FiJ+kpQuqSICnJ1LuFaOjaVd
VPFH1/OTzOrDp8XW+l7AcRPHH5FYBUKR8fkebpivTH2b+Ayg+MV9EPVwaAlcFBxw
pfHh+Y8eMOX+HJoVb80OHldqN5YdSKmUGPByn3meFsEiriMWLtcp1hU0w9o3qQ6r
h9Vu7jn+Fw7FCpdf10VsL7b/4Xn+mHV+dFuM+BH5vYnmpAkfMxZl+SoGAAh2E+/N
8CUV51InahaZ5SGdTbCygMxB5mCIIxj+hUEd8TfK6m2EKZhUXv2CZ28PfRcEQV8m
ZxdWy5WLXbCITNBZFzhQCzz5LniFDqG9sPma0+pahRw4axM1CRUeGIcgKsiWKZtz
YRVd07t2xDamVJT8uJFLdJLysBmRPp/bcx+hiLqTV/wM2g6zV9y6dEsX8zheXXxM
CHUkS+5bzxaBZXowlxu4zx1Vsfiyp/1654UiIQAjaT2EYDh22r7DJ+HjYPUx+821
5Sb+nl6ZAKuqR68xf5d6
=+LA4
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
