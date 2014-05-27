Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaE0JsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:48:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaE0JsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:48:23 -0400
Date: Tue, 27 May 2014 11:48:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Libo Chen <libo.chen@huawei.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: balance storm
Message-ID: <20140527094802.GN30445@twins.programming.kicks-ass.net>
References: <5382AF2E.1040407@huawei.com>
 <1401090987.5339.79.camel@marge.simpson.net>
 <53832A36.5020205@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fNM8tsUwH0E3hRem"
Content-Disposition: inline
In-Reply-To: <53832A36.5020205@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fNM8tsUwH0E3hRem
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 07:49:10PM +0800, Libo Chen wrote:
> On 2014/5/26 15:56, Mike Galbraith wrote:
> > On Mon, 2014-05-26 at 11:04 +0800, Libo Chen wrote:=20
> >> hi,
> >>     my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a tes=
t on
> >> 3.4.24stable, startup 50 same process, every process is sample:
> >>
> >>  	#include <unistd.h>
> >>
> >>  	int main()
> >>  	{
> >>           	for (;;)
> >>           	{
> >>                   	unsigned int i =3D 0;
> >>                  	 while (i< 100){
> >>                      	 i++;
> >>                   	}
> >>                   	usleep(100);
> >>           	}
> >>
> >>          	 return 0;
> >>   	}
> >>
> >> the result is process uses 15% cpu time, perf tool shows 70w migration=
s in 5 second.
> >=20
> > My 8 socket 64 core DL980 running 256 copies (3.14-rt5) munches ~4%/copy
> > per top, and does roughly 1 sh*tload migrations, nano-work loop or not.
> > Turn SD_SHARE_PKG_RESOURCES off at MC (not a noop here), and consumption
> > drops to ~2%/copy, and migrations ('course) mostly go away.

So:=20

1) what kind of weird ass workload is that? Why are you waking up so
often to do no work?

2) turning on/off share_pkg_resource is a horrid hack whichever way
aruond you turn it.

So I suppose this is due to the select_idle_sibling() nonsense again,
where we assumes L3 is a fair compromise between cheap enough and
effective enough.

Of course, Intel keeps growing the cpu count covered by L3 to ridiculous
sizes, 8 cores isn't nowhere near their top silly, which shifts the
balance, and there's always going to be pathological cases (like the
proposed workload) where its just always going to suck eggs.

Also, when running 50 such things on a 16 cpu machine, you get roughly 3
per cpu, since their runtime is stupid low, I would expect it to pretty
much always hit an idle cpu, which in turn should inhibit the migration.

Then again, maybe the timer slack is causing you grief, resulting in all
3 being woken at the same time, instead of having them staggered.

In any case, I'm not sure what the 'regression' report is against, as
there's only a single kernel version mentioned: 3.4, and that's almost a
dinosaur.

--fNM8tsUwH0E3hRem
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThF9NAAoJEHZH4aRLwOS6Y2UP/2TIntyUYgbf2bU9+fYnAl6Y
L2WDIza9bCScjoPYSOzVeVg071ylQ+FkPd80uZXA1ZPdkPzF3Wv2C/c6TLTXPWtb
f4Jdr6xYYoEAsfSqFcd4LQmp+EKI+4ZZG++urDfzo7u339fgf58SRcd2HiPuKT6Z
mh7M7CcaCPyTUcWgtUPCzhqDyPwkJDNQI3MU+GHawtXhLHs/yCTUOjFPcDUlh53x
RIDnjKrabxcKjIE++pWAfUx8Jl73tjbXy3xwQk7bU7DVIleqJNZeyY8IO9pm4jp7
uxVx1+LumZvOglZVUo3C7tWFSXcuexWDjjWiAGS9xL540d0p2kDi4ybWZjo4kvu6
Z7qahovCBdXvarzt1s1+ZYdYKjwjBeT2FFsE6PYSEHB+OxiGoEB+MveSz1QcAX4b
rnnH50pSKNiVveYuTFjM95O29HnfooGec9194ijTcaFfNi/VjRWYueU7Tak22gqL
qYQkNHkCNpispeUOw/a7uUsyEipftF7AFJw6FxMXyDplQRqiKNf9g9ld841k7rgv
2PaMqIjsRciiqhqq+Ns5dY2B15s5BB6rzT8oCy7cZsesV0xF/4PoOEXJZvixVBbR
VbUEZaJtwjTflTfgy2+0RCxv6KJd+rUp2qmriFLPqlPDeFh3B5sxeaudNnPwBrUs
/GPb6xtrBV4OlPRCWD+d
=OAdk
-----END PGP SIGNATURE-----

--fNM8tsUwH0E3hRem--
