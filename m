Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaCKNPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:15:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52976 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaCKNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:15:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
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
Date: Tue, 11 Mar 2014 14:16:37 +0100
Message-ID: <1883687.VdfitvQEN3@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531F08A8.300@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1520312.nzqQsCAHx5"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1520312.nzqQsCAHx5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Tuesday 11 March 2014 14:59:20 Tomi Valkeinen wrote:
> On 11/03/14 13:43, Laurent Pinchart wrote:
> >> We could scan the whole tree for entities, ports and endpoints onc=
e, in
> >> the base oftree code, and put that into a graph structure, adding =
the
> >> backlinks. The of_graph_* helpers could then use that graph instea=
d of
> >> the device tree.
> >=20
> > That could work. The complexity would still be quadratic, but we wo=
uld
> > parse the full device tree once only.
> >=20
> > The runtime complexity would still be increased, as the graph helpe=
rs
> > would need to find the endpoint object in the parsed graph correspo=
nding
> > to the DT node they get as an argument. That's proportional to the =
number
> > of graph elements, not the total number of DT nodes, so I suppose i=
t's not
> > too bad.
> >=20
> > We also need to make sure this would work with insertion of DT frag=
ments
> > at runtime. Probably not a big deal, but it has to be kept in mind.=

>=20
> About the endpoint linking direction... As I think was suggested, the=

> base logic would be to make endpoints point "outward" from the SoC, i=
.e.
> a display controller would point to a panel, and a capture controller=

> would point to a sensor.
>
> But how about this case:
>=20
> I have a simple video pipeline with a display controller, an encoder =
and
> a panel, as follows:
>=20
> dispc -> encoder -> panel
>=20
> Here the arrows show which way the remote-endpoint links point. So
> looking at the encoder, the encoder's input port is pointed at by the=

> dispc, and the encoder's output port points at the panel.
>=20
> Then, I have a capture pipeline, with a capture controller, an encode=
r
> (the same one that was used for display above) and a sensor, as follo=
ws:
>=20
> camc -> encoder -> sensor
>=20
> Again the arrows show the links. Note that here the encoder's _output=
_
> port is pointed at by the camc, and the encoder's _input_ port points=
 at
> the sensor.
>=20
> So depending on the use case, the endpoints would point to opposite
> direction from the encoder's point of view.
>=20
> And if I gathered Grant's opinion correctly (correct me if I'm wrong)=
,
> he thinks things should be explicit, i.e. the bindings for, say, an
> encoder should state that the encoder's output endpoint _must_ contai=
n a
> remote-endpoint property, whereas the encoder's input endpoint _must
> not_ contain a remote-endpoint property.

Actually my understand was that DT links would have the same direction =
as the=20
data flow. There would be no ambiguity in that case as the direction of=
 the=20
data flow is known. What happens for bidirectional data flows still nee=
d to be=20
discussed though. And if we want to use the of-graph bindings to descri=
be=20
graphs without a data flow, a decision will need to be taken there too.=


=2D-=20
Regards,

Laurent Pinchart

--nextPart1520312.nzqQsCAHx5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTHwzCAAoJEIkPb2GL7hl1cPsH/2lo/WyYziaiB9oJ1QluxzHG
nMIZNmfOqHT4KCnwuJVKJyr6KrjBOhpcKo5ZPxOHHfq79jYckbb1dzisu+CUCOEo
QiP5CeqNGKAkUKrcb1joHoKOKd6ArkZl5yuhPq6+5NvYVmoDC3lfj/GsxMtuUgn7
fQhzShuiFFOzgivrhBe1+S0vaVwxOrSQMpAnDxW90zuG8sb4ObfR00SI7OPKUhmH
gDWJF6pTNy4o0u5BcXxVNIaxyniZzK0F9/XeVsXSyHqW4qzslZSwlgpRWYcCMdgM
2B/kcjknjoJs10cV7DPEyUq2Q1CvDXyTgF5UGE8LwE2uffR89N2NKn0bhP5bE5w=
=jVcg
-----END PGP SIGNATURE-----

--nextPart1520312.nzqQsCAHx5--

