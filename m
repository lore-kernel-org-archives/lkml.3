Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaCJNvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:51:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45687 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaCJNvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:51:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
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
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Mon, 10 Mar 2014 14:52:53 +0100
Message-ID: <5427810.BUKJ3iUXnO@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531D916C.2010903@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1520917.HHuWypULl8"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1520917.HHuWypULl8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Monday 10 March 2014 12:18:20 Tomi Valkeinen wrote:
> On 08/03/14 13:41, Grant Likely wrote:
> >> Ok. If we go for single directional link, the question is then: wh=
ich
> >> way? And is the direction different for display and camera, which =
are
> >> kind of reflections of each other?
> >=20
> > In general I would recommend choosing whichever device you would
> > sensibly think of as a master. In the camera case I would choose th=
e
> > camera controller node instead of the camera itself, and in the dis=
play
> > case I would choose the display controller instead of the panel. Th=
e
> > binding author needs to choose what she things makes the most sense=
, but
> > drivers can still use if it it turns out to be 'backwards'
>=20
> I would perhaps choose the same approach, but at the same time I thin=
k
> it's all but clear. The display controller doesn't control the panel =
any
> more than a DMA controller controls, say, the display controller.
>=20
> In fact, in earlier versions of OMAP DSS DT support I had a simpler p=
ort
> description, and in that I had the panel as the master (i.e. link fro=
m
> panel to dispc) because the panel driver uses the display controller'=
s
> features to provide the panel device a data stream.
>=20
> And even with the current OMAP DSS DT version, which uses the v4l2 st=
yle
> ports/endpoints, the driver model is still the same, and only links
> towards upstream are used.
>=20
> So one reason I'm happy with the dual-linking is that I can easily
> follow the links from the downstream entities to upstream entities, a=
nd
> other people, who have different driver model, can easily do the oppo=
site.
>=20
> But I agree that single-linking is enough and this can be handled at
> runtime, even if it makes the code more complex. And perhaps requires=

> extra data in the dts, to give the start points for the graph.

In theory unidirectional links in DT are indeed enough. However, let's =
not=20
forget the following.

=2D There's no such thing as single start points for graphs. Sure, in som=
e=20
simple cases the graph will have a single start point, but that's not a=
=20
generic rule. For instance the camera graphs=20
http://ideasonboard.org/media/omap3isp.ps and=20
http://ideasonboard.org/media/eyecam.ps have two camera sensors, and th=
us two=20
starting points from a data flow point of view. And if you want a bette=
r=20
understanding of how complex media graphs can become, have a look at=20=

http://ideasonboard.org/media/vsp1.0.pdf (that's a real world example, =
albeit=20
all connections are internal to the SoC in that particular case, and do=
n't=20
need to be described in DT).

=2D There's also no such thing as a master device that can just point to =
slave=20
devices. Once again simple cases exist where that model could work, but=
 real=20
world examples exist of complex pipelines with dozens of elements all=20=

implemented by a separate IP core and handled by separate drivers, form=
ing a=20
graph with long chains and branches. We thus need real graph bindings.

=2D Finally, having no backlinks in DT would make the software implementa=
tion=20
very complex. We need to be able to walk the graph in a generic way wit=
hout=20
having any of the IP core drivers loaded, and without any specific star=
ting=20
point. We would thus need to parse the complete DT tree, looking at all=
 nodes=20
and trying to find out whether they're part of the graph we're trying t=
o walk.=20
The complexity of the operation would be at best quadratic to the numbe=
r of=20
nodes in the whole DT and to the number of nodes in the graph.

=2D-=20
Regards,

Laurent Pinchart

--nextPart1520917.HHuWypULl8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTHcPIAAoJEIkPb2GL7hl1NwIH/0jAMqoq8tnlI9u2jNOpHVnJ
mIemnuuJNIaQXS75/cyhKjSkf2ib6SHffCqEhIiJjc/rG/iqvF462XBx1035iFep
46OrLdQsAxo8/7zEsCnmHA/sXh0klG1kZLetDVQ2/Ilcqv8jMoyNsXLXNZ5wzwa5
/YN6bLU5Q7eh7Wr7WrfP9iamQrV9Wczq/VCzxGhAyWkUCLYQvNSeV1i4yAH5t7pQ
CUvtTB9D4TORRbTDMAX7X6XjmMGFFtWFkWb9+LLvPMgKF4NxlNaFJZaXitVlwvrR
9i1o1pvBoyG6P2D04/+xePpg/afGNmtR6R0KAOwwXgs+6WYMcVfA7NccNsQtHHw=
=1JpX
-----END PGP SIGNATURE-----

--nextPart1520917.HHuWypULl8--

