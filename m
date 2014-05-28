Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaE1RKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:10:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaE1RKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:10:43 -0400
Date: Wed, 28 May 2014 19:10:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528171031.GV30445@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
 <20140528165144.GK29957@tassilo.jf.intel.com>
 <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hyrpr+DJ/h10HsVE"
Content-Disposition: inline
In-Reply-To: <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hyrpr+DJ/h10HsVE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:05:51PM +0200, Stephane Eranian wrote:
> On Wed, May 28, 2014 at 6:51 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >> The only part I don't quite follow here is this:
> >>                       if (__test_and_set_bit(bit, (unsigned long *)&st=
atus))
> >>                                 continue;
> >>
> >> Which seems to indicate the code is making sure each counter is
> >> processed only once. But it can only be processed once, if you have
> >> only one record. And if you have multiple, you want to be able to
> >> handle the same counter multiple times, at least once perf PEBS
> >> record. So I am a bit confused about this test.
> >
> > Each PEBS record is only for a single counter overflow. So it
> > always should only be a single perf event.
> >
> So, you're telling me this is a sanity check. That p->status can
> only have one bit set. Somehow that's not how I recall it working.
>=20
> The point is that a single PEBS record is enough for multiple
> events when the overflows occur simultaneously because they
> all get the same machine state which is correct.  A single entry
> also saves space in the buffer.

Confusion reigns.. now if only someone would write all this down in a
coherent manner and give it an official Intel stamp of approval ;-)

--hyrpr+DJ/h10HsVE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThhiHAAoJEHZH4aRLwOS6M50P/1ridUJ1ms0YU9DHHckC1IcH
LW57vIWLcRXN5AaocjefoA9/Zi0Lq1p7XtY8JGLXtjji4MOTylBxIBwCOgT64Kox
cLXKFtyIXK+DZVBgo5hNKZR+uRCKeJXgbrDpSFejbPjQJ+4+GAPKp43VeoKVm1PO
ewHQWMus/HxtsNfMUKrlUgvAHk/aJJULLL+hFTp5Yd1lme3LDulsk7q8t2+/JaFn
S3xhODoD2OM1O6zhunRta0IzaoPwPaZqPWfBPBXB9imu6Q+SE9uGiAX63jJp0Wbj
OUeNp3H4YVooyrkyuAxv8TsM9QHxIzvAmZ3FSFV4v5dOEBSuRrAWtgQWYg7GI9oI
zKVMQigJF27L4CcirYQsFhJBcxWn5WvpBxFnR+Y2Tk6jRdwQSi6CI3F5k8rxv8qq
BYX8cKFD4hBIPqLsNGSD8YR7Rr0fIfiatnrFqTOn6JVzilDLSJLi6GW/1SONooBH
YVcRWoNifPGJjuX1AyLnNj7smBcT/IUyBVHlyoEsD5d+i91LEYgUiFp3Z+54ZKpD
Hzuoq93SKKjPPB5rZybpRoK4j8pugb/kDl7dVM5M08njn5TOtsmxOXcXM1TdDX1X
BVNg3rhHT3NFr5n62f9KzjXrNj1s5PXoQ+NzhIpcfvQ8vx0mseJ/dW4xWgPaEI++
GMwjftQMwkRcNtuVppX3
=FJmA
-----END PGP SIGNATURE-----

--hyrpr+DJ/h10HsVE--
