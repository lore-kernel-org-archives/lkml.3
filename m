Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaEOPNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:13:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:59357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaEOPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:13:02 -0400
Date: Thu, 15 May 2014 17:12:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140515151256.GR30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140514170238.GB15690@htj.dyndns.org>
 <20140514171051.GX30445@twins.programming.kicks-ass.net>
 <20140514223648.GH15690@htj.dyndns.org>
 <20140515144113.GA2886@cmpxchg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z7K7m04Qp/nn6yf9"
Content-Disposition: inline
In-Reply-To: <20140515144113.GA2886@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z7K7m04Qp/nn6yf9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2014 at 10:41:14AM -0400, Johannes Weiner wrote:
> Is it necessary that resume paths allocate at all?  Freeing at suspend
> what you have to reallocate at resume is asking for trouble.  It's not
> just higher order allocations, either, even order-0 allocations are
> less reliable without GFP_IOFS.  So I think this should be avoided as
> much as possible.

Well, in my case its because suspend does an effective hot-unplug of all
CPUs in the system except CPU0.

And if the cpu topology changes I need to allocate new data structures
and free the old ones.

The reverse is true on resume, it hot-plugs all CPUs again, same story.

--z7K7m04Qp/nn6yf9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdNl4AAoJEHZH4aRLwOS6FWkP/1R6lWdKqo+mYmk2OoKuZnHo
BfTR1VTKRS5cBcEgMHPDz45G8ctXuiy98CoxoZCjpZaqpUe5i0+jCa5OSQZnvCze
qN8ap2glV4AappFmgfn0xL3Jf1jNNj0GxHWDNHlCOmu9JH8YO7ax30Ks1H3W1tP/
fAMGi/r0N7TpeASKIIY/F/h8bgWQ89fiHJG4IBnd5DhVebqOAIB8nx6pjx7E/kKt
s8k2JKAXlbpHj1mjnWbskEC6rx7O/eAOW6XfbIEAiWuWLzx1l9OvRfv4wIw+BnYp
fRXn7+laQcLmJgArBOWzGgEdIvi1Jz2Ggk/1E8j+O005IiMMy5uy4H0h1cyxuMEU
L7SegF4hj+vGvFixOJIogX36K0dFapPepdpWeE0Ukvx/MxBpPslEWO6S48DLjOBV
jcUn5eGM+2XwgbQZRnUM8swAlmykEkMQPba4Fn5jVTd084ySTxCzDH6eu6riL+4/
9OX7Cl4i77BzfQR02nX7GibaMilGHY7FceEAc2YEc6IHLUNSo/aQT/hwtJToAlj9
n68XlfSDPtYgWH3lvBrQkpYsp/4kMtf9IdX81WaLeoPGgfa2UdusfqrAid3hqwXU
Qfaszud0NQnGFabksStNhZyGrKxGu3TB+seKhuTladsQrqAvIglm+Es03ZDSd1MO
HlbGRUmbRgYYUAC/gLj1
=c2hW
-----END PGP SIGNATURE-----

--z7K7m04Qp/nn6yf9--
