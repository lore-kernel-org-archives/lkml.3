Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaGGMn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:43:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaGGMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:43:28 -0400
Date: Mon, 7 Jul 2014 14:43:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Subject: Re: [PATCH v2] perf: Handle compat ioctl
Message-ID: <20140707124315.GN6758@twins.programming.kicks-ass.net>
References: <20140617121328.GO3213@twins.programming.kicks-ass.net>
 <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
 <1404230760.25766.5.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zpRN6KW+pnHWATcM"
Content-Disposition: inline
In-Reply-To: <1404230760.25766.5.camel@hornet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zpRN6KW+pnHWATcM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 01, 2014 at 05:06:00PM +0100, Pawel Moll wrote:
> On Tue, 2014-06-17 at 13:43 +0100, Pawel Moll wrote:
> > When running a 32-bit userspace on a 64-bit kernel (eg. i386
> > application on x86_64 kernel or 32-bit arm userspace on arm64
> > kernel) some of the perf ioctls must be treated with special
> > care, as they have a pointer size encoded in the command.
> >=20
> > For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
> > as 0x80042407, but 64-bit kernel will expect 0x80082407. In
> > result the ioctl will fail returning -ENOTTY.
> >=20
> > This patch solves the problem by adding code fixing up the
> > size as compat_ioctl file operation.
> >=20
> > Reported-by: Drew Richardson <drew.richardson@arm.com>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>=20
> This just is a polite and friendly nag...
>=20
> Any, strong or not, opinions on the matter?

Sorry, travel, cracks, falling, etc..

Queued it, we'll see what happens with this one ;-)

--zpRN6KW+pnHWATcM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTupXjAAoJEHZH4aRLwOS6F0sQAKlwtyHHNGWLl+g5a8RaWOO0
RdhgwJq5JC7XMyCiqzqb29SlL8AtZ2FCHcu+q0MW30fvO3aKXpo+pJT57LFoVANR
YpU9bd3q1/vDceoE3/y4siatIBLsw9eYzbv/nDGRCCMDzcWRFVN+oitwzTFR4v4M
viJmHPXYXPSYWZkY3fOHxNoMpdk1niAOZ12fHyBfnGFLBWSe8/JaI3eBf/cDO3kV
wUpjec51Kihs64s8Ew+Wh+M6k53EH+bfb8ZuMFke2AvxUFft4urt6k7A1pDFqZTE
sgt2J8cClVPsmjmWJFEnOeHrF4DvLQSTqR+5nTVnUZ2hrug4cZyRw9jQYTlpY6lO
6otKpiUzJzlw8Y0mHr36aNZLZHAqwdzS+/yNKYKKIutJyqMsdFZ9D1VdwIzAWpLD
W9OYdPN0h+xTmfe/mA/TKDpdL5eZl48bS9mnicVaQvgPW55GArndh48sY63TUKyR
iNmhkAVsI4eA2mD/q8W6brqbHMQsN+6GauzSwMT/kZRK1D2Hajul8lhmaOlc81Cb
OOxzUCZzxrW4PdsQu4LKwHwXHiK8BIh6HYsbJvIkcgp+TNp64llrs7SBRTex6dXX
jZdcfigEGnTch050UzShofTsTQsXwQdIzA7EomXx5fzRnnhN89ScYN0LFAroYvhm
8VLezUB85+qXkboMvzbM
=Zoa0
-----END PGP SIGNATURE-----

--zpRN6KW+pnHWATcM--
