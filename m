Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaEAQD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:03:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54028 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaEAQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:03:57 -0400
Date: Thu, 1 May 2014 09:03:38 -0700
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140501160338.GA3245@sirena.org.uk>
References: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140501013402.GL3245@sirena.org.uk>
 <CAPybu_3g=VBW+gGhveBJoc7=tCiPurP_r_+hqOU78bvsg8QJWw@mail.gmail.com>
 <20140501141156.GV3245@sirena.org.uk>
 <CAMuHMdUeFJDq8TMQn=D+y_nWVy-puZDYekV3cPhHTnDF+ebKJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrEcvySKR+fOA8iz"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUeFJDq8TMQn=D+y_nWVy-puZDYekV3cPhHTnDF+ebKJA@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Fix hung task timeout when initialization fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrEcvySKR+fOA8iz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 04:33:58PM +0200, Geert Uytterhoeven wrote:
> On Thu, May 1, 2014 at 4:11 PM, Mark Brown <broonie@kernel.org> wrote:

> master->kworker_task is set like this:

>     master->kworker_task = kthread_run(...)

> so it just contains the status of the creation of the kthread, not if it was
> killed, right? Hence we don't check if it was killed.

> So Ricardo's patch prevents the stopping and destruction of the thread
> if it failed to be _created_.

OK, so that means that the description is very confusing then since it's
talking about the issue being due to kthread_run being killed.

> What if it is killed? I suppose the kthread API handles that internally, as it
> could happen to any thread (e.g. OOM)?

I'm not 100% clear on this to be honest.  Since I'm at ELC I've not
investigated fully yet and I'm mostly going on the patch descriptions
here.

--yrEcvySKR+fOA8iz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYnBXAAoJELSic+t+oim93V8P/ie/2R5Q3VKwOMzugPUCJbR1
ln9p7Qg+oiikOfApn6I7EYiCU/K1Gi5dEWvwWqnIekG0ryU1Rsksqdn2p6a7bwhh
T6/nu4k7yRHLmpbKiDTJzqap9n/1IFtvrXcj/KgqzVj4S9YQUag/cgDOmF5QPonm
7iXzqPAMUPDPQFaVT5KuHWV02amrR72L2Nq7JpJd6TBSAFBnpKsPprI4lnU9KpiM
XWShbA33CTd7P2EtoIHSNBVFr43YwIHFc1m0Dj/3z2r6Ec3tvH0TsOi0mWQzVsOs
VlSL5Dg55laQwNTkz/ym1dBxn5qg6sE8alQtSDGlzLWhZu4Uc+q1Bfd0IJnu0bWF
XauMJRqaKGHYvt+x9yGiKyW7fu2X5L9RJS5QMgmpoMMn9+FGcscrpgAupZ32T0AC
u1mlY9+93LkztuO26qsuoajYYUIdRxV5m+acda2BoDcHZ6o5Mi2NumHCv796PEd8
gi9MeCdbdjyePDwM+6v/FfyGdvtuT9J5qqxqMvI+pfNgPFdcGBKdbveTMWP4hMgP
TKWNQki5GOxvcR57ozMuBs9Ly4ym09/9g2umHwPyf1piVqmweHMGjtRCe26jP866
nSdiqJ/06RZPYdXc1LByIjmcekYAhggse4jPdaVt1S4pQgX1IJ8CABVT3SPSObue
5hisNczFGlkLFLSnjimn
=2C3a
-----END PGP SIGNATURE-----

--yrEcvySKR+fOA8iz--
