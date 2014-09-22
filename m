Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaIVVWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:22:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:52217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbaIVVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:22:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,574,1406617200"; 
   d="asc'?scan'208";a="479270954"
Message-ID: <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 14:21:52 -0700
In-Reply-To: <20140922203336.GF4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140922153355.GB4510@pd.tnic>
	 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
	 <20140922184049.GB4709@pd.tnic>
	 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
	 <20140922192152.GD4709@pd.tnic>
	 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
	 <20140922195737.GE4709@pd.tnic>
	 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
	 <20140922203336.GF4709@pd.tnic>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XjDgKU5LjOvXYdxCy1RG"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XjDgKU5LjOvXYdxCy1RG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-22 at 22:33 +0200, Borislav Petkov wrote:
> On Mon, Sep 22, 2014 at 01:09:33PM -0700, Jeff Kirsher wrote:
> > Sorry I am very frustrated at your response.
>=20
> You shouldn't be. Judging by your reply below it seems we do actually
> agree... mostly :-)
>=20
> > I am not saying that the proposed added MACRO is the best solution to
> > this issue.  Several other maintainers have actually responded in a
> > similar manner to the macros being added and came back that the better
> > solution would be to fix the code so that the warnings do not occur in
> > the first place.
>=20
> Right, this would be optimal.
>=20
> > So I guess I was hoping for more of the response, that "let's fix this
> > the code so that the warnings do not appear in the first place".
> >=20
> > I agree with you completely that I do not like the idea of the MACROS
> > being added to silence these warnings.  I just disagree that not doing
> > anything to fix the warnings is far worse.
>=20
> Ok, good, so we're on the same page here.
>=20
> > Why grep through 100,000 warnings, when we should be fixing the code to
> > prevent 100,000 warnings.  Not saying that the MACRO is the best
> > solution, it is just a solution, in hopes that it spurs discussions lik=
e
> > this on how to properly fix the warnings.  Not a discussion on how to
> > grep through the warnings and do nothing.
>=20
> There's only one thing I don't understand: why is so bad to grep through
> the warnings? I mean, sure, fixing them *without* jumping through hoops
> to do so is the optimal thing. But what's wrong with grepping through
> them?

Nothing is wrong with grepping for an error, especially when you know
the error your grepping for.  But then again, why grep when it can be
fixed to begin with?  The fact that there are over 100,000
warnings/errors to begin with is somewhat disconcerting.  It makes me
wonder whether it was due to coding laziness.

>=20
> Btw, out of curiosity, what is your use case for staring at those W=3D2
> warnings?

To make a better (more solid) network driver?  Mark has found it useful
to do the W=3D builds.  For me personally, I do not bother because there
are over 100,000 warnings and it takes forever to get through a build
and then grep for our drivers to see if they are generating any
warnings.

>=20
> In thinking about it, what we could also do is simply move the noisiest
> ones to W=3D3 or so, or even add another W=3D level. It'll be interesting=
 to
> hear your use case though. AFAICT, this is the first time I hear of a
> more, let's say, serious use case of W=3D since we added the W=3D things =
a
> couple of years ago. :-)
>=20

I could see this useful if there is no way to fix the issue that really
is not an issue and the compiler just does not know any better, but this
concerns me that we would get into a bad habit.  "Oh I really do not
want to fix this, so I will just make it so that people we not have to
see this warning/error"  Again, sounds lazy to me, of course I am just
speaking in a generalization. I am sure that some of the warnings will
fall into the category of, it needs to be silenced and not fixed because
the fix is far more troublesome.  I just cannot believe that most or all
the warnings would be that way.

> Thanks.
>=20



--=-XjDgKU5LjOvXYdxCy1RG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUIJLwAAoJEOVv75VaS+3Of04QAJOFTQhrGnwEa+AqU9lxR1dt
eIbN5JlIbtk80RMvIr/ydyOFELU5lys91JR6sCEC0XjFdTxWgVOi/7VkJAIzyn8L
9Mt3thf43rua32C+m+az0rbloMPa+SkTMy+ZlUToru4OhBL/4gIrqQikVOsJfnOW
JUHrK/KVzSUqgwwBigcFJbBozer2Bn8ppD5s3IEv+gDraF28QaZ7XZ9TL/Q27JVK
S29imzZiTBHCMPhPqdfoK93AU1aIut9er+rJoY6ouWlaE5KHC0xecrS/kRYR4O+x
czwqN1fqEYn51iEYLCAJQVJ4/m4aB0petecLt4hs2o6Os/crRPpujLoDnyocJmE1
PERlUkuBoV6J37ScdmrqIOMnPAJORAhoFFB5OLZz9q+E0P4Cm2zpKM/+jB52yApz
RcPcnQgktNPLt4xBoH54BloLFRlW7aKdoe60UnopuQRT+JWD8We3S8FIjw4YffA6
FH26e4HfoIkKe8ZcPth5Qx3SvzlwGPxJXVFxc4dvYP/RJnPsPjyKIcFW76pZTUkE
Tb91MLh+BOFl//2tLJVSkePlFrH04ihoDvXPVLSzZd2asHvXRdBLt8QQrebhwvKG
0t32P6FNQjlnTAW/8u7fb2rg1WSbnMKaiAQ/7Fw8wCkyQPBt0L7+WOMVMRn9Jnhj
0KH9Jucnjs2a75GOluOC
=wqTf
-----END PGP SIGNATURE-----

--=-XjDgKU5LjOvXYdxCy1RG--

