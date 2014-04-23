Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaDWWik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:38:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43262 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaDWWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:38:37 -0400
Date: Wed, 23 Apr 2014 23:38:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140423223812.GG12304@sirena.org.uk>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
 <1398217214-12204-3-git-send-email-zlim@broadcom.com>
 <20140423103648.GM12304@sirena.org.uk>
 <20140423172720.GA18588@lc-sj1-5012.sj.broadcom.com>
 <20140423182611.GF12304@sirena.org.uk>
 <20140423192228.GA21142@lc-sj1-5012.sj.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54LdxIEkS+RO3u8o"
Content-Disposition: inline
In-Reply-To: <20140423192228.GA21142@lc-sj1-5012.sj.broadcom.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] arm64: topology: add MPIDR-based detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54LdxIEkS+RO3u8o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 12:22:28PM -0700, Zi Shen Lim wrote:
> On Wed, Apr 23, 2014 at 07:26:11PM +0100, Mark Brown wrote:

> > When I was looking at this it wasn't sufficiently clear to me that the
> > cluster clustering would be well modelled by sockets as the scheduler
> > currently assumes them, nor what to do with additional levels of that
> > (the DT binding allows for infinite levels).  Punting and just putting
> > all clusters at the same level avoids active bugs and seems fairly
> > conservative.

> Sounds like you prefer "cluster of clusters" over "socket", correct?

I don't actually care that much, I guess I was using the hardware
terminology because I'm not sure how well it will map onto the current
Linux software model of what a socket is but if we decide it maps well
onto a socket that's fine also.

> In any case, with only 4 affinity levels defined in the arch, as long as
> we also have 4 variables to capture that information, we should be good,
> right?

> Anything more exotic not expressable by these 4 affinity levels in MPIDR
> will require additional information from other sources such as DT or ACPI.

Yes.  I'd really only thought it through properly for the DT case since
at the time Catalin was saying that it would not be possible to use
MPIDR.

> > > Perhaps we should just add a new 'socket_id' and that will accommodate
> > > all cases (up to aff3).

> > Not in the non-MT case where we've got two levels above the cluster ID
> > in affinity level 1 unless we just combine 2 and 3 (which would be
> > reasonable enough of course).

> Is the following an accurate description of your proposal for non-MT?

> 	thread_id   = -1
> 	core_id     = aff0
> 	cluster_id  = aff1
> 	clusters_id = combine(aff2,aff3)

Yes, exactly in the combining case - probably just shift one of them
left and or them together.  Otherwise just only have the cluster_id and
combine everything else into one (that's what the DT code does
effectively).

--54LdxIEkS+RO3u8o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWEDRAAoJELSic+t+oim9LBkQAJZDfsAPt+uTv5csPcFhO6b7
Y/XqPMc971eLtSd3isaAut4eoHMtrxugLcyaoN8AfYLEB6AoxVOBinhYfSE9WSz7
Kss+02BByPeqOSnGBLN87X2yBdlaa8JmffZ3xhEkJJ30riBnNCIHfZGeOooRMG/d
Rpha8Z4kDRYK3hBtQ4J8KNtyqeERZoXe36f9Yx2WW0f/7p+k/XVj2rfvCreWTzz4
Zkr1Rl6iOZYt8UtHCNLzVJNiJFhQQLJjev+H6TpW7iBbNdFYj9T5cV7lneLNLEWC
dniiaEQz7oPxFqb0ljarcu8Cx74InmH0avGk2jRANCEWP2aslrCpLjCOF+GycylI
eO3aUNNRmErE5seAUi0Wy7S23ikeXvIbuO6KKhbgfrtgY6uNlXfdlGmoYFYYJX0b
cii+HjoSfdWqPVuprLUKg7s8KqOa++Y3RBo+jnVKp7YImaPxxqKvfOPs29ml/RuF
BFeqWBMZNlOf/By5ZEh2N1fcrA3tZlslgPtaWC4dnNDC9c5QrNVKt3fEvV/EC8Te
GuG6zRFtrDf/iVNgJRWH1ELpnCPl0g527KVTqqclBGo/ednmf5Hp4oaInRJuD/rz
O1uzF5JX/77mIszI+IlWLscxQ0+GN+fx7PbW6jcFFJ7PbNQShYIDTkG1+fLgDBpY
44rD0tlwFy05Z2OIAUjD
=ETYC
-----END PGP SIGNATURE-----

--54LdxIEkS+RO3u8o--
