Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaCEKGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:06:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40753 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaCEKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:06:00 -0500
Message-ID: <5316F6ED.8040204@ti.com>
Date: Wed, 5 Mar 2014 12:05:33 +0200
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
Subject: Re: [PATCH v5 5/7] [media] of: move common endpoint parsing to drivers/of
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>		 <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>		 <531595AB.4000001@ti.com>	 <1393932989.3917.62.camel@paszta.hi.pengutronix.de>	 <5315C535.2070303@ti.com> <1393948056.3917.120.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1393948056.3917.120.camel@paszta.hi.pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mGhrgJ7cfBIaic3fsUhOVhkmVp5XxcGKt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mGhrgJ7cfBIaic3fsUhOVhkmVp5XxcGKt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/03/14 17:47, Philipp Zabel wrote:
> Am Dienstag, den 04.03.2014, 14:21 +0200 schrieb Tomi Valkeinen:
>> On 04/03/14 13:36, Philipp Zabel wrote:
> [...]
>>>> Can port_node be NULL? Probably only if something is quite wrong, bu=
t
>>>> maybe it's safer to return error in that case.
>>>
>>> both of_property_read_u32 and of_node_put can handle port_node =3D=3D=
 NULL.
>>> I'll add a WARN_ONCE here as for of_graph_get_next_endpoint and conti=
nue
>>> on.
>>
>> Isn't it better to return an error?
>=20
> I am not sure. We can still correctly parse the endpoint properties of =
a
> parentless node. All current users ignore the return value anyway. So a=
s
> long as we still do the memset and and set local_node and id, returning=

> an error effectively won't change the current behaviour.

Is the parentless node case an error or not? If it's not, we can handle
it silently and return 0, no WARN needed. If it is an error, we should
return an error, even if nobody is currently handling that (which is a
bug in itself, as the function does return an error value, and callers
should handle it).

 Tomi



--mGhrgJ7cfBIaic3fsUhOVhkmVp5XxcGKt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFvbtAAoJEPo9qoy8lh71GJAP/1MfqyfTObudamAIR8RPgoSq
oFAnftU5j309N99ETx/xmjV2MaMD1heDNFIVcdKQTXFKxGhnhBxUB/JQuoPV4dt8
eayXMhYeiZ9sex+etLBI0eqVTj1PFrxQV4eOnC+zEaIxUgGajk8QFCSxwUww6MQg
oyy3+esFxiL8YkN2aPRKFn+DJoSluwg8pkLTXBhimYdXU5l6u6KIV7eWNRIo+STN
GOXfaBcOKlppKa0i6zqoapaJkxBn8guHWW1nuYU0LLGH/YzfiPLEs6WSGLnk8BgT
VFIA+lCEf977m3iN2VBcQ8wbeeOicAF/pA2pV2BKEH9VBANam/TWsIs6bdvGuKd/
vJwjjomQ6bZG3Exivaz9jCfC2t2ZjPPOO+fAM8Cfn72bbGfEOGyWFv99BxtDwOv8
XWRhsGoXTA0EEcpndY+aV0pm8rF9UKdt4tMrFKoAZX01pCS6lhPZXOlGerrYTvtD
zklwhghP4lR/6byzQLb3bu5dBsKyh0109TdH0fryGj+FKQK8N7HUac9CN2x3V0cq
Wx2aOgbvLNTwg8/bBZpScf9dw8fDhijiyoDclm0nWhig9P15V5SyT+mDvEvo6v72
NJ5ydjeKieF4x5PJJYMVQE43AzuDzugMn+ypqjssHk/c8C3DczB0SUtBymtuGsRg
/pgU6Ag+jOxvnXfPNQGn
=k9h/
-----END PGP SIGNATURE-----

--mGhrgJ7cfBIaic3fsUhOVhkmVp5XxcGKt--
