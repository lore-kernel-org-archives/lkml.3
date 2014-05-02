Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaEBQWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:22:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:46102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaEBQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:22:38 -0400
Date: Fri, 2 May 2014 18:22:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140502162234.GX11096@twins.programming.kicks-ass.net>
References: <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
 <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
 <20140502154217.GW11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cz6wLo+OExbGG7q/"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cz6wLo+OExbGG7q/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 12:22:30PM -0400, Vince Weaver wrote:
>=20
> I'll try the patch next.
>=20
> Meanwhile, can polling on a closed event cause problems with the referenc=
e=20
> count?
>=20
> In my various failure traces there's always been a poll() active at the=
=20
> time of crash, and I added some trace_printk()s and it looks like poll is=
=20
> at least attempting to poll on the closed file descriptor that's causing=
=20
> us problems.

In principle the vfs file refcounting should be responsible for that.
But I'll go over it in a bit.

--cz6wLo+OExbGG7q/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY8ZKAAoJEHZH4aRLwOS64UMP/3Jc6soWnPtCH3Pk8OfAtOhF
Z7RiaKdoQA2YG05znZfKFpTXHkrnK0Kk+0iECdBybcSdik6JD7RScWQfLR6+8N7C
ENzAextG0j3lUW9izT+F0kDV5Ja4G8k9A1JdIYj7IlZCbEXK8QiVQ6L01+G4UoOM
RcnUnRducYJo76Qo1zfSd54pDmRJmt0XdvJm3IpcF7vwEM9tB2SEPU3r40Ls1b1X
pPHwqTxIzOsZnCWT/1RWg5UoIgfBwP2fT3zopNVOLlXSZJ0/K/9rowwFwM5wjaVJ
YK3r72cJ9FaVkH0F07Lk1O9cTwpzbVqn47WgF2BXhEvI95n7EFoQHgN1IjMkjLgW
4B0l/P+vEdmnopV0GiVjufYMajd6pcGBI+BwVH3+yRz6zw0S/bIN/l6axF/W7/YL
sUy77gdb5MuyzIXJqm6tBttXeN6Mx7vGIbVskP89KcqaPFbTg5Xr9gToB5o1lrdi
oSuDyAuP3QwQW2BnndHMIpe4F8mleoe5yt1HAOTamJSewtlNi/4xrxVLX2yWYo9F
Jlil9C/Dig+qIrY8lAIiTv/+zzYnhfzZcCEnbBlUVPpNRk9eVnPSqtmhayq6NA2G
uJPkAdyJekT0qJ2xMBatUkMy0ThJNnO8SHFcLSjztseopl8HwmzSHAESYgc/HWgs
zROF10Sw2zqN6VPvER9/
=nzJV
-----END PGP SIGNATURE-----

--cz6wLo+OExbGG7q/--
