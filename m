Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaEHOQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:16:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEHOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:16:30 -0400
Date: Thu, 8 May 2014 16:16:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140508141611.GB30445@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140507152640.GR30445@twins.programming.kicks-ass.net>
 <87wqdwzbxy.fsf@ashishki-desk.ger.corp.intel.com>
 <20140508124121.GU11096@twins.programming.kicks-ass.net>
 <87ha50cuab.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lh1tzOZp3jg2TtWy"
Content-Disposition: inline
In-Reply-To: <87ha50cuab.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lh1tzOZp3jg2TtWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 03:46:36PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> > On Thu, May 08, 2014 at 03:34:17PM +0300, Alexander Shishkin wrote:
> >> Peter Zijlstra <peterz@infradead.org> writes:
> >>=20
> >> > So the aux_head/tail values should also be in the file space and not
> >> > start at 0 again, similar for the offsets in the AUX record.
> >>=20
> >> Thinking some more about it: if we keep aux_{offset,size} in userpg,
> >> then it would make sense to have aux_{head,tail} run from 0 to infinity
> >> similar to data_{head,tail}, especially considering that neither data_*
> >> nor aux_* pointers are file offsets anyway.
> >
> > Yeah, this might make it easier. So then the rule is *_offset +
> > *_{head,tail} is the actual file offset into the buffer.
>=20
> You mean *_offset + (*_{head,tail} % *_size) ?

Indeed I did..=20

--Lh1tzOZp3jg2TtWy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa5GqAAoJEHZH4aRLwOS6CiUQAK07jVSBGUiC9OOKF0qi0nDK
4ec+4H0ONyxZTWuVd7OAUapnefp0vugK37KOkwaunKAcOOMTSlkZtLnXFP294qYX
mwQAEPxGgunuj+eXxcVXPoMonycigZHLfaxwf4MtSfcwqmbzZ1/IGJvkRbXfGviK
j9poM2RD+mhxHbxXVl6l/KkOpRopekUD9vEUaj7OYfcb7MPLo1Jb0Lp1YWPFMlnM
zVvWIha3DdE1hwtjDK6NWS+SGZPf4bBZE4F+1AeBIpdoI2AqaIBUPk8D/NukBzOO
XSJ99iUZ1cBHR5/tCnN7vw34uYsxl5Do0YivvPhhjRDACqbxDh/rvlYy4y2Q65Na
hDIB5BceGDEQyHsXS1bz1l5/c74WUcjhK6YqupZLrQHTKdA0HkGQO2cM/6u0Nbsi
xTPKwe+GIxQA2DUm+gJ+p2sgcypdA6FXK83bl1HClkpZ8UK3WcBtFZHRLtbRLX9z
2JK6SyD7TSBrDtFw6rw8Vt+oIaN3jKr5U9sFJ89rC5h8FxzDD6BE/yETaTaX8C0m
SULburbxC4LBG+pvskfuJSPk21XWHifpzFfm2D93k4RU+wYERnPFzOtrm3P2EICa
U/og4HDd+sW6WAv2ytD2II/77WZiKPd+eEYSr0KTRocOqXSLjyF2gllqOewulPSU
ixH+IqZjHoCodAewFs0Q
=Dtjp
-----END PGP SIGNATURE-----

--Lh1tzOZp3jg2TtWy--
