Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaCHJgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:36:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47102 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaCHJga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:36:30 -0500
Message-ID: <531AE46A.2060808@ti.com>
Date: Sat, 8 Mar 2014 11:35:38 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>	 < 1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>	 <530DE8A9. 9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de> < 530DFF4C.8080807@ti.com> <20140307181132.B2D71C40A88@trevor.secretlab.ca>
In-Reply-To: <20140307181132.B2D71C40A88@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="6uRTMvvwH3OpEIWdqbUxIqw3ac3vMg2TU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6uRTMvvwH3OpEIWdqbUxIqw3ac3vMg2TU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/03/14 20:11, Grant Likely wrote:

>>> Any board not using that port can just leave the endpoint disconnecte=
d.
>>
>> Hmm I see. I'm against that.
>>
>> I think the SoC dtsi should not contain endpoint node, or even port no=
de
>> (at least usually). It doesn't know how many endpoints, if any, a
>> particular board has. That part should be up to the board dts.
>=20
> Why? We have established precedence for unused devices still being in
> the tree. I really see no issue with it.

I'm fine with having ports defined in the SoC dtsi. A port is a physical
thing, a group of pins, for example.

But an endpoint is a description of the other end of a link. To me, a
single endpoint makes no sense, there has to be a pair of endpoints. The
board may need 0 to n endpoints, and the SoC dtsi cannot know how many
are needed.

If the SoC dtsi defines a single endpoint for a port, and the board
needs to use two endpoints for that port, it gets really messy: one
endpoint is defined in the SoC dtsi, and used in the board dts. The
second endpoint for the same port needs to be defined separately in the
board file. I.e. something like:

/* the first ep */
&port1_ep {
	remote-endpoint =3D <&..>;
};

&port1 {
	/* the second ep */
	endpoint@2 {
		remote-endpoint =3D <&..>;
	};
};

Versus:

&port1 {
	/* the first ep */
	endpoint@1 {
		remote-endpoint =3D <&..>;
	};

	/* the second ep */
	endpoint@2 {
		remote-endpoint =3D <&..>;
	};
};

 Tomi



--6uRTMvvwH3OpEIWdqbUxIqw3ac3vMg2TU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGuRtAAoJEPo9qoy8lh7167AP/ilCxKAGnrbU20kUjp80barz
/B1MCJJ63fwBxH4V2V012Yp0t6iLyoIhyjvBVxSMQRNIactBq9M9qVWgBmbBPig+
/Zrl4sFqS3q4Qd6hyScfP912xIm2htY9SJRAtmCnpOYj82pUZugUdxq8bGrNTfiJ
7Z5FEmHWD97Oy73+TgqbClOVO2WNtiwvM5xUf3myU7wvgTHWbqttgx82pjzU4j53
f3OnH2DTrXIQvi/SSiOpaGzqzasgDI+I1npLq8YxvDxFpr0ptpHqCZ5dljA5DTQj
/LVe3SNRmRr/gBT9DB7jMmElv74HX/Icx77UvXpJtnVw0TEvJ9EXyKHJFzir+A5Y
qZC2zXJtyOHaYPNQt8ZWvbSuWOSxzvt3rFyNx/KAZmasDDiJhQIz80pqEYfu8zEC
supiuLOzUy1RPpNv09sVAz3fkTcL44T0yQ1PA6YnolvbT1idA9pYUTw5Kz1elv6f
xcFlMwWCUAILfrmwgVXDC+SLpcgs4Pw8hsBWq4f8rhIWk5YROXegpcF6is/C6Jvf
6ETn0z52jv7jvWsI+GugFdXrgLj54TH9vLFxG7nWoHY/UOWhjBdlrbK7YdA2E7+e
ye+tr1qSDRCxtDxAgx/SY6mg3r4Rw+kAbpWPBIztHZBfrXCjD6piZ0EkJxhKca91
B125posKbgD8fQFa+CZT
=szaS
-----END PGP SIGNATURE-----

--6uRTMvvwH3OpEIWdqbUxIqw3ac3vMg2TU--
