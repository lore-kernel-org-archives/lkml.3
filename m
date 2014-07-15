Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbaGOMHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:07:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbaGOMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:07:43 -0400
Date: Tue, 15 Jul 2014 14:07:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140715120728.GR3588@twins.programming.kicks-ass.net>
References: <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <1405367450.2970.750.camel@schen9-DESK>
 <20140715095045.GV9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+S4DbcR7QPeSsP0V"
Content-Disposition: inline
In-Reply-To: <20140715095045.GV9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+S4DbcR7QPeSsP0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 11:50:45AM +0200, Peter Zijlstra wrote:
> So you already have an idle notifier (which is x86 only, we should fix
> that I suppose), and you then double check there really isn't anything
> else running.

Note that we've already done a large part of the expense of going idle
by the time we call that idle notifier -- in specific, we've
reprogrammed the clock to stop the tick.

Its really wasteful to then generate work again, which means we have to
again reprogram the clock etc.

--+S4DbcR7QPeSsP0V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxRmAAAoJEHZH4aRLwOS6PT0P/RMh3e40x8wWWOA2RB+kTNx+
sN9rjgb8LdbOE8DNaPjdGWJMSHfVRHrTX7mLmscRNtMzx4g4r1f/KKWrvY5JJFKl
Pgk42SEFkphoe7k+vWlOr7UVhkm3excPaALJDRa/uLh7aTgmeWCBym/g0qwiuc8c
eghO466/6uWIDTyu9Cs2WbuT5/eVHD7WXxcf2IL/vEloM1WPAx3bZoklNTx2Tlty
+hGnF3YJx/igEaC+5uDKCpMpnQB43jYxGSWA3nq3cutJAsgRxAu/RgdcwObu50JD
92REXd9nUc5Q6jnVQlOUGdD15t37ZbyH2ZPfiWFHKKYw6uE+HxLpCloj/HZwhs1m
USs5RtiLOyGDJ1M2hwtXBqI2HJQtK9QYIOuEFSkzX6+ZkRq7/pBHdyEtMXEDaZEw
0XVXF1g7tM4/X0UiUfyp8f3pjbsqxRTHbQ8JJ2OmY+djamkuf06R0ZeT1wyBc5Fp
b3BdIqy1Mbs57UihYDWgorkWN3yHQpBzrMrYQhqSqszvT7n/mILokjnOWJXFOrRh
8HKhXehNir74uZeRH7l9+6/La/hTqGYEc1qYzjgJW9Y99u/8zMbK1Q7CKpgMZqYt
c0odyCQln8sJq5Wx3K2A3XZuUzKo6w/cihnY3CrRekzc7XkpL2hgvkItIdI03l6I
Q7aKMCbfLpK6vYQfvaJi
=YwD9
-----END PGP SIGNATURE-----

--+S4DbcR7QPeSsP0V--
