Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbaEMJWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:22:10 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49525 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089AbaEMJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:22:05 -0400
Date: Tue, 13 May 2014 11:20:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 0/2] drm/panel: add simple-panel description using DT
Message-ID: <20140513092002.GN6754@ulmo>
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140513075148.GF6754@ulmo>
 <5371E12C.8000409@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FX+Db2fp7WJhXKrW"
Content-Disposition: inline
In-Reply-To: <5371E12C.8000409@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FX+Db2fp7WJhXKrW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 11:09:00AM +0200, Andrzej Hajda wrote:
> On 05/13/2014 09:51 AM, Thierry Reding wrote:
> > On Fri, May 09, 2014 at 04:16:40PM +0200, Boris BREZILLON wrote:
> >> Hello Thierry,
> >>
> >> I noticed you're describing each new panel with a new entry in the
> >> of_platform_match table and a new compatible string.
> >> I guess you have a good reason to do it this way, because retrieving
> >> panel description from DT would be pretty easy (see this series ;-)).
> >>
> >> Could tell me why you chose this approach ?
> >=20
> > The reason is that devicetree mandates that a device be identified using
> > a compatible value and that compatible value should be as specific as
> > possible. That compatible value should give the device driver enough
> > information to know everything it needs (resolution, timings, physical
> > dimension).
> >=20
> > Having all of that data in the device tree is redundant.
> >=20
>=20
> Many panels I have encountered have no single timings, they accepts
> ranges of timings. With 'compatible' approach there is no place to
> configure timings specific for particular hw configuration, unless you
> abuse somehow compatible string.
>=20
> However it seems there are not so many cases the same panel must be used
> with different timings on different boards, anyway it is a potential issu=
e.

Right. I think it makes sense, and I've said so in the past, to add
support for overriding the default timings specified by the driver using
a display-timings node in DT. But that should be reserved as a means to
override the timings if that's required on some specific configuration,
not abused as a means to add support for new panels altogether.

Note that there's also the possibility to use the drm_crtc_helper_funcs'
=2Emode_fixup() to adjust a mode's timings if the display hardware doesn't
support the mode as-is.

Thierry

--FX+Db2fp7WJhXKrW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcePCAAoJEN0jrNd/PrOhQuMQALQEUYTBHANgi/D/RaReySGd
JOGKjlFyqYj20Hg9ph/3DKKnzDrrHkGFmiAeS5ZS8OQxh6jOc5zePI2C4Ci+471y
cQ8pR+8f9666bAjZZ+gAzNjb5gaDg955CdyzNB5dp4yf0H8iot4pphTVuBg9zhsG
bhN1cjRherNKl5PPA2X8ltyAJTvAxLzpKQv/ZSa0HNaKqg7folIhqrLHizsuM4C9
4j7OMNaIrNySW2aD7LS47/Os+5pBxamL/3s48bBpSH5fqVEUw0N5NtVXgpAXfRIU
bfzpOMiHacG771HQF5jqdWMAFgn79vQgrRO3jxX1ter+255iC1n8uhdhCALOM0cG
AQPczwbHdvv1sBmuskNQbFJr9UqMrjzLQTn5aUWg2qK1dMkDwjZK4yX1vYKKVhDb
YGSjTojUE8IUvPj3irHn6TbHdygYjUr8y5htzsoQ2LZdHmlmwA83fi2Z7nJ67fzX
FySQZcyyEswHmK5Nz7zgSDSYafdnCtANhN2w29KoApG0A1XhOznmKx4N1REzAzf5
hNZ6Yxi8WKsaKmTts5J+/7PFWoPwSZeu7KMOIfgWjOk3kLwvHhwyHaI0H/hldjVd
hLVtb8mwYpx/mVo8+EuQDv1otsO2ZehwINQV09NGTm22q71JhGHZpXiy/ynIofGV
LtaDjq/CwMfxH1mHTBj+
=G4ma
-----END PGP SIGNATURE-----

--FX+Db2fp7WJhXKrW--
