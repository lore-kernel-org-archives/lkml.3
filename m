Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3IWXrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:47:25 -0400
Received: from ring0.de ([91.143.88.219]:41641 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3IWXrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:47:22 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Tue, 24 Sep 2013 01:46:56 +0200
From: Sebastian Reichel <sre@debian.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20130923234656.GB24781@earth.universe>
Mail-Followup-To: Stephen Warren <swarren@wwwdotorg.org>,
	Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
 <5240A617.1010208@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <5240A617.1010208@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 23, 2013 at 02:35:35PM -0600, Stephen Warren wrote:
> On 09/15/2013 02:44 PM, Sebastian Reichel wrote:
> > Add SSI device tree data for OMAP34xx and Nokia N900.
>=20
> What is an "SSI" device, ...

Synchronous Serial Interface (SSI), which is an interface from
the OMAP3 for modem connection. It's a legacy variant of
High-speed Synchronous Serial Interface (HSI). This in turn
is a standard from MIPI:

http://www.mipi.org/specifications/high-speed-synchronous-serial-interface-=
hsi

>=20
> > diff --git a/Documentation/devicetree/bindings/hsi/omap_ssi.txt b/Docum=
entation/devicetree/bindings/hsi/omap_ssi.txt
>=20
> ... and what is the "HSI" subsystem?

A framework for HSI devices living in drivers/hsi.

> > +OMAP SSI controller bindings
> > +
> > +Required properties:
> > +- compatible:		Should be set to the following value
> > +                        ti,omap3-ssi (applicable to OMAP34xx devices)
>=20
> I think that'd be better phrased as:
>=20
> 	Should include "ti,omap3-ssi".
>=20
> The binding should not preclude other compatibel values being present
> (e.g. a SoC-specific compatible value, to allow SoC-specific quirks to
> be enabled later).

Right. Will be fixed in the next RFC.

> > +- ti,hwmods:		Name of the hwmod associated to the controller, which
> > +			is "ssi".
>=20
> I don't think we should add any more of that, for new bindings.

That basically means not adding new drivers until hwmod is completly
removed, since no new drivers not using DT are accepted anymore.

hwmod still holds some information, which are not yet mapped to DT.

> > +- reg:			Contains SSI register address range (base address and
> > +			length).
> > +- reg-names:		Contains the names of the address ranges. It's
> > +                        expected, that "sys" and "gdd" address ranges =
are
> > +			provided.
>=20
> Why two entries in reg-names but only one in reg?
>=20
> I think it'd be better to write:
>=20
> reg-names:	Contains the values "sys" and "gdd".
> reg:		Contains a register specifier for each entry in
> 		reg-names.
>=20
> A similar re-ordering/-wording would apply to interrupts/interrupt-names.

OK. Will be fixed in the next RFC.

> > +- ranges		Required as an empty node
>=20
> s/node/property/
>=20
> Why must ranges be empty? As long as the content correctly represents
> the bus setup, why does the content matter at all. How about:
>=20
> ranges		Represents the bus address mapping between the main
> 		controller node and the child nodes below.

OK. Will be fixed in the next RFC.

> > +Each port is represented as a sub-node of the ti,omap3-ssi device.
> > +
> > +Required Port sub-node properties:
> > +- compatible:		Should be set to the following value
> > +                        ti,omap3-ssi-port (applicable to OMAP34xx devi=
ces)
>=20
> Hmm. Is it really the case that there is 1 controller with n ports?

Yes with n=3D2.

> Are the ports really dependent upon some shared resource?

Yes and runtime power management.

> Couldn't the ports be represented as separate top-level SSI
> controllers?

Maybe with some phandles. The current layout is cleaner IMHO.
The ports are part of the controller and actually most boards
only use one of them.

In the original driver only the controller hat platform data
with memory areas called "port1_rx" etc.

> > +- interrupts:		Contains the interrupt information for the port.
> > +- interrupt-names:	Contains the names of the interrupts. It's expected,
> > +			that "mpu_irq0" and "mpu_irq1" are provided.
>=20
> What exactly are those interrupts? "MPU" sounds like an external
> micro-controller/processor...
>=20
> > +- ti,ssi-cawake-gpio:	Defines which GPIO pin is used to signify CAWAKE
> > +			events for the port. This is an optional board-specific
> > +			property. If it's missing the port will not be
> > +			enabled.
>=20
> That also sounds like something that's a higher-level protocol, rather
> than whatever low-level transport "SSI" implements. Should this be part
> of a child node that represents the device attached to the SSI controller?

Both the interrupts and the cawake-gpio are used as irqs for
starting data transfers. As far as I understand it none of
them are specific to the attached device.

NOTE: I do not have documentation for the chip. I just ported the
old patch from Carlos Chinea (who developed the initial driver for
Nokia) to the new kernel frameworks, since I want to use the
modem of my Nokia N900.

> Does the SSI controller (or its ports) not need any clocks, resets,
> regulators, ...?

The only other stuff needed is taken care of by hwmod, which can
be seen in this patch:

https://lkml.org/lkml/2013/9/15/97

As far as I understand it, this kind of information is not yet
supported by DT on OMAP boards. On the other hand new OMAP drivers
are not allowed to add further board code, so temporarily the
ti,hwmod hack must be used.

-- Sebastian

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSQNLwAAoJENju1/PIO/qaSB8QAJjTPYXtA1JNGzGsctr8LGFE
zglVED2xVohdqeRbd5JXJYQVGiQQzCdo8WTni/jFJlIXFeeU23yM9T2nrRQoPOUb
7Spkf2yMzrqNTnG6iW824t84IDPYd9L/2dVx62js9bIv9KVbofE4gZ65pQbi0Plq
58ZEDmhwb566+ISppV3NaHlRCRIr3Tg4KowU3QYm69lCC/xvehI6jhVGJ8LWKHoM
BUqIcN4A6iYzy/Gi3OlwbtNGuIoSkEDd3SBdaYkzmLU0tFXvU0baBUZR7zmW/DYP
LzFKthVgJLLhGmcjQwu5ouNEtvN9qRxN4e/ZNdYZLhxsYK4Doudw6qYPxbTLxnr2
sXX0ekZqdxb0DcncxXbMxn/M19haezQggNtZAKbZHrTok6j42QWomNeE5mnCajJh
0gW81cOxLztvf9Tane7mVzJPP+bm5Hte7Xycl0uHpodZcJXa/yWNJKR0a1l1/GqN
862hSMInUyKHjkrl9qQ5m6ZpMDzuB/5ny3f+Bq29dTLZqSthCRJdQ2Z4Bfq/VuPT
sFAQvFFJao+HkL/CMkj91My1yfHvtLuRdtxhiJ3T1wcI7SEJImouzYWIZLr+LAIZ
Y9I49QtfBzDGWWInHQl+hRRevfto2pFtDbi9wDpjvRgOm2QoY4xrBze+VlqEMEGW
vZIA3gPLC8/RRhpqgVM/
=8UXS
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
