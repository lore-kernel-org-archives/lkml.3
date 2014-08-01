Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaHASvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:51:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHASvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:51:23 -0400
Date: Fri, 1 Aug 2014 20:50:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: kan.liang@intel.com, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against
 potential #GP
Message-ID: <20140801185057.GK19379@twins.programming.kicks-ass.net>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <1406799663-18192-2-git-send-email-kan.liang@intel.com>
 <20140801073825.GG19379@twins.programming.kicks-ass.net>
 <20140801074430.GB3588@twins.programming.kicks-ass.net>
 <20140801132120.GO18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xWZXSauDRVVTjWoq"
Content-Disposition: inline
In-Reply-To: <20140801132120.GO18735@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xWZXSauDRVVTjWoq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 03:21:20PM +0200, Andi Kleen wrote:
> > > NAK!
> > >=20
> > > I already said this isn't going to ever happen.
> > >=20
> > > Both PT and LBR are arbitrated through the kernel, therefore we can (=
and
> > > must) deny PT when there's existing LBR usage and vice versa.
> > >=20
> > > We will not hijack resources like this full stop end of story.
> > >=20
> > > Fuck hardware/BIOS, they should _NOT_ be touching this.
> > >=20
> > > The 3 people in the world with access to an x86 hardware debugger had
> > > better be competent and know WTF they're doing and the BIOS can just
> > > piss off right now, they should not be touching this _EVER_.
>=20
>=20
> So you realize that hardware level debugging becomes impossible
> if everyone starts using perf?

That only becomes a problem if you need to hardware debug something that
uses LBR/BTS (in the current state or things).

Now, by doing the patch you did, you already change behaviour by having
PT enabled, and therefore you already couldn't.

So this is an explicit blind spot for the hardware debugger, that seems
like a bad idea anyhow.

The things is, with or without this patch you cannot debug LBR using
software.

> I dont know how anyone can construct essentially sabotaging powerful
> debugging techniques ever as a good thing. In the end it'll just
> lead to more buggy software (and likely hardware) for everyone.

How about you see it as an attempt to improve things by not having
arbitrary and limiting blind spots like that?

A hardware debugger should be able to debug everything, including LBR
using software.

> > I yelled at BIOS engineers over their PMU usage and $vendor added a BIOS
> > knob to disable that, I'll yell at BIOS engineers again, just give me
> > their number.
> >=20
> > Really, say NO already.
>=20
> Ok, so no technical reason, merely a "me vs you" power play.

Clearly you forgot the discussion we had back then, you want me to find
you a link or do you think you can Google it yourself? I'm not the only
one who thinks its a terrible idea for the BIOS to involve itself in
these things.

> Thank you for not stating that earlier and wasting everyone's time.

Oh, so you thing its entirely reasonable for a BIOS to use PMU features
then? I suppose you do since you wrote that silly document back then
about 'sharing' things.

We should be limiting the things the BIOS does, because the BIOS will
get it wrong and then we have to spend ages working around it. There's
enough BIOS wreckage to deal with, don't encourage them to make more.



--xWZXSauDRVVTjWoq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2+GMAAoJEHZH4aRLwOS6T9MP/28ow9x+6mKB4v5qAg82ZSoP
UEv1NNtSmi+OXDRdGgdDEkkQ9swEy8jxUTMhPVCcRt8/5+Kt8hUroU0eS/hjIJuy
fVh+0sRFGd2TfRmNZ6+lYaSj8Wv18skDQVvYH8FrXIp0yWWwVeDQvlY860wTTYao
EgonL1u0bOow6fwga2fwegneIZ+3xB0jR61SwfNzJ26uxVG/igIq+tTVxE4vsj8z
HlleeKzAEQHm5aUsS7R3Mm4sM1PsPV90jB/zshzRP6NJ0W+zxXv98uiKCpbMImCH
eAh6Ps99nUt0W9pvZ8i3UFmTHEqsDNbRSr8h1FwQIGv17kywBfJrKAaO9Zz28sqQ
HHS2W2AdBvXOfxKxcegJcrEGxDLj9nylnSf/es8c1Fn4oC4W/1Sely1vn1jCO95o
jNkhYnzLqcRc6i3jFrh6v9EBiJ/G6+4QRgNfotBShjPJv5F01rP/MTZ+rTqkzq4u
3qNv8gjabKkoGkAHhwKBb0L+rCx7d50DK9PU8cHltOkKr2XiA85O0nxq9/JJAtXR
xdT9JZXHAFP6svtehl8AIFInHtnf6uTG4827TfEvcsw6YSqPaZQEtTznB+5R1mE0
PDlmBOlTDO4d3sHVzZe+XyZdcKUJfFXOPlvfFcSKx/5iD18ZRxyUPMsqF2i1xEzo
Lod+yflk/KUI9y98iil5
=whQt
-----END PGP SIGNATURE-----

--xWZXSauDRVVTjWoq--
