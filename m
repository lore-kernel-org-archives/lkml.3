Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaFFHBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:01:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:55979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaFFHBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:01:15 -0400
Date: Fri, 6 Jun 2014 09:01:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andev <debiandev@gmail.com>, Pranith Kumar <pranith@gatech.edu>,
        LKML <linux-kernel@vger.kernel.org>, jason.low2@hp.com
Subject: Re: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does it
Message-ID: <20140606070111.GO6758@twins.programming.kicks-ass.net>
References: <538F83DF.8090303@gatech.edu>
 <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
 <20140605072248.GE3213@twins.programming.kicks-ass.net>
 <1401990873.13877.34.camel@buesod1.americas.hpqcorp.net>
 <1401991703.13877.36.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RHdRtM27np9fZUoh"
Content-Disposition: inline
In-Reply-To: <1401991703.13877.36.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RHdRtM27np9fZUoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 11:08:23AM -0700, Davidlohr Bueso wrote:
> I knew I had formally read this technique somewhere:
> http://pdos.csail.mit.edu/6.828/2010/readings/mcs.pdf (part 2.1).
>=20
> Peter, what do you think of adding a new cmp_cmpxchg() or dcmpxchg()
> call for such scenarios?

Don't like dcmpxchg(), too easy to confuse with double-cmpxchg or
somesuch.

That said, I'm not entirely sure we want this primitive, the thing is,
people might use it ;-)

And its somewhat dangerous in that it explicitly does not provide any
kind of memory barrier on the fail path, where cmpxchg() is an
unconditional full memory barrier.

Also, you really don't want to use it in loops.

So I think it makes more sense to leave things as are and simply apply
the pattern where safe and meaningful.

--RHdRtM27np9fZUoh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkWcyAAoJEHZH4aRLwOS6DjIP/RH8K2l9E8hgXJR3oiBMhCJL
asCfpDvNENfpDVkP2PAjtTCzoKY72yGOcIbFoPXxvCkWc2irU9z6oc8qkpbVDt8s
/8WxKsfnMu3W5jbY4fY3yFWQpeC669T0f6GJYmamDqfVhEiuQJxmCMADIRAEWwcY
QeK/TwGvW7/TrJlBnAvdanv0krM7bk4QqxAZhdpZsJvc/YQYzXpIABkFHt9VlssN
pB3J6OjO+6qwmtoY0Y2Mwxj/uLSvok9PrPwCCQzmvn3rS9UuFSKIOaVVXARVAMtb
oOlS0habPO64KRmKko4fiDA6vgKUqavTLWmP0yQmTLa/UD0WvgKF4EqTot1QYVff
yp96QlCbxXkHdpmSH/TKCj6OylwNO0sYuPzsjwVJb437dnA7bnWiNg2X3eEgzMiW
XNRW/K9kwqX4otk4xxYt3cwRIq5BylSlgW82mtmdkswBfzA9SXeI6SP8/NN0t+/Z
fKtmMveoGxqRrlTHlr/bIvRlbMgryCQUpI2d7pJQxsq/lQVpwiPj7Dr1RDFUHHOq
X4MS32gEScAwYNuzBcUSgDaQlWGA/hE1nK78TvcnNmKouMdFiW0+23RNz/tSEjRB
nTQgEA60mOZJ4rMVvFjgcy7s9zy358Kgm5Y2eLpH+Ntx7M3dBU5FLfmRRc1oalyM
043yRFNdSHlCB+WeD+Z9
=14Z4
-----END PGP SIGNATURE-----

--RHdRtM27np9fZUoh--
