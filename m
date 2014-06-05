Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaFENUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:20:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFENUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:20:00 -0400
Date: Thu, 5 Jun 2014 15:19:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605131952.GI6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-10-git-send-email-eranian@google.com>
 <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
 <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LYw3s/afESlflPpp"
Content-Disposition: inline
In-Reply-To: <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LYw3s/afESlflPpp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 11:29:33AM +0200, Stephane Eranian wrote:

> If you know what you are doing (poweruser), then there are measurements
> which works fine with the HT erratum.  This is why we have the option.
>=20
> For instance if you only measure events 4x4 in system-wide mode
> and you know which counters these event are going to use, you don't
> need the workaround. For instance:
>=20
> # perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5
>=20
> Works well if you have a uniform workload across all CPUs.
> All those events leak, but the leaks balance themselves and you
> get the correct counts in the end. The advantage is that you don't
> have to multiplex. With the workaround enable, this would multiplex
> a lot.
>=20
> But as I said, this is for experts only.

Still seems tricky, you really want those pinned to make that guarantee,
and even then its a stretch. I don't think perf tool exposes the pinned
attribute though, or I'm just not looking right.

I say stretch, because while I think it'll work out and we'll end up
programming the counters the same way on each cpu, we really do not make
that guarantee either, pinned or not.

I think I agree with Matt in that exposing this to userspace is really
asking for trouble.

Now, I've not yet read through the entire patch series, but how
impossible is it to allow programming the exact same event on both HT
siblings?

--LYw3s/afESlflPpp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkG54AAoJEHZH4aRLwOS6JPIP/2HLyXjSDUHkIWSgW/iVlgqv
C/+PMnH1pB1dyZSFm/9UXyO16LQBDq1AoTO3MVWZHRjUQfDOUGwP8gRN8Q9Z0iP8
2J+nhOIW6UtsAar7VZ89pVCSTcxVBCu4pilWuFi90k6wAK98Blqjb/eWYj0PYSIA
gXLW8TmtbzkN7JQMT22NmmGfICI8daGqcIlk1kHFfITz3I63V8ZeX/TSjDyn8OTG
OZCfWuC9QF8oGsPb47CqAVJACl6OUP8CGLqOgwCKwJLwjoEdTun3e57ec0sBlopK
g3ivHB+GVvSyMk6r13TjCLn2UymKlb1vTDNBhtV2sEH4VGiH/HrRUNxbpo+4CN+y
sp6iEWeGYsNovIzrbZczI2C3cZars+M/fXD4PQYQvsrTF336lfZyVxeMZBYNuSgP
0rXPlNOQqFPPmVmgac6RCTgcR4bZ4Q8Rby1Ml392KxTJUMIb7pRnh7quDSPZctlr
iRnTFTMAMVBf/TbVPwRfnznPaQ5U9NbyKWvqxn+FTPsXZlW1sjLBnE6EkUYWUVzQ
sTNnq1en3eEWRofZMLBapE9+TQJOrNb4AABoR4Oai1fOuXZgGw5kX+WD68UQWYRh
/RLbXkHPs/7pieA4/5wEilEO8J9GUshcYkeYaIKJuN+eMUp+BXuyeuPAvhyTpDHR
qJ+snvWJjjoi7DjIEFaO
=HiYz
-----END PGP SIGNATURE-----

--LYw3s/afESlflPpp--
