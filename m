Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaHAHom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:44:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:51105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHAHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:44:41 -0400
Date: Fri, 1 Aug 2014 09:44:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against
 potential #GP
Message-ID: <20140801074430.GB3588@twins.programming.kicks-ass.net>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <1406799663-18192-2-git-send-email-kan.liang@intel.com>
 <20140801073825.GG19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xr11uZXTBybZk4CB"
Content-Disposition: inline
In-Reply-To: <20140801073825.GG19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xr11uZXTBybZk4CB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 09:38:25AM +0200, Peter Zijlstra wrote:
> On Thu, Jul 31, 2014 at 02:41:02AM -0700, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >=20
> > Intel PT will take over LBR hardware. If RTIT_CTL.TraceEn=3D1, any atte=
mpt to
> > read or write the LBR or LER MSRs, including LBR_TOS, will result in a =
#GP.
> > Intel PT can be enabled/disabled at runtime by hardware/BIOS, so it's b=
etter
> > LBR MSRs can be protected at runtime.
> >=20
> > The {rd,wr}msrl_goto can protect LBR accessing against the potential #G=
P.
> > Furthermore, it will not impact the "fast" path's performance.
>=20
> NAK!
>=20
> I already said this isn't going to ever happen.
>=20
> Both PT and LBR are arbitrated through the kernel, therefore we can (and
> must) deny PT when there's existing LBR usage and vice versa.
>=20
> We will not hijack resources like this full stop end of story.
>=20
> Fuck hardware/BIOS, they should _NOT_ be touching this.
>=20
> The 3 people in the world with access to an x86 hardware debugger had
> better be competent and know WTF they're doing and the BIOS can just
> piss off right now, they should not be touching this _EVER_.

I yelled at BIOS engineers over their PMU usage and $vendor added a BIOS
knob to disable that, I'll yell at BIOS engineers again, just give me
their number.

Really, say NO already.

--xr11uZXTBybZk4CB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT20VeAAoJEHZH4aRLwOS6dCUQAKbWsF7Gi02iRTU8RCXpaN7K
eOPg/TEVivdH0hZRKQWJ625o4cyHwi2A6lVsCWkXH/O4ibTmxnU/6iiJMTBQOhi3
awwezSfuiwzKJvKsJpzDuIbXMbg/yeEssGOFCmu+WC6O69P8lvXm7zy+jdJdiWrV
ecWKh1ry7e+WXinCbhjcmUS5YtdzpK0ZgNP8191pIyUe0MYbIdnm9kiCCqjXHMEo
BP/QlgSLsMs5NInJh84B2KEdWKhqE0UHw61n+y8yJBgIJ2QX+xWJFbHYTel3qzVu
epas7Z1ofFVnEbnwAwXYYhH4Z2bmSVQ/sW23b1ZSgCu3E45F6bZTYnQdZE6yVkkg
Rr4f+1ZZqoF5OxLKPZbMbuQ+d+vw+CB3GMnrxMAZVOtyupubFJF1ANeTNnVCXmN6
PJhxgD0DcZppdhf3Wg8dga4BGDePzAwVfmX4O6qH5eSY6yOJRkfLLWZn0LaLLZo9
uAzhqAA+4aRbumWsG5sOlWlg3Q16G8902nbJBHXNLEil5/mhrYlvJbmRrmFE31Ru
frHScUlQVBF3ttTuSQCwScqmaKHomrFbL6Zh9sdQszQE2vGO5D/CvEtzcALmikrA
X06lG4w2aoasYMQwmNcykJfuyFfAD97rlEUaRmQBedGmWuIE79xHu/B0IazbpIN0
OBji7PmeRCTkqfT4PL1N
=fi88
-----END PGP SIGNATURE-----

--xr11uZXTBybZk4CB--
