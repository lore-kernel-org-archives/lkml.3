Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaBLHQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:16:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35080 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:16:22 -0500
Message-ID: <52FB1FA8.2070903@ti.com>
Date: Wed, 12 Feb 2014 09:15:52 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v2] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/media
References: <1392154905-12007-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1392154905-12007-1-git-send-email-p.zabel@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XwJKMSFSVwGLK8GCIkHvqebgFcNOmN8wB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XwJKMSFSVwGLK8GCIkHvqebgFcNOmN8wB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 11/02/14 23:41, Philipp Zabel wrote:
> From: Philipp Zabel <philipp.zabel@gmail.com>
>=20
> This patch moves the parsing helpers used to parse connected graphs
> in the device tree, like the video interface bindings documented in
> Documentation/devicetree/bindings/media/video-interfaces.txt, from
> drivers/media/v4l2-core to drivers/media.
>=20
> This allows to reuse the same parser code from outside the V4L2
> framework, most importantly from display drivers.
> The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
> and v4l2_of_get_remote_port_parent are moved. They are renamed to
> of_graph_get_next_endpoint, of_graph_get_remote_port, and
> of_graph_get_remote_port_parent, respectively.
> Since there are not that many current users, switch all of them
> to the new functions right away.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I don't think the graphs or the parsing code has anything video
specific. It could well be used for anything, whenever there's need to
describe connections between devices which are not handled by the normal
child-parent relationships. So the code could well reside in some
generic place, in my opinion.

Also, I have no problem with having it in drivers/media, but
drivers/video should work also. We already have other, generic, video
related things there like hdmi infoframes and display timings.

And last, it's fine to move the funcs as-is in the first place, but I
think they should be improved a bit before non-v4l2 users use them.
There are a couple of things I tried to accomplish with the omapdss
specific versions in
https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html:

- Iterating ports and endpoints separately. If a node has multiple
ports, I would think that the driver needs to know which port and
endpoint combination is the current one during iteration. It's not
enough to just get the endpoint.

- Simplify cases when there's just one port and one endpoint, in which
case the port node can be omitted from the DT data.

 Tomi



--XwJKMSFSVwGLK8GCIkHvqebgFcNOmN8wB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+x+oAAoJEPo9qoy8lh71uekP/1rhT/v5BSIVHRpWBiwda9+W
yE7AEE8a+tGGyppPa9G/sRYszytnpnl3XY1hzk5oATxwbaIfnZ7Yc6vIincCIMNQ
U/MgoM4SZDq8GkoodXnKfDZOVBzJfG4l0DHpqfVu9Q/+uRBoUUWnQTD5JMmXKEK/
Sne+1aBnUmFy88LyPrnl71sREMrjAyoUBaeM4GXblY/dYfM6OtT7qH4asO3qAoqF
X3GSELUe5upENcGdSkYR1wVxzUBgEaBHHRsUZD0dkbmjmfyMoNF8jmADcCkKOi23
M32s6CAzjqV/OnklYpP8sxezNehLrXR+kJSWeRp3UjcgEEvwbEf1sZNjkzuM8Coh
MP5wVAfgJbWjD5lILHcNipUY47jm6mPC3mriWp2x+YjsBuwN95RdW9AbcjFZmkNi
0PMEWFqxsYCQc4ey2UY+75qdFLCfFLhNiI2pvOOWonJPFHUmIuKY6/mtxi/CZGgd
HFXbrbnqJ5SVDkR3kSIoaG+4yL3+41bk6nmzJtSzxMdlR+OVHjpMzCrhMSXY4AZf
K/WpKbnMuLj2sM993e7cG2lmlKk5klo0LRfoiQGyPDmMzQ2SV1iWxyu3BMKU77e6
MQFqCoKJqJfKjXgYb/E7cgpjVVI7qT34OhmbpS1FIxO/HYKTkGrx1DS3cCs/ObLF
bp2rljxQnWdmBebMF5q8
=6pPK
-----END PGP SIGNATURE-----

--XwJKMSFSVwGLK8GCIkHvqebgFcNOmN8wB--
