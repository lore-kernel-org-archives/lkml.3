Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3HPSkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:40:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36067 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3HPSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:40:13 -0400
Date: Fri, 16 Aug 2013 19:39:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130816183934.GQ30073@sirena.org.uk>
References: <Pine.LNX.4.44L0.1308161012160.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YnR2r17TIEndSCI"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308161012160.1532-100000@iolanthe.rowland.org>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/YnR2r17TIEndSCI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 10:42:10AM -0400, Alan Stern wrote:

> Okay, let's see if I understand your problem.  You've got a driver that
=2E..
> Is that it?

Yes, I think that's it.

> The difficulty with the first proposal is that subsystems aren't
> designed to allow that sort of thing.  They expect to be able to
> communicate with the devices they manage, during enumeration and
> probing at least.  The difficulty with the second proposal is that it
> requires duplicating the power-on code.

> My feeling is that the second answer involves less work and less
> complexity than the first.  Both proposals require additional
> "run-once" code (to do the partial instantiations or the initial
> power-ons), but the first proposal also requires the subsystem's=20
> detection and enumeration routines to be adjusted so that they can work=
=20
> even when the device is incommunicado.

Right, but like I say I'm not sure that the modifications required are
substantially different to those for handling a device powering up and
down on the bus or those for getting platform data to a device when it
does enumerate.  I'd also not be so sure about the run once code, that
is only the case for devices that can't completely idle themselves at
runtime.

> (The second proposal also has the advantage that the power-on code may=20
> be shared between the driver and the subsystem.)

Can you explain in more detail please, I don't follow?

--/YnR2r17TIEndSCI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDnHjAAoJELSic+t+oim9+qEP/3Yokdnlu77xOIb8mgiRuYNF
r72CdFyVUgKxxDM4vRCHZU0P1rN7m7FKaTDWJYSPkwN4cEGfXK5NKpgnZs8n79Dw
R5PAwfaQWv2NtYqAK7SP+tYv3zP+RS+6qwsxFrLzLZdZ5/f5i8GxzMprX1T4ukn/
T5m3rFUnPtXdYT2WJ9DWvf+BL7xWsBGZ3QSyQ83MTdP3vW4J+njts9cTEiK+lIb3
f9Ox9KfbNM3TPf9erAEvbHfOnhssGBaOXkdmaSQN6ky5P8a+uT4HZoX4295vZPst
16/QERBDVTby0qkLu4Pxfj8T+23qlEEtW12fePI9rZEG/U3Enhj4wSUXhnTLMUdO
EY3IxBHNzHnDN6qmENAZWwAsmNp+KfiJh5xk8pmOot0Th8JOJXu9jOhEVVddx2Xh
ZQfNCoiTD4RKri3Qj2xS37uO4/swE0QUq/4FB4D2mne2qcHzZeBCbhPthgC0wjsw
YFxEnRdW2e/6jFF/idWVujoIFSlM8tojCjxcKPiSDS1GgtVPgmwMsSPW4IjMt6vP
wwuWXQGZJFgztV1Uxvo0K0SPmlPcdLdhpDzq0mOPE9Eioow3M2xmteU5AbCCeroz
wI2ZtIY8oJ1/EdTccPaVE9R1TTkEmCFZgLbx8394eVWjbX3bokoF72DEevEf09Ig
OnFs2toh/jwnHbmSUzSd
=1rF8
-----END PGP SIGNATURE-----

--/YnR2r17TIEndSCI--
