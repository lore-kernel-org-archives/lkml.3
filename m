Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaGIIc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:32:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:58247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaGIIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:32:24 -0400
Date: Wed, 9 Jul 2014 10:32:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709083214.GA9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_=
event.c
> index 2bdfbff..f0e8022 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf=
_event *event)
>  			continue;
>  		if (event->attr.config1 & ~er->valid_mask)
>  			return -EINVAL;
> +		/* Check if the extra msrs can be safely accessed*/
> +		if (!x86_pmu.extra_msr_access[er->idx])
> +			continue;
> =20
>  		reg->idx =3D er->idx;
>  		reg->config =3D event->attr.config1;

You should return an error here; doing continue will eventually make
it return 0, which is no-error and things will happily create the event
and malfunction.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvP4KAAoJEHZH4aRLwOS6d7cQAKS9uQPjlauA/1mXOCqHx1LD
zHpeFh8dXH3C2PaeI0k7PkPQKOk5pbUjZN2DPKgINUKtcJpDpMhfCA2+WlPt1Kaf
pDKjmPd4RNXjt/KEQLnodAJatc62KqPasf7ogbEiIUky7lq4Ezu6lrVi8efCHcmI
qyyqlRk+Ep3LTCXSb5JoJzgGWt0WodpUaPpnh8c+sNaPtYhdBfo1ygLyazsVX/W6
l/zT0gPuY1XfYxqt+lH9gVnfnYDjDx/YoG2PQFYfvqWE5SaprvNZHfd9bwRqKQJt
/eCE0ihulO3FcZmMux8ufM1J22YCOur7O9W9zpwjsqoq9rhpInoMVgpGKPFZaLXX
34BYI7fGVymu7v9gfYJRZl7FZ6Z3CtKntwFkN6eTDuqDnKXyIvrj91inUnrUd1TI
cJlcBQ7vxKr+KKh1aCjQKf5FuJHXuJfHHRZt8r7ICL5YGxeYbbjw+Tj5GJSeYSUF
77s+4dYLSebgJuufWlvyjDEqX8Bn/HHAR7QXFlcNeyKQzBUjjNYeAjXK1iUgU1S3
A8N6P4Sv551Og38KFDKcS+UdQFqqdVy5O7fZ6EV7o0vPkhRHEA+REiCtZP5f0vRi
VO1L1oU6TIQfYAe0kF3KK2Rk0mKTzteLDULHWINh7S19n1uZdygWtOzKYEBGdNQp
77Os21vcRHFdDs6ovvFk
=8tWv
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
