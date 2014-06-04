Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaFDNzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:55:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaFDNzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:55:06 -0400
Date: Wed, 4 Jun 2014 15:54:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, umgwanakikbuti@gmail.com,
        mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] sched,trace: Add a tracepoint for remote wakeups via
 polling
Message-ID: <20140604135458.GN30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net>
 <c932da32f908d0c0c9ea5b7f7d5fff540eb8fec6.1401841482.git.luto@amacapital.net>
 <538F186A.2060801@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2roH7liMbLpZFZp3"
Content-Disposition: inline
In-Reply-To: <538F186A.2060801@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2roH7liMbLpZFZp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 03:00:26PM +0200, Daniel Lezcano wrote:
> On 06/04/2014 02:29 AM, Andy Lutomirski wrote:
> >Remote wakeups of polling CPUs are a valuable performance
> >improvement; add a tracepoint to make it much easier to verify that
> >they're working.
> >
> >Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>=20
> I don't think this trace makes sense. The polling state is x86 only and t=
his
> trace is in the generic code.

Not so, there's PPC using it someplace (ISTR its doing a polling
amortization of the idle hypercall or somesuch) and there's archs that
have no other idle means that polling, as well as some for which its
optional.

There are indeed archs, like arm, that only do the WFI thing, and for
those this is indeed all a NOP.



--2roH7liMbLpZFZp3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjyUyAAoJEHZH4aRLwOS6g40QAKU3BFQ1GiUTctfo1nG3hhfF
IMwT0TH+ljrcRx9rXk0mMpAON5hOWjYRTOJgL3Sp3eXtzEE2U5PQKnXQt+/2Y1f7
tc62laHiEq5+7azv865TGQ2B1EUgRUAjl4U3DXa8VtSBh7Hkyu2DXTPbnWasoc+I
PHdpzNM+rQnbLm5AR+p4GcqrF3ZlfkAy4x4kqdujUGalOeVKjthW/tejyYqsTuEM
xHDEeMmPtkzY1THJriOUcv5/OBr9Syg/LetpxDpcQtqTQnWGdplS6nUlTHj1/P/i
0UaMUCB49kmiDMiOHzNcxbgY+1a57jNxS2BXHjqYh/50zJahHG/8nO6eyFn61okv
DAzRoFeqYqtpKB5yJyRK9e7SSJwmdHg/7XJIWcYmNfHFk+S2OZGLvK6sU2+uJoGf
uII4NCTDDGm5z/DU8pPn6sIpfYj529IaFdB09p3OnuwDa9x3JZnXljcarL+QXPOJ
J7GO6HPtauKynCXqF34CtOCUuE4z/qDAUDFkuczT6/JH2L8wBqrkdLZdPR6/lM/D
JAIPLFIYZaKzg6kOGEPwZDPKV3o2xSL10+uCwHgF9JZhOUFDdnueNwsnj+mVaCrw
tvZScSI76HY4g1+6Zogou8Ri0Fm0Ua7DF6h4flfoirVpXx5YiGHEh5gcnfGjf5aC
5fpgHdDExJLlfiTG8MQF
=F5bB
-----END PGP SIGNATURE-----

--2roH7liMbLpZFZp3--
