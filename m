Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaHAHin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:38:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:51093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:38:38 -0400
Date: Fri, 1 Aug 2014 09:38:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against
 potential #GP
Message-ID: <20140801073825.GG19379@twins.programming.kicks-ass.net>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <1406799663-18192-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IsPk+NL5oGWvlTjG"
Content-Disposition: inline
In-Reply-To: <1406799663-18192-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IsPk+NL5oGWvlTjG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 02:41:02AM -0700, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
>=20
> Intel PT will take over LBR hardware. If RTIT_CTL.TraceEn=3D1, any attemp=
t to
> read or write the LBR or LER MSRs, including LBR_TOS, will result in a #G=
P.
> Intel PT can be enabled/disabled at runtime by hardware/BIOS, so it's bet=
ter
> LBR MSRs can be protected at runtime.
>=20
> The {rd,wr}msrl_goto can protect LBR accessing against the potential #GP.
> Furthermore, it will not impact the "fast" path's performance.

NAK!

I already said this isn't going to ever happen.

Both PT and LBR are arbitrated through the kernel, therefore we can (and
must) deny PT when there's existing LBR usage and vice versa.

We will not hijack resources like this full stop end of story.

Fuck hardware/BIOS, they should _NOT_ be touching this.

The 3 people in the world with access to an x86 hardware debugger had
better be competent and know WTF they're doing and the BIOS can just
piss off right now, they should not be touching this _EVER_.



--IsPk+NL5oGWvlTjG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT20PxAAoJEHZH4aRLwOS6lkwQAJUuFuIpXwMymBqv/Psod2op
g1Q5uTzCnhJddtEMzIQiRkEEAvcgcLYI8dEOoO+zcQwqYDiZnmDDupDZJguijOLL
WXMD70A5maSWJHsPjsmmB11PCB251n9BEFTkM/gTNNefDYZi3YAjBVdI8UNN+XQL
3vjul/A1e1U1Q+3rd0zgxyWZHuUJnlJopUVTGVd75QdnT91TCbYhUfAfOarmNRId
OCKeUK7YqJ78ThzWqqQEHcnf1tlJwKJY/buf8jhbLwWls6AHni4b1NCpT4ljqCdp
zBqZ5KK9lwnqSLu7E5Lz0QCzfvag0dPu2NV+mz4uT5OXGWJoGJq8PPJ/vuMMJThU
2AlGgwIIliFkyjO9bIkLDiv+w77M7jKCQIyanJgA1b+b8D32lA07ZkDfXLvqsX47
jOMwa9J0KXdty60sRH20JOEVN6PnHoQLfDk9Ys9+YTyZ26YwiBxvHJh7tTOLbT2b
sX5Ug7wHbb4JU3dxFkh+5TBTLrfDgAboBzPHVbCT3lvVdMKNQTx067M2OwiKmrwJ
I9ViPr7WcU6JN8NnW3lNaXxVenQb1iuZgR0ReH54gvtpq/uC6TjqovHVe5ZEpWcT
0cOrC6XSc4fI9m/Dft10OY2w3iVB7Yc3qNX5BA5Gc+rH543w+fZUYjIpOf35vsgc
DpdDw8hhhqV7WP5fppoP
=IBnU
-----END PGP SIGNATURE-----

--IsPk+NL5oGWvlTjG--
