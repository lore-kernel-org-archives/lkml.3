Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaBZOvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:51:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37890 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaBZOvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:51:16 -0500
Message-ID: <530DFF4C.8080807@ti.com>
Date: Wed, 26 Feb 2014 16:50:52 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>	 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>	 <530DE8A9.9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="tEHsptXr4FFpWcoGvwDA40KVVAmjgkgcU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tEHsptXr4FFpWcoGvwDA40KVVAmjgkgcU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26/02/14 16:57, Philipp Zabel wrote:
> Hi Tomi,
>=20
> Am Mittwoch, den 26.02.2014, 15:14 +0200 schrieb Tomi Valkeinen:
>> On 25/02/14 16:58, Philipp Zabel wrote:
>>
>>> +Optional endpoint properties
>>> +----------------------------
>>> +
>>> +- remote-endpoint: phandle to an 'endpoint' subnode of a remote devi=
ce node.
>>
>> Why is that optional? What use is an endpoint, if it's not connected t=
o
>> something?
>=20
> This allows to include the an empty endpoint template in a SoC dtsi for=

> the convenience of board dts writers. Also, the same property is
> currently listed as optional in video-interfaces.txt.
>=20
>   soc.dtsi:
> 	display-controller {
> 		port {
> 			disp0: endpoint { };
> 		};
> 	};
>=20
>   board.dts:
> 	#include "soc.dtsi"
> 	&disp0 {
> 		remote-endpoint =3D <&panel_input>;
> 	};
> 	panel {
> 		port {
> 			panel_in: endpoint {
> 				remote-endpoint =3D <&disp0>;
> 			};
> 		};
> 	};
>=20
> Any board not using that port can just leave the endpoint disconnected.=


Hmm I see. I'm against that.

I think the SoC dtsi should not contain endpoint node, or even port node
(at least usually). It doesn't know how many endpoints, if any, a
particular board has. That part should be up to the board dts.

I've done this with OMAP as (much simplified):

SoC.dtsi:

dss: dss@58000000 {
	status =3D "disabled";
};

Nothing else (relevant here). The binding documentation states that dss
has one port, and information what data is needed for the port and endpoi=
nt.

board.dts:

&dss {
        status =3D "ok";

        pinctrl-names =3D "default";
        pinctrl-0 =3D <&dss_dpi_pins>;

        dpi_out: endpoint {

                remote-endpoint =3D <&tfp410_in>;
                data-lines =3D <24>;
        };
};

That's using the shortened version without port node.

Of course, it's up to the developer how his dts looks like. But to me it
makes sense to require the remote-endpoint property, as the endpoint, or
even the port, doesn't make much sense if there's nothing to connect to.

 Tomi



--tEHsptXr4FFpWcoGvwDA40KVVAmjgkgcU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDf9MAAoJEPo9qoy8lh71JaAQAJbPz+9VpNn17W+xOl/uxT2m
7yfxwYtwoVzI3GP5CHS110ALyJh9cFQ0R/p2QEGESO1l/03gIVteCdypHUdzQDhT
gVa7ALqhf5XrN7FneCWD4liAS1kh9vjT77p66RTKHDjH6NjSKDgPlKotUEkwasRC
Bx1DwbEQ+6W92TyCp40rNK60buMvJr1yerA9WuPFz/nlynBvB742rYd+xBKS89oR
kFq0ZzAeXeKrUxQ4kCk4o/Jlj+GW0QVwQiI4973m5/wfHAHVkxJ7yWD/CLRKHB0e
82OHiHkyOBD6srbsbVGdZBSk/cdYFvpMPCBxyL1hFTWaaZ076sCDozU1RGBPyi8k
41ERnfKWfz70aDwWo6EpG0kXDBSygwZHi20aMNi4gNQQwAHarO6zgZGGsZfyc3Z6
pGomVCRZ4tpcEHyFmCUVm6NrocNFL9p3utQVOECC1VeLhT/Nbxaj96LKsFpBcd/d
4yQjBPhtN22wgmT7maLOPqveUFvVItDLVWGoUeH2w5rOBzEnnTxDzzwV3R27fKvf
T7NVF9xFTJnzt+NJChwrlTBgNTSMRThWf8YjmfWAJmk9V83esYHNo65m2DBCOcJE
p7FiQOrG3pcrUUJD8HI98H0mEfLp52UB8kdLedJxI0NHCdO5HBHVge2M5sn3MPXT
X+MSBcHoIVzFTpb6tGBZ
=KzUA
-----END PGP SIGNATURE-----

--tEHsptXr4FFpWcoGvwDA40KVVAmjgkgcU--
