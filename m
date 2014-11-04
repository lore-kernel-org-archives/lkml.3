Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaKDT6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:58:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37855 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:58:05 -0500
Date: Tue, 4 Nov 2014 19:56:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Hugh Kang <hugh.kang@lge.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com
Message-ID: <20141104195640.GW3815@sirena.org.uk>
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
 <20141103120313.GC3815@sirena.org.uk>
 <54588C3B.9070605@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eBmxOkhHhLj/unod"
Content-Disposition: inline
In-Reply-To: <54588C3B.9070605@lge.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: adding disable options for
 regulator-always-on and regulator-boots-on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eBmxOkhHhLj/unod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 05:20:11PM +0900, Hugh Kang wrote:

Please fix your mailer to word wrap within paragraphs.

> I understand that I could make Rev.B with b.dtsi due to LDOs option is
> different. However, aim to use device tree is that making easy steps.
> Refer to dts option, if you set to be set status disabled option, the
> driver dose not probe when the system boot up. Even though, the system
> has different board revision exist. So dts have to be no corrupts any
> overlap situation.

Right, nothing is going to be perfect but equally if we use this sort of
override property to do things it then becomes harder to read the DT for
the system since you can't trust that a property you see in one file
won't be overridden by another file somewhere else.  This can happen to
an extent already but normally not and it doesn't seem like a pattern we
want to encourage.

> I have mentions the simple example to change only one LDOs. However,
> if someone want to edit many regulators with similar configuration, he
> has to do lots of copy and paste works. Because he has to create new
> dts file. So I would suggest to make it as simple as I could.

Sure, but that's purely mechanical and very easy to review - you can do
a code motion patch to split the bits of DT out then start changing
things, and you can still keep the common paramters in the core file.

> Also, I have somehow agree with you that affects any boolean property in the DT.

This is a big one for me - it's going to be both time consuming and
complex to add this sort of thing for more properties and we do get
into complexity things if each individual property and its override
has to be handled by hand.

--eBmxOkhHhLj/unod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWS94AAoJECTWi3JdVIfQwk8H/Ri+sgwksQbPCjqAY6FJ66j3
SUObynJBz7kjp/ctxKjfuwJVmFKzOI6vYWNzNmXEd2MA9PWl0d4dIE/CdthRMvWq
T6FhiEgQugtpQia5Fg4KEn/+T4ECm6SeRJZLoEY9ljReH3QUVPlvVix/cFswUGdd
WKgTefGi3rsLCiXOtiI8RClY6rkv6TMwvplG2ZGwFnIc2uAvutIPP5CIBpkpEnRw
HnXNVl4vFmkIMOBwcsjy57n03EGG/7DXg4Nd1Wj0HIQHROr1DkTMI/CyAY0py1y1
fxv+n0Ytv5oj76XAxFuXw1CkVPdWxiKRB8yl6XvRsVKykwiBq7o+0n7Plmxg9ZI=
=oaEm
-----END PGP SIGNATURE-----

--eBmxOkhHhLj/unod--
