Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaGNTPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:15:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:53704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaGNTPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:15:15 -0400
Date: Mon, 14 Jul 2014 21:15:04 +0200
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
Message-ID: <20140714191504.GO9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XZq0mbLCR4KNTYFe"
Content-Disposition: inline
In-Reply-To: <1405364908.2970.729.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XZq0mbLCR4KNTYFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 12:08:28PM -0700, Tim Chen wrote:
> On Mon, 2014-07-14 at 20:17 +0200, Peter Zijlstra wrote:

> > Your multi-buffer thing isn't generic either, it seems lmiited to sha1.
>=20
> We actually have many other multi-buffer crypto algorithms already
> published for encryption and other IPSec usages.  So=20
> multi-buffer algorithm is not just limited to SHA1.
> We hope to port those to the kernel crypto library eventually.
> http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/=
fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf=20

That's all nice and such; but the code as I've seen in these patches is
very much sha1 specific. The mb part isn't separated out.

> > It does not reuse padata,=20
> padata tries to speed things up by parallelizing jobs to *multiple*
> cpus.  Whereas multi-buffer tries to speed things up by speeding things
> up by using multiple data lanes in SIMD register in a *single* cpu.
> These two usages are complementary but not the same.

And if its single cpu, wth do you need that nr_running thing for another
cpu for?

Also, this difference wasn't clear to me.

I still loathe all the async work, because it makes a mockery of
accounting etc.. but that's a story for another day I suppose :-(



--XZq0mbLCR4KNTYFe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxCw4AAoJEHZH4aRLwOS6TY4P/AklVJoTWm/aJpCS6h4zP3fX
a0Bt8E5dDKVvc6km38vZEHvdrSSdi4JC2IksbGSLB5MPMVwxbtQqQ32Tz8w6BKOu
W/mAIOACmApufx9url5VWgEGDjehoqIh2zcCbik5P9bG17fVU7w/IdOalstu0+KP
s28LgiIR+iMxaNDVfHt4lus2JFXI0lRg2KlgqEv1sX36kjmqApZkAPRlFW1M4zlr
Go9XZe6ANN46f4ffe123D7VGAl0DJmXMRf1kFvyRP4V88W2COIYxsnwnEcEYTGFB
gWH05NufrQgNvSC8jhCktZlHx7yuDUrc1+v4IKM76uGSFyTIsbee+YpiLzJRd/Pu
BcPlVf3UvxM3bfgCPoYUNiGgTXVGfaPGScL1yZSuAWmckvEKm2Xn2n1VyPjXxOuK
NyGGwwjXcO0hw0oP/dqzmcrECLBsmnNoUVtz0WB0GPG5NEXS9WVJpihRlLoyt1zT
2lh4Y//ZhHMfCPoFccwfzWMQ32vZUzreyaPTYfp+OEAaakUPDF16Y3CMHvSFVyjd
EYtW6+QHUQ7TnIQ02egHl2bLQ7g+heaFhsFl0DbqdrN/yoCJ4k9wu9Dg/54fosba
FkpCqZlmdSzbMOygEwsGab054nR71DyxdhdXp4dzolKpozWkXCecof94C5fMmQnO
3aWLkTYlJK+7wi807Sxx
=6dIe
-----END PGP SIGNATURE-----

--XZq0mbLCR4KNTYFe--
