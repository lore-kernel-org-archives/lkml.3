Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaGGPqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:46:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGGPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:46:45 -0400
Date: Mon, 7 Jul 2014 17:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140707154635.GG19379@twins.programming.kicks-ass.net>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
 <20140703073321.GU19379@twins.programming.kicks-ass.net>
 <20140703155237.GQ5714@two.firstfloor.org>
 <20140703170711.GW19379@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014C6431@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eGwqSfc1DN4LzNjY"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014C6431@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eGwqSfc1DN4LzNjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 01:57:16PM +0000, Liang, Kan wrote:
> > > This doesn't work, e.g. hardware debuggers can take over at any time.
> >=20
> > Tough cookies. Hardware debuggers get to deal with whatever crap they
> > cause.
>=20
> If so, I think I may discard this patch (2/3). I will resubmit the
> other two patches as a patch set to only handle the KVM issue we
> found.  It checks the access of LBR and extra MSRs at the
> initialization time and set the flags. So we just need to check the
> flags at runtime and avoid the protection by _safe().=20

Right.

> For Intel PT and LBR handling, since the PT codes haven't been
> integrated yet, I will try to implement another patch later.  The
> patch will add flags for LBR and PT.  When enabling PT, it checks LBR
> flag and update the PT flag. When enabling LBR, it checks PT flag and
> update the LBR flag. When disabling LBR/PT, we just update the related
> flags. we don't need to add _safe or extra rmsr in fast path.=20

Yeah, should be part of the PT patches.

> How do you think?

With my brain, much like all primates :-)

--eGwqSfc1DN4LzNjY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTusDbAAoJEHZH4aRLwOS61mwQAKIZg4aFSKzqWGJEeFi8rSt1
bEznCpg9IDjS3xob5I7uPPV5ph5U9cnqumOUJ9HjiwZ5g+5FRwpMKlvMU04+EvVy
nqoY2Z//3gP6x7hhIkhtxZtJzz64JSQXRBCDhvr4cXPnnHDYxhasqZX2JjtR1bf4
4tR3FmdD/zFlrm0VdWFoFIg906dcrI96ZHJj96B5g3zETfj6d/3cT8jn/mG7wYwi
QcqDZtnXMXX8iP23C5gM8FU1X24hC0NTtpOACWXpfHZAxS8/Jn8atDV/pzBEEleu
0t8lYshV9Q7A9CvoctB8A4k5Q5AmbTNTQe9acg9BehmJdDCMvO82I5UUmWPPmG+b
fAHBmVkP+nDYhKvW0rr6MoipbzcGvBiKd/8G7zH2UEhK7ENEBSaaTRFq9a8GjCUz
3ALPUnQ73hAozEfsNkDLCvpYq4r9qtH97m71XI61k/E7RptDwAEwW4w4gqpmCK9d
tWLDGOdv/C5LpLtOhhRJEqSbzgl8ElAqQNfthWV6GMEgPOtoril10ZJaECHkCQ5Z
ZcUq/pL18bx6vWoZo8mRyXa8Pr+WXHh3Atu3dfbjQqs/w4vW2959ICc3Lq0ecgm8
82d2hf9avsyubOp8YLfAAvouMPp8np8mfTQA0HZFSI7nyuB68P3ZbYl0aHocNc8n
pK4Wo/z7XMigig2oYfwj
=nnu7
-----END PGP SIGNATURE-----

--eGwqSfc1DN4LzNjY--
