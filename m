Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaCFX5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:57:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48801 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaCFX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:57:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 5/7] [media] of: move common endpoint parsing to drivers/of
Date: Fri, 07 Mar 2014 00:59:17 +0100
Message-ID: <22856833.LpWmmzXcxv@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5315C535.2070303@ti.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de> <1393932989.3917.62.camel@paszta.hi.pengutronix.de> <5315C535.2070303@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1412993.9E2XQkZQ0N"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1412993.9E2XQkZQ0N
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Tuesday 04 March 2014 14:21:09 Tomi Valkeinen wrote:
> On 04/03/14 13:36, Philipp Zabel wrote:
> > Am Dienstag, den 04.03.2014, 10:58 +0200 schrieb Tomi Valkeinen:
> > [...]

[snip]

> >> Then, about the get_remote functions: I think there should be only=
 one
> >> function for that purpose, one that returns the device node that
> >> contains the remote endpoint.
> >>=20
> >> My reasoning is that the ports and endpoints, and their contents, =
should
> >> be private to the device. So the only use to get the remote is to =
get
> >> the actual device, to see if it's been probed, or maybe get some v=
ideo
> >> API for that device.
> >=20
> > of_graph_get_remote_port currently is used in the exynos4-is/fimc-i=
s.c
> > v4l2 driver to get the mipi-csi channel id from the remote port, an=
d
> > I've started using it in imx-drm-core.c for two cases:
> > - given an endpoint on the encoder, find the remote port connected =
to
> >   it, get the associated drm_crtc, to obtain its the drm_crtc_mask
> >   for encoder->possible_crtcs.
> >=20
> > - given an encoder and a connected drm_crtc, walk all endpoints to =
find
> >   the remote port associated with the drm_crtc, and then use the lo=
cal
> >   endpoint parent port to determine multiplexer settings.
>=20
> Ok.
>=20
> In omapdss each driver handles only the ports and endpoints defined f=
or
> its device, and they can be considered private to that device. The on=
ly
> reason to look for the remote endpoint is to find the remote device. =
To
> me the omapdss model makes sense, and feels logical and sane =3D). So=
 I
> have to say I'm not really familiar with the model you're using.

I agree with you that most of the content of the remote endpoint should=
 be=20
considered private to the remote device and not accessed by the local d=
evice=20
driver. There is, however, one piece of information from the remote end=
point=20
useful to the local device driver, it's the remote port identifier. Thi=
s can=20
be expressed by a phandle, a remote port number, a media entity pad poi=
nter,=20
or any other mean, but the information is useful for the local device d=
river=20
to communicate with the remote device driver. For instance a driver cou=
ld use=20
it to ask its video stream source to start the video stream on a given =
port.

> Of course, the different get_remove_* funcs do no harm, even if we ha=
ve
> a bunch of them. My point was only about enforcing the correct use of=

> the model, where "correct" is of course subjective =3D).

=2D-=20
Regards,

Laurent Pinchart

--nextPart1412993.9E2XQkZQ0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTGQvaAAoJEIkPb2GL7hl1nsgH/iaADjsddE23C9P/qi8ml19s
qEum6GLOg4wMHC1lwi3C9R7Vrg/J7CmfBX+BpXlkNv8O12vndoFI9AernLmn0e4l
9gWuA9B4u3j3Pd9jI++EbhTiz/W3u01uwBI3xfv4WogeDWwCxy6B7iih4S298fVq
c61CZbwNObSUZ7Y1U09W0JP8cGI1A3d2GJc1eILl9FcVrXAWAhYU+mwLRoVOp2bl
Pv0AYPaIXrUsF8CaFbT7Lq6EwMwgEMhFH5L7tSrbvVxf8azb5bESBNPDEK8cpEup
WygjooyLx6Lxkq49rHvn/CHKv+0qP4kMXa2yxUUEVEur1abCGxftMp6qAQ5UlV4=
=LqjR
-----END PGP SIGNATURE-----

--nextPart1412993.9E2XQkZQ0N--

