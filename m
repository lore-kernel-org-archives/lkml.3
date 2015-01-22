Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbbAVT0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:26:54 -0500
Received: from sauhun.de ([89.238.76.85]:42259 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbbAVT0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:26:53 -0500
Date: Thu, 22 Jan 2015 20:26:49 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Korsgaard <peter@korsgaard.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-ocores: add common clock support
Message-ID: <20150122192649.GC14880@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
 <20150122144522.GF3413@katana>
 <CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
 <20150122150717.GJ3413@katana>
 <87wq4e7jqy.fsf@dell.be.48ers.dk>
 <20150122185711.GA14880@katana>
 <CAMo8BfJdmB-=i4bJypHzGvegxgBPafpiT_hyQXLhvzBUmE+u_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <CAMo8BfJdmB-=i4bJypHzGvegxgBPafpiT_hyQXLhvzBUmE+u_g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 10:15:40PM +0300, Max Filippov wrote:
> On Thu, Jan 22, 2015 at 9:57 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > My suggestion is:
> >
> > 1) if there is a clk node:
> >         - we get the clock rate via clock framework
> >         - "clock-frequency" is describing the bus speed as usual (Note
> >           that parsing here can be as simple as checking for 100kHz onl=
y.
> >           Although a seperate patch could probably easily add support f=
or
> >           other bus speeds to)
> >
> > 2?) a new binding is present to specify the IP clock speed:
> >         - is this needed? is somebody using the driver without CCF?
> >         - if so, the new binding is parsed and evaluated
> >         - I couldn't find an existing binding to specify a clock speed.
> >           Please have a look, too. Otherwise we need to introduce sth
> >           like "opencores,ip-clock-khz" probably.
> >         - "clock-frequency" is describing the bus speed as usual
> >
> > 3) only "clock-frequency" is present:
> >         - we keep the current behaviour to be backwards compatible.
> >         - driver should emit a warning to convert to new style
> >         - must be marked deprecated everywhere
> >
> > The documentation should be updated accordingly.
> >
> > Thoughts?
>=20
> I can update my patch to do (1) and (3), leaving (2) to whoever may
> need that.

Please implement (2) as well. Otherwise we would have documented
ambiguity of "clock-frequency" which is bad. It shouldn't be much code.


--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwU75AAoJEBQN5MwUoCm2YSEP/0+OtiHzZ8wLDMqNOkEYeilU
lv7QPWnrmJzyi4eUr47zsNJWJnUPOOdvJZ+SrU8EJcTArJpM2dPyqLOTq4+e7kXf
ZiyBsO5hhY1zOLPmoyw6pUZOz8q4G7kSVNVJRJNPFShLkyPxn1MuUu29i307Z+UM
KrdkAOKumWHLjgqFS3tzvEYZgD1h0yZduprR3BVbi9zi7/y+0f4L//MnpseuPrE4
J0HH8Z6UkFc/Qx3+P9K/mFmoWWf3pCXBx8DiHED/E9f46nEOq54pLFBBkWKVa1WE
3H6M27Zm3/1cFft5jLtABp/ca+azslSIMLDyS0/Q26SUlbxMbRLhZfhNnFwdBPzu
W48l5Sm/MP0Vz6RbJOnbbwvqLcaTyvYTkDIGiED9BeU/R2wKKMh6cdjkYT7CvzV/
Q9mdNxKB/OQEstblDftKF0s4yWJMADnAWCCsinvkPeuIAynJ0v20IeYG4TrpS2DW
lChvQq/jFvyTmWjG0weFqSGFnlcYqoWroKiDtx/GKQPS1LSfBlrrrMwHAL+DdU1s
5qJcozOawq/9R3iV3tpWMwvpvRo77L0+XKP2apQ2BKuynBr8OsrhzCmyrf5UfGY2
0EF82v2TuxsE/xinOm7TILqHhJ/R0UwePnObe6WDf3bD3odtont4q1gaTCWnIkxa
GaW8dBlxt+jFekF4W6ZJ
=JcdN
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
