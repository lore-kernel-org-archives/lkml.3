Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaCJGf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:35:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33735 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCJGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:35:24 -0400
Message-ID: <531D5D0E.8000605@ti.com>
Date: Mon, 10 Mar 2014 08:34:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de> <20140226113729. A9D5AC40A89@trevor.secretlab.ca> <1393428297.3248.92.camel@paszta.hi. pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <531AF4ED. 5020608@ti.com> <20140308122321.9D433C40612@trevor.secretlab.ca>
In-Reply-To: <20140308122321.9D433C40612@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="geFLiFodre9MAPFuUJV74UQT9Qala7crh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--geFLiFodre9MAPFuUJV74UQT9Qala7crh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/14 14:23, Grant Likely wrote:

>>> That's fine. In that case the driver would specifically require the
>>> endpoint to be that one node.... although the above looks a little we=
ird
>>
>> The driver can't require that. It's up to the board designer to decide=

>> how many endpoints are used. A driver may say that it has a single inp=
ut
>> port. But the number of endpoints for that port is up to the use case.=

>=20
> Come now, when you're writing a driver you know if it will ever be
> possible to have more than one port. If that is the case then the
> binding should be specifically laid out for that. If there will never b=
e
> multiple ports and the binding is unambiguous, then, and only then,
> should the shortcut be used, and only the shortcut should be accepted.

I was talking about endpoints, not ports. There's no unclarity about the
number of ports, that comes directly from the hardware for that specific
component. The number of endpoints, however, come from the board
hardware. The driver writer cannot know that.

>>> to me. I would recommend that if there are other non-port child nodes=

>>> then the ports should still be encapsulated by a ports node.  The dev=
ice
>>> binding should not be ambiguous about which nodes are ports.
>>
>> Hmm, ambiguous in what way?
>=20
> Parsing the binding now consists of a ladder of 'ifs' that gives three
> distinct different behaviours for no benefit. You don't want that in

It considerably lessens the amount of text in the DT for many use cases,
making it easier to write and maintain the dts files.

> bindings because it makes it more difficult to get the parsing right in=

> the first place, and to make sure that all users parse it in the same
> way (Linux, U-Boot, BSD, etc). Bindings should be as absolutely simple
> as possible.

Well, yes, I agree there. This is not the simplest of bindings. I'd be
more than happy if we would come up with simpler version of this, which
would still allow us to have the same descriptive power.

> Just to be clear, I have no problem with having the option in the
> pattern, but the driver needs to be specific about what layout it
> expects.

If we forget the shortened endpoint format, I think it can be quite
specific.

A device has either one port, in which case it should require the
'ports' node to be omitted, or the device has more than one port, in
which case it should require 'ports' node.

Note that the original v4l2 binding doc says that 'ports' is always
optional.

 Tomi



--geFLiFodre9MAPFuUJV74UQT9Qala7crh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHV0OAAoJEPo9qoy8lh71HDgQAKM2fQOi/eKLuN2FOb5ogNqK
I4aWC5M4WkeBaba5U2g0lPESu2g0x9hrOvWQOFgd/GpKctRZI1DmB4Rc+rSAv/UN
0Cbzm+KB+RnGNfjaHmEzBNQDcv+a20I/jCLDWOcwJIm5kSW2gByBXSdsyXHuJpYP
uMbbZa3Yql1+FF3Y+5FIf5NpFpVlrXI2tMTPHZw/5gAwFSe2laFIcBslRAsz8wwL
4n3CkpJayQJSUG26wNsIdJnceCZ+QHEAWSSYXxyQCZ4rDG2x6+czUX4Dq3Jd46V+
F6Hx2tuQIBZZsiZVLVDbCJvnAcT60WwvA0F8Vzd5FCl+Mn8GA4GXXot22HhBLHd2
roUaSbMtd1iV51AfEw9d1St/QRKD0aiVL6xabAtSHvBUIuk2ICFUoOviG82Rl0cS
JtNVcCjbE9Q/mXxoiXWDgyGVbaFjKU5e6CxiBT6Xf6zJOV5w6NRgw3IsC8ITLe+F
RdSLKYCCr1+u31njpuZ37jST+MtkNr1UI9ocCQHT1SncYDFrHNbxabTfwN/f77S0
gDADeDi6Y5LKlv8tnZLXp70gQuY/+BJonvyIDZkLMcUv/0n9771yWD0IFPtYl1kK
bByZnSSuPPAy8zkwRRr2AOybasaLQ7xtVm/qouS+ydoAq3Rx8z/TZxVbJUDGMbik
pbR/OIiW3ZDUpIjWk2+d
=2Hm0
-----END PGP SIGNATURE-----

--geFLiFodre9MAPFuUJV74UQT9Qala7crh--
