Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaELIre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:47:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:33860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaELIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:47:33 -0400
Date: Mon, 12 May 2014 10:47:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Message-ID: <20140512084727.GN30445@twins.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com>
 <53707007.3080003@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wdXZ0KDsOFX3OpPb"
Content-Disposition: inline
In-Reply-To: <53707007.3080003@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wdXZ0KDsOFX3OpPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 08:53:59AM +0200, Michael Kerrisk (man-pages) wrote:
> On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:

> > $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
>=20
> I realize my speculation was completely off the mark. time(2) really=20
> is reporting the truth, and the sched_setattr() call returns immediately.
> But it looks like with these settings the deadline scheduler gets itself
> into a confused state. The process chews up a vast amount of CPU time
> for the few actions (including process teardown) that occur after
> the sched_setattr() call, and since the SCHED_DEADLINE process has
> priority over everything else, the system locks up.

Yeah, its doing something weird alright.. let me see if I can get
something useful out.

Btw, you do know about EX_USAGE from sysexits.h ?

--wdXZ0KDsOFX3OpPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcIqfAAoJEHZH4aRLwOS68IcQAJULAP+kL6DF6Dm/hSg59H84
E6LZwqzJEcpQfstZC09vgjRYFNy1FBaAkzFRB+ZZFdMH1MelS425AGWSh7Kjpzrw
ERTRvA4GLS9Tkg7H07zGp07zF5aq1xVOpCAJXlbFhTXX3+S9O9JEd56rEb5p+APx
vF3ecCJIKpLzQvuWC/9xvxDc5xPbq+B0Q9JiL0NicIHbeZZHOAas6DCbEuENud34
zGLMkogLmaLGjmXPfBPa/2MT1goZI9qNFe+GBoLimNw+in6m7JAh+mksb2aXu7Ax
eUhsBdNq4kj0Qw7eD0HWkSPTm48Jtdd5SDGkVbuUWPWCkDXdNqPXowdVS1rnawLo
IYjL1k/9bbF3TvJMdM9ktN+eJ8+DEyn7gPfyEbHGFfo86dgcIGkOOBd/k4MwUxB7
J3surJPaGueGDX6/Y8h+ZfIVTuD+Mx5DqqcQsb4HC8gVlA0Xk/7UoWnD1UjBhNol
RMNh3ladksUUgVnVk8cIN4i85qH5ZxjW3IxvuZDFuSZ6TamE+nU96JQlA6/JVYai
6liQ0sQz2BE7MhHxNTvD1J4QbXUzwI9njxIi/dt+H95Ww2yWRhxlh3DA7KsKUeJH
B++hSbyT5bGkd53XSWzUPqTa1e55V3/EZg0vKr8XRiXntfBeHBJUedplgr9xPKEG
da1vVELlcraSKPxLikA5
=9X1x
-----END PGP SIGNATURE-----

--wdXZ0KDsOFX3OpPb--
