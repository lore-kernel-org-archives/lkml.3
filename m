Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaEIKWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:22:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaEIKW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:22:29 -0400
Date: Fri, 9 May 2014 12:22:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/20] arch,arc: Fold atomic_ops
Message-ID: <20140509102219.GW30445@twins.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135851.886055622@infradead.org>
 <C2D7FE5348E1B147BCA15975FBA230751A6AB58E@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3TQuZyvpu40ebvIM"
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751A6AB58E@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3TQuZyvpu40ebvIM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 09:34:51AM +0000, Vineet Gupta wrote:
> Hi Peter,
>=20
> Minor point below, otherwise looks good.
>=20
> > +#define atomic_clear_mask(mask, v) atomic_and(~(mask), (v))
>=20
> Given that ARC has instruction to do just that, can we keep below instead.
>=20
> ATOMIC_OP(clear_mask, ~=3D, bic)
>=20
> (see asm version of atomic_clear_mask)

Ah, yes I did notices that.

The thing is, I was going to kill clear_mask in the next set.

I'm going to introduce: atomic_{or,and,xor}() and replace all
atomic_set_mask() with atomic_or() and atomic_clear_mask() with
atomic_and(~(mask)).

One of the 'problems' is that atomic_{set,clear}_mask() are not
available on all archs and its a 'weird' interface in so far as that
most our other primitives are or/and based, I don't think we have nand.

But if people really want I suppose I could also add atomic_nand().

--3TQuZyvpu40ebvIM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKxbAAoJEHZH4aRLwOS6WeoQAIrz4mWlo5WQmtdUsrfgbiIC
CmEsKdfPB6j1wMZd96dtg8klfXkUER/ZUYX8+c681mtw8d5uCw22fbMNyME+PmfD
E/XLy6HDRPP7d6HUEg02Jz1wyGj+MZ2ZyZfThk/xjTGt7Wl7LRLAycAbmDGgnWZO
RDU+RH24KiOV+HJDegMIA5LoNL2IeJ7+eCuzwxfo/yKaYqJdKC84pmMvcrTBFfls
FImQDOllQY2rj626oP05CRW3ASEqNrNmoCKcxRZAO/OIbjAbAf4eYZbg2qYLMjTP
Top944UfyEsRqIw66G0lDYVcJl9Bk2YM74vSjk9AVUpCDPjI9TNYOQxDZvHYvdLx
MwzQ857KZxyD0Sj85CXxAEItfdq3BxH1En2ZtcT8MbWaEhL5z/cQ+1asJJ6biZdH
lYRlsOL0lp+MDYxyFk22qCypXN3JoAQPCjQ6qX85IekRMGGvxb0B3ooncPI0vYOB
f1A/AAh/2lSU4oXa08lsX6Wa/mpe6ePjX+9JcNaIdeSueU0rl/FaXvQ6+pwvOxYT
vobq7Tof2MIJEcX3W1AoUkIZxkyExTXVfROHelnHk0q+2TKn5e0krLJCnbN4VcmB
7cBouPPzen+3h6t518CPCJ6CmFVpe/hyR4H+FQ/0b4SjHLv/Xi3oPpcryNgGYfJT
XLwOOrHE/ALzFQYutxuL
=sb+Y
-----END PGP SIGNATURE-----

--3TQuZyvpu40ebvIM--
