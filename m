Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3HUQLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:11:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59537 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3HUQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:11:03 -0400
Date: Wed, 21 Aug 2013 17:10:57 +0100
From: Mark Brown <broonie@kernel.org>
To: David Jander <david@protonic.nl>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130821161057.GG26118@sirena.org.uk>
References: <1377099442-13884-1-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1XWsVB21DFCvn2e8"
Content-Disposition: inline
In-Reply-To: <1377099442-13884-1-git-send-email-david@protonic.nl>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] drivers: regmap: regcache-rbtree.c: Fix overlapping
 rbnodes.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1XWsVB21DFCvn2e8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 05:37:22PM +0200, David Jander wrote:
> Avoid overlapping register regions by making the initial blklen of a new
> node 1. If a register write occurs to a yet uncached register, that is
> lower than but near an existing node's base_reg, a new node is created
> and it's blklen is set to an arbitrary value (sizeof(*rbnode)). That may
> cause this node to overlap with another node. Those nodes should be merged,
> but this merge doesn't happen yet, so this patch at least makes the initial
> blklen small enough to avoid hitting the wrong node, which may otherwise
> lead to severe breakage.

Applied, thanks.

--1XWsVB21DFCvn2e8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFOaOAAoJELSic+t+oim9mHcP/3eWwtgZZUL2kfsRsErIEXJz
eoLRHAjPqM45XaM1/X8SzJHrxoSu57nqRx68joWq5sb17gwVgOoiVGD8yyPVC/On
9vRscIV8UfWFn4siQOipFJme9koBs+EtwgC2GRXux/fBMyxrefjKvGj8kEOvL6lZ
+o6THne28x2Cat2EvxOOw9F3WxtwqzSIhVZb3jF2TXYTGUz5Ld6/xFhHyIfOgvuT
yJBKe9H6wtUOMTKaKQ12yQpdvvFW/fvXRex+nbSpcMmcjThat+MyhlE4pKS/yj7h
ih4OpcnDYJ4mY6eKdJEvfQycBdpmY6OQ7+sL69mG72vFnQcWGUOvftQ0PHmGiAM9
iP5H/s2YN5B9tjhcGICrFt1YFJmtx8kT6XNItWHbGurZIc9A//mM8UOvAZ8K33UD
AQKL6EZhSQcYWLXyOASCSS9UcRH/K8UQsro4SrEWRFp3aL7nHtA67OL0xxEsh+ue
hHfYoqUV8pcyA981V1iIDBdVwfF0devsxKxa00lJv6Gcg/igZz30x9RcduYKzNwj
KPQCglspk/6giJfJUWczzwctAQ53cDkEbjureSDrrmn/aYt0zrREr/f4UIRBzX8S
/lqYExS7RygLT4wKYmLhVtvzkgUPYpdooc5chp/MTegO1dak4rONmXbzb6To99Td
CueOCEmxjou3++l8yCTm
=+/RU
-----END PGP SIGNATURE-----

--1XWsVB21DFCvn2e8--
