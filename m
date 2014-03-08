Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaCHKrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:47:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48643 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaCHKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:46:57 -0500
Message-ID: <531AF4ED.5020608@ti.com>
Date: Sat, 8 Mar 2014 12:46:05 +0200
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
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de> <20140226113729. A9D5AC40A89@trevor.secretlab.ca> <1393428297.3248.92.camel@paszta.hi. pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca>
In-Reply-To: <20140307171804.EF245C40A32@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="KDhiUnuuxVHKONxw4jlm14R4d5nVQ8tXr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KDhiUnuuxVHKONxw4jlm14R4d5nVQ8tXr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/03/14 19:18, Grant Likely wrote:

> From a pattern perspective I have no problem with that.... From an
> individual driver binding perspective that is just dumb! It's fine for
> the ports node to be optional, but an individual driver using the
> binding should be explicit about which it will accept. Please use eithe=
r
> a flag or a separate wrapper so that the driver can select the
> behaviour.

Why is that? The meaning of the DT data stays the same, regardless of
the existence of the 'ports' node. The driver uses the graph helpers to
parse the port/endpoint data, so individual drivers don't even have to
care about the format used.

As I see it, the graph helpers should allow the drivers to iterate the
ports and the endpoints for a port. These should work the same way, no
matter which abbreviated format is used in the dts.

>> The helper should find the two endpoints in both cases.
>> Tomi suggests an even more compact form for devices with just one port=
:
>>
>> 	device {
>> 		endpoint { ... };
>>
>> 		some-other-child { ... };
>> 	};
>=20
> That's fine. In that case the driver would specifically require the
> endpoint to be that one node.... although the above looks a little weir=
d

The driver can't require that. It's up to the board designer to decide
how many endpoints are used. A driver may say that it has a single input
port. But the number of endpoints for that port is up to the use case.

> to me. I would recommend that if there are other non-port child nodes
> then the ports should still be encapsulated by a ports node.  The devic=
e
> binding should not be ambiguous about which nodes are ports.

Hmm, ambiguous in what way?

If the dts uses 'ports' node, all the ports and endpoints are inside
that 'ports' node. If there is no 'ports' node, there may be one or more
'port' nodes, which then contain endpoints. If there are no 'port'
nodes, there may be a single 'endpoint' node.

True, there are many "if"s there. But I don't think it's ambiguous. The
reason we have these abbreviations is that the full 'ports' node is not
needed that often, and it is rather verbose. In almost all the use
cases, panels and connectors can use the single endpoint format.

 Tomi



--KDhiUnuuxVHKONxw4jlm14R4d5nVQ8tXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGvTtAAoJEPo9qoy8lh71DkoQAI9olG4IKoXnS42j7svHIReP
4XREe5aFwEpxNbzJYEhCEEHFmVd3GhngyZbxGIo0eQAknNbzIEHOIKwHzh5QGQWj
3efXba0KDGgTOiog/3KZE5eRNkw/5wBbarUvf11eBv6VPT68hf2S+YeiP3A8/oxl
QEJZYDjUMPFN2L6hL2jcFFqgEaOQL+swJHw/MVroG9kvZlnIvMCfoE4rW5ml6t6I
WukH8z+kVV05KrZwD96y31Rw6dHEEYIxvrOH+n9MK5n7ZHBVnrTZd1LdIRcb/PYP
yVEZAf7wzyKUtizJDx3jr8e0k9bPQp0wmdcOy82SVt/96Di7YFYOmtG41z477mSY
Gyo4t1NKyeZ/ouIsKoQsgWaTwtPuz/k3L97dFqaTkFVvj1HNrJVA0pYMONHEA1d4
xFcL9CQZGSoeVIIGDN/40klKZeAcE8jim5Duhb4/E205LVibchKUwZAivfJeFY0W
6apfXGb1unJUbg4ODUVsPblV1goDhyhVQcC28XX6k8kAD/m37Luq0uDwX6rdVOMT
zL3K+kOLbq29ykU5IlNsoNS+Tyu1NKILplkYy2DStN88Yu5LH25ksGqBevOlqHeR
8UHy2bTzq7SHCvmDzSn3SRfzxpF7OIdMVBxWpdCiT+sX94QPoEPSP56g+IFYoGFR
NollNDhACsHpUTT8vDES
=NrAG
-----END PGP SIGNATURE-----

--KDhiUnuuxVHKONxw4jlm14R4d5nVQ8tXr--
