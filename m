Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaFJOxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:53:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:49866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaFJOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:53:31 -0400
Date: Tue, 10 Jun 2014 16:53:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
Message-ID: <20140610145327.GJ6758@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QFO1zB2dwAkGraMW"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QFO1zB2dwAkGraMW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 03:23:36PM +0200, Jiri Kosina wrote:
> +# Tell gcc to never replace conditional load with a non-conditional one
> +KBUILD_CFLAGS	+= $(call cc-option,--param allow-store-data-races=0)
> +

Why do we not want: -fmemory-model=safe? And should we not at the very
least also disable packed-store-data-races?

--QFO1zB2dwAkGraMW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlxvnAAoJEHZH4aRLwOS6JxsP/jZrr6Lus3q5zzZ9GAGYUXBd
0+8cxiiKPJ7+70Z5wc4X3QZvtUTLreHwgPi2KWqBe8JWsMl+lE6Q7mznb8Rv+tBa
otbeOxgT4kwZBv8pvXrk7ggfBA4y+43njaO/dcCy4sVUJZOi5ixvwn8Bd+I6pIzh
oktA0ZpVCySbtrj2iqRkehVMyQGAy/txObOqf8oE5rEeqE3pSlzjrozIT9xxWQhf
uHFu8FQi5Qql0IguLY0kfjFsmZtO6nEZd8ObcT2XbNgESdnexCdiyZ72WUeV6MAx
eGnog3MgfpWVkWUwc8IBMvHL7hdMy7QT35K1SihgbSRUOfQg90uuN0s04K4FWHRC
U4Mt2Cd0RBqWi+HrBMXz+1IcTuY6tzS9pNGsbhfXQZfh9OUCknSs/oQoDtvqtdCn
OK2swHGh/eIyH9QiZhZxi8MhiPf3Xwuqm8mU6UmqaybPrHuZ40RiEqnj/s2GGxgN
iFfDTqVpLpkNc7Wv/gi3VH3nlMWZtD3aeFud3oSqWALEqAZzIXTds3ORBcUYwTsz
Zx8KXMlYJTi8p478DOhLQmCoOyebNTq9+7eJbc1T9xTosFQs/3ODZHm3WHrXgp6h
WsM2vvxSIalvvYXy2JKz5Wn/ffpEB3DBPcNZFkKwRYQ6sRuVud2M72mgCHAsk5jC
UyPzr/yfkzxX+L/kO7Zd
=gRyJ
-----END PGP SIGNATURE-----

--QFO1zB2dwAkGraMW--
