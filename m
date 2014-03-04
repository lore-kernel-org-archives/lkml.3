Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaCDJHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:07:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53575 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbaCDJGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:06:53 -0500
Message-ID: <53159791.5080205@ti.com>
Date: Tue, 4 Mar 2014 11:06:25 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 6/7] of: Implement simplified graph binding for single
 port devices
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de> <1393522540-22887-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393522540-22887-7-git-send-email-p.zabel@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="B16kFDpUQI20mJFiGkPvPK6AL8dL5J5xT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B16kFDpUQI20mJFiGkPvPK6AL8dL5J5xT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/02/14 19:35, Philipp Zabel wrote:
> For simple devices with only one port, it can be made implicit.
> The endpoint node can be a direct child of the device node.

<snip>

> @@ -2105,9 +2112,11 @@ struct device_node *of_graph_get_remote_port_par=
ent(
>  	/* Get remote endpoint node. */
>  	np =3D of_parse_phandle(node, "remote-endpoint", 0);
> =20
> -	/* Walk 3 levels up only if there is 'ports' node. */
> +	/* Walk 3 levels up only if there is 'ports' node */
>  	for (depth =3D 3; depth && np; depth--) {
>  		np =3D of_get_next_parent(np);
> +		if (depth =3D=3D 3 && of_node_cmp(np->name, "port"))
> +			break;
>  		if (depth =3D=3D 2 && of_node_cmp(np->name, "ports"))
>  			break;
>  	}

This function becomes a bit funny. Would it be clearer just to do
something like:

	np =3D of_parse_phandle(node, "remote-endpoint", 0);

	np =3D of_get_next_parent(np);
	if (of_node_cmp(np->name, "port") !=3D 0)
		return np;

	np =3D of_get_next_parent(np);
	if (of_node_cmp(np->name, "ports") !=3D 0)
		return np;

	np =3D of_get_next_parent(np);
	return np;

 Tomi



--B16kFDpUQI20mJFiGkPvPK6AL8dL5J5xT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFZeRAAoJEPo9qoy8lh71T28QAK4N+uuEXW2aa2QA8W0r8A23
LrKYuswYS70LIpa7Hu3+cbU6WJEtG3tRMGLwiiQ4O6iB64XASbkqKWRY9S20Rg3d
q6eyIg8dKfRDVcGUPWg4hFPNQuU956eC1jryyRR4kmkppreaJ+hftIn9+QggDwex
pjY3CVZmUDtvjRuN5Jooxnl1Q00rYNzHA9fuUIRs9uvdzVmlIC0X30N4heaoL8vL
t6v83Iz2+PoMj6jIc68iL+esb0WHI2z3tlxaYHjAfR/1bM15j5W9LjIhByG3YuBO
HCXwQA+ByUvL4vdH6Ghs0XtmLYuiKnciFVCv60a+SZ2jg4RYUa6axEOsdWm+iHiY
QRkKYm3iGPlf8lCrXOt6vitQFvixKVn6Kt7cqdIgq5GKwUp4zNQjfZ8LiDutavFD
WfqSRNuh8MCoFNFhNpu6itRiEn0rSR3Lz1//6+yprDQjFor4yTL2wP43mo7mdhwH
cZmHJ2YhFDZ0Bl6Yg5NGjC1Dz6ErpVr8KfKYQaBBdrZeb5jjQJJeo94EzkylqJJc
L38uhl/xPEXuPcFDSpQj32GJRkjYVkHRQ4OQ9x+Nn4GVJj65nj94pdo1Aa2b150n
nMLTFuWM9fPNFP4YVmbZ8Gf+gtf08fZP0W/sbeB7SaYYofBLY2zEj+Ba+dfcUSAa
MuIDLuJKjOrIFi4BiBc/
=70wJ
-----END PGP SIGNATURE-----

--B16kFDpUQI20mJFiGkPvPK6AL8dL5J5xT--
