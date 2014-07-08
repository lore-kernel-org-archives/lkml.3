Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaGHNCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:02:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaGHNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:02:54 -0400
Date: Tue, 8 Jul 2014 15:02:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>, pmladek@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: console: lockup on boot
Message-ID: <20140708130239.GF6758@twins.programming.kicks-ass.net>
References: <53888E76.5040101@hurleysoftware.com>
 <20140530140757.GC2419@quack.suse.cz>
 <53921116.5050804@oracle.com>
 <53972B5C.5020605@hurleysoftware.com>
 <53986DFB.9030006@oracle.com>
 <20140611203436.GD9511@quack.suse.cz>
 <20140611213111.GE9511@quack.suse.cz>
 <53991958.4070106@oracle.com>
 <20140612082645.GF9511@quack.suse.cz>
 <1402563262.5171.2.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+f314sPv49h+UVDy"
Content-Disposition: inline
In-Reply-To: <1402563262.5171.2.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+f314sPv49h+UVDy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 10:54:22AM +0200, Mike Galbraith wrote:
> On Thu, 2014-06-12 at 10:26 +0200, Jan Kara wrote:=20
> > On Wed 11-06-14 23:07:04, Sasha Levin wrote:
>=20
> > > The first patch fixed it (I assumed that there's no need to try the s=
econd).
> >   Good. So that shows that it is the increased lockdep coverage which is
> > causing problems - with my patch, lockdep is able to identify some prob=
lem
> > because console drivers are now called with lockdep enabled. But because
> > the problem was found in some difficult context, lockdep just hung the
> > machine when trying to report it... Sadly the stacktraces you posted do=
n't
> > tell us what lockdep found.
> >=20
> > Adding Peter Zijlstra to CC. Peter, any idea how lockdep could report
> > problems when holding logbuf_lock? One possibility would be to extend
> > logbuf_cpu recursion logic to every holder of logbuf_lock. That will at
> > least avoid the spinlock recursion killing the machine but we won't be =
able
> > to see what lockdep found...
>=20
> Could tell lockdep to use trace_printk().

lkml.kernel.org/r/20111221111143.401184003@chello.nl



--+f314sPv49h+UVDy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu+vvAAoJEHZH4aRLwOS6s1oP/0L+erAv/iO6E+Cr/bx7phEQ
hjTh2jxEeZbbRYsC76YhKZk/OUv8L6pCrU3LuHMcvdleiu5ie0CGhC0RGdZsYtqE
cJM9UOXne6jiqWFDN72noAJe7HL6Pq9RZ8mQbhh/heVTu7s50f3cJb5iq6F1ioVU
ulISl5fJ6y8gimwcljqRBsnqIH1R4G54vFRkEzXFmFi4gsyFFJI3EW13IPAJyOL2
Ffdz1qYHPwjYfL0WPa+I8ZBD0ZGy7UpoIlMAx8B107qjH8/E0ITioUyAAenWW+3F
2xA3cFiWZ3/bZ3gOxGy4HI67HErddJPxQIpxEWhtcibnZRrlbqrNQyuuSWrzGsAf
YlysRa82RzJCKMKZ0mQ3ZUsh8s/1IgWqLJQVhZ6Sx/e16fwVLou5/cTkKctvLmZ6
uXoaPzFNXzmiHYGWlKQHS3dVtR7h5Iqg1Zsn5vAc7KnpUp6iA1oQIWUcKQ6OJKeD
N/RHc2vsBPlytV6wSaOrEn67hO+50tgNXlj6YFpvfJ8lqINOWHdyfTPmJ+r38yiy
gJQiRB2nt+Nc3Ot7K7pnVCuvKOsbdtF+Yy2R+NXtdeoYyCxLS06F50sAF/fqjoiC
c/Rr5BEDwGBlJ4Kf7DJ2zVVZecaxGspy2eC05htZovV0HqTnmFJ1coJf/wUEyQT5
+WJUj/FaL+wzCzZfbGrQ
=T22Z
-----END PGP SIGNATURE-----

--+f314sPv49h+UVDy--
