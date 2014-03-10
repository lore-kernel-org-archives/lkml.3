Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaCJOKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:10:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50908 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbaCJOKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:10:36 -0400
Message-ID: <531DC7BF.50100@ti.com>
Date: Mon, 10 Mar 2014 16:10:07 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> <5427810.BUKJ3iUXnO@avalon>
In-Reply-To: <5427810.BUKJ3iUXnO@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="M2wNuVGDBvCVlBeVkdB37i56mjMNe1vNL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M2wNuVGDBvCVlBeVkdB37i56mjMNe1vNL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/03/14 15:52, Laurent Pinchart wrote:

> In theory unidirectional links in DT are indeed enough. However, let's =
not=20
> forget the following.
>=20
> - There's no such thing as single start points for graphs. Sure, in som=
e=20
> simple cases the graph will have a single start point, but that's not a=
=20
> generic rule. For instance the camera graphs=20
> http://ideasonboard.org/media/omap3isp.ps and=20
> http://ideasonboard.org/media/eyecam.ps have two camera sensors, and th=
us two=20
> starting points from a data flow point of view. And if you want a bette=
r=20
> understanding of how complex media graphs can become, have a look at=20
> http://ideasonboard.org/media/vsp1.0.pdf (that's a real world example, =
albeit=20
> all connections are internal to the SoC in that particular case, and do=
n't=20
> need to be described in DT).
>=20
> - There's also no such thing as a master device that can just point to =
slave=20
> devices. Once again simple cases exist where that model could work, but=
 real=20
> world examples exist of complex pipelines with dozens of elements all=20
> implemented by a separate IP core and handled by separate drivers, form=
ing a=20
> graph with long chains and branches. We thus need real graph bindings.
>=20
> - Finally, having no backlinks in DT would make the software implementa=
tion=20
> very complex. We need to be able to walk the graph in a generic way wit=
hout=20
> having any of the IP core drivers loaded, and without any specific star=
ting=20
> point. We would thus need to parse the complete DT tree, looking at all=
 nodes=20
> and trying to find out whether they're part of the graph we're trying t=
o walk.=20
> The complexity of the operation would be at best quadratic to the numbe=
r of=20
> nodes in the whole DT and to the number of nodes in the graph.

I did use plural when I said "to give the start points...".

If you have a list of starting points in the DT, a "graph helper" or
something could create a runtime representation of the graph at some
early phase during the boot, which would include backlinks. The
individual drivers could use that runtime graph, instead of the DT graph.=


But it still sounds considerably more complex than double-links in DT.

 Tomi



--M2wNuVGDBvCVlBeVkdB37i56mjMNe1vNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHce/AAoJEPo9qoy8lh71PewP/20a1dCxgwJ6+ws7rkV8pBu9
TeH1KvOa6r1JuEE/O1yAH9CslEs4uoABx9RgCAVxLVIRfTs0usqr9T+PBYYos6kN
k6h8a+36/1+Vx4tAdh6OGwWZJQbrcxiNKZG0Hf/6+oY+ROeMbWScy9SNpuJMoD1o
ycLUYr5uTJSIPCqHjo+qbfI+twotTgbwsqJlCaWcDO2RYj+TV1UlSf6x1Fbfqk/s
rB1JI2GsU4/PY7FUxbRQOpAact9wk5T5PaFfCwEc5VOKze3VIlZSMPL0D796SeYI
/xQhaYG3JRhfqearUtAUaTCDO8/VIY0IkN5oJ6LouBgfHR5WehpoDXRej7buqMYe
HbYomhoFyUPLWjqkMjcSEZw/Cf9tW02pcG0gIylVdjB0SzGuX28t7HiBbYiQH4LT
6N1o8Qb7bVejlB9VPRKxmxF2lGm76Fy0uHjbiF/ZKydVuh/tLCQzuGTQfB+QpM+d
sOOir+0LwwEYqjF9BcFn3YqM5mvIFSJZ+uva4xFBT7J6rOpTZku8zrg5wkEO+1Hc
+HLfI838Pocm9/VY8Kszi0hmxDlWhbaugmxPaEUZIKzOMAEWZu8H9VER7c201cDy
41FmMm1nrlpmQWnMIIScvi6emaLMe1jQCprCmUYYvgsAvaDihoXas0VDpMwTLdyf
Payt9FU7J7N845aIhw5k
=IH95
-----END PGP SIGNATURE-----

--M2wNuVGDBvCVlBeVkdB37i56mjMNe1vNL--
