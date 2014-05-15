Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaEOOuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:50:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaEOOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:50:49 -0400
Date: Thu, 15 May 2014 16:50:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com
Subject: Re: [RFC PATCH 00/12 v1] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140515145042.GO30445@twins.programming.kicks-ass.net>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
 <20140505093744.GO17778@laptop.programming.kicks-ass.net>
 <20140506184637.GA17884@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QOjJmUVDSeCbcRTl"
Content-Disposition: inline
In-Reply-To: <20140506184637.GA17884@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QOjJmUVDSeCbcRTl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 02:46:37AM +0800, Yuyang Du wrote:
> > The general code structure is an immediate no go. We're not going to
> > bolt on anything like this.
>=20
> Could you please detail a little bit about general code structure?

So I should have just deleted all patches, for none of them has a
changelog.

So all this cc crap only hooks into and modifies fair.c behaviour. There
is absolutely no reason it should live anywhere else except fair.c

Secondly, the very last thing we need is more CONFIG_ goo, and you
sprinkle #ifdef around like it was gold dust.

Thirdly, wth is wrong with the current per-task runtime accounting and
why can't you extend/adapt that instead of duplicating the lot.

Fourthly, I'm _never_ going to merge anything that hijacks the load
balancer and does some random other thing. There's going to be a single
load-balancer full stop.

Many people have expressed interest in a packing balancer (vs the
spreading we currently default to). Some have even done patches.
At the same time it seems very difficult to agree on _when_ packing
makes sense. That said, when we do packing we should do it driven by the
topology and policy, not by some compile time option.

Lastly, if you'd done your homework and actually read some of the
threads on the subject from say the past two years, you'd know pretty
much all that already.

I'm not here to endlessly repeat myself and waste time staring at
unchangelogged patches.

Anyway, there might or might not be useful ideas in there.. but its very
hard to tell one way or another.

--QOjJmUVDSeCbcRTl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdNRCAAoJEHZH4aRLwOS6cqMP/AjDOwF/sgnW8hHWdruZ4o3V
iNHNkQLqrcAEkeVjfTR9KsbdAEwi2IqUYnxH++Q0IsWRjYRlZLXpjJS6jntqu3go
2jCkZYjGFBkqPDyIGflEcZkkM/HRqq/De8UzcaP6mCtUdMTt5uDLDSYkqmRozrQE
xQq8c8azHjApfi7Fkqqq5lJNKiSETeAkEXKGkDCgeSdPF01YLvFsIwoKg967dI+W
MMMJJ9CNjpZa/7TnqgcXGGNX2yMY4Zj41fwUt989zdMncxq6oUUUOllBpPddN1oA
b7y37FrLvYUqyk046JUSZ7PEgOHP9buRhtp11RZeRj/+bkjjdFv+K02qW3lCHXIw
t/NAkbcphdxBLCtnkZCE/E0NOGr4Ien+4DBMF8j3jkml9dZrqRSURX7md8rWjLej
OJS/6l2O/Jrz1GXmVZxNuld4h9xqJKuw5v6z+WlrMJeNh3eTybmoEws1ktk3oRGL
vucLExbZ2WFAyRVNku7bMGDqcdToX2uQ2JFaX0ML7ycpki9Eg+7/gCAYNAJTDa3x
7/y8p+iRhYjK1BdGb++4FnsbJ9vcZ3G6trQjzcCQ1X3iJ4O+nyFKSO88m+D7j5Ak
+KNAo76rb8x4o1mf+opNdXb3XUm2D0vo6goQ0Udw4xToaYp97Pcdsc+bHGwwTGla
hKrzvmUdg2UFhOFwleDY
=xwv9
-----END PGP SIGNATURE-----

--QOjJmUVDSeCbcRTl--
