Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaEBQvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:51:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55296 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaEBQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:51:51 -0400
Date: Fri, 2 May 2014 09:51:32 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Inderpal Singh <inderpal.s@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Message-ID: <20140502165132.GH3245@sirena.org.uk>
References: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
 <CAD=FV=Vo+GLTt7fh4639XFsJfSUTN0ARBsOy+O24gtB_87MgLw@mail.gmail.com>
 <20140501012825.GI3245@sirena.org.uk>
 <CAD=FV=X5vGgZOxbRb808R9CSnGLPD9Tc77VMO5B3f3FS0jwk6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="58ygytiqlNL9PddM"
Content-Disposition: inline
In-Reply-To: <CAD=FV=X5vGgZOxbRb808R9CSnGLPD9Tc77VMO5B3f3FS0jwk6Q@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: virtual: Introduce a new virtual locker
 regulator type
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--58ygytiqlNL9PddM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 02, 2014 at 09:13:39AM -0700, Doug Anderson wrote:
> On Wed, Apr 30, 2014 at 6:28 PM, Mark Brown <broonie@kernel.org> wrote:

> > I glanced at this briefly and couldn't really understand what it was
> > supposed to do from a quick glance but I do tend to agree that it's too
> > complex and confusing.  Quite what the virtual regulator is supposed to
> > represent or how it is used is distinctly non-obvious.

> From my understanding, there are parts internal to the SoC where
> something powered by the INT rail looks at an signal based on the ARM
> rail, or vice versa.  If the two voltages are too vastly different
> then you get into trouble.

That bit is totally clear and normal, what's not at all obvious is what
the virtual regulator is really representing and how it will be used by
software at runtime to achieve this goal.  In general introducing purely
virtual things into the device tree is not a good sign for things like
OS independence.

> Mark Brown: did the bindings above seem sane to you?  I can clean them
> up a bit and explain more:

Yes, that's one of the suggestions I proposed...

> - regulator-lock-to: A list of regulators to monitor.  If they ever
> are greater than our voltage + the corresponding "lock-within" then we
> should bump up our voltage.  We'll bump back down if/when the
> monitored regulator falls again.

This isn't a good name, there is also a common feature in hardware where
two regulators are run in parallel to deliver higher current.  The idea
is fine though.

--58ygytiqlNL9PddM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY80RAAoJELSic+t+oim9iCYP/1S1UMDUBH97IjK6tEVKLomD
Kc3JW1vSHbyOiDe7jsH9pESiMBVXwEtwTfEUBUl9YFU4V5pqjzGHBkSzxmqgVvSN
PiHe6n5IgQLwjEi8CviQXMIadsRp+eaakl5acsGrqLHb18LOOj7w/wFHmenS0VA7
0wkbSfPktSiw31XwutmfO6+1Z0aVP1nmUxrbGEtgLtHlpJ/vrokx/f8njC0l5Byv
pCkKzYLRpzYX9FzhzFk5CmYwyI+jqZ+IrMxHNKy1iO629UEnP0a0d4b/iQIf7NJV
KtPwyzL45HmB42zrP3rrOjndMW0l/SCYECaJOPaTM5SusM9IowIZVpoDqOJR7K0E
QedRAVstNy9GUayEIBQ8MD3+LYkZV09inEjNWI958JtpsJij+n5TwycKrFQfhw+l
Hg4isvxQYTldGm+3T/5ar34K5qbD+vcDb2vt1TNyrcd17huJIQ8x6Et1eZ8zRySn
Ua6FJHQ8Lc4AGKKY3CobGmpB9ICFa8ZGya4hz89GjN2HQGPyjBPeBqFAD+rCJBzQ
34flTUcTomxN4anhVh23yZqFn96Zuvf2MMVzELU9oHYzxgvx/XLDqm7uon7IMlkG
/08UIvdUS4rPiv9ga0jqlAzOSpBqZ4zahG07H4hacUco0K4Qr8ESzmxF5GsVkQhN
rPwtMAjNK1Sa5QpcyeO+
=7mtz
-----END PGP SIGNATURE-----

--58ygytiqlNL9PddM--
