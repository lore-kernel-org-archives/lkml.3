Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbaELPJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:09:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:35828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbaELPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:09:54 -0400
Date: Mon, 12 May 2014 17:09:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140512150950.GP30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
 <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140510152902.GW11096@twins.programming.kicks-ass.net>
 <536F90BE.2080806@gmail.com>
 <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
 <20140511163531.GG30445@twins.programming.kicks-ass.net>
 <20140511145224.00412e59@gandalf.local.home>
 <20140512064730.GI30445@twins.programming.kicks-ass.net>
 <20140512100908.07cc50bc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hplhpi8yEJNNWiIl"
Content-Disposition: inline
In-Reply-To: <20140512100908.07cc50bc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hplhpi8yEJNNWiIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 10:09:08AM -0400, Steven Rostedt wrote:
> On Mon, 12 May 2014 08:47:30 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>=20
> > But that has nothing what so fucking ever to do with 'success'. Reusing
> > that trace argument for something entirely different is just retarded.
>=20
> And having a "success" field that his hard coded to "true" is also
> retarded. At least this change is fucking useful.

You know why that's there :/ And yes, I started hating tracepoints a lot
more ever since that happened.

> How about this. Add a new field called 'rq_added' or something. We can
> ever shrink the size of the "success" field and hard code it to true in
> the trace. That will never change. Then the caller of the tracepoint
> will send in a "true" or "false" to "rq_added" and we can add that
> tracepoint as well.
>=20
> What I mean by shrink the size of the success field is that it is
> currently 4 bytes in size. We can make it two (or one) and then add
> another field for the 'rq_added' and have that be two bytes as well.
> This shouldn't break any tools that use this.
>=20
> Point being, this is useful information, why not pass it to userspace?

Because it adds code to one of the hottest code paths in the kernel and
so far nobody had a sane explanation of WTF they were doing.


--Hplhpi8yEJNNWiIl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcOQ4AAoJEHZH4aRLwOS6dEIP/RHb66xMxHjenH8Wg9wo5o1X
T4QAEPAGxUS0ZGQUepiEEM4Q+NGYkG5lN+urn/0/RGQBrNFY1Ea8cpQV4+ThA/3Z
0M9VDqqVVmAFA5BBJhrQJdBPh8c84C6lIkmNLFT5kG3eb5vUZOp2iZaS2j36N2sn
8Qs/Zteh6e2Ww5ZvFxcOzvbo3kfh5K/S+jhe9gyYR+Ov6OMPkGzRI6PpFB9w4k4i
ops+McFGvg6efLb333mwgPhZCvEiGgctcm3CBMWbBkkLgjALBarMNBpk2pJMYTa6
gTSmhS5aalfhJYjAqrJZcRUqZOcRlgQdlmoFyt6PwO3TMz+yW1fjr9z0NI8HcqGc
WLzUskafqC6IKyWqP1sLlt5KY1GFujbGsaZZh5Tt6R69aUcJtVScmzj2S+dRy1/7
2qyBxWbmwPyUg62XCPU65bicsNSKwETXNdXUCe7Yi9zM6CseFHTuQgj4ZX+Zh+wF
gkaWAWo1DkRN8s2o0SRAW7T8eOQqlkyjSaYlJ5T9NEd478eYTTmfVMsYD907ijIJ
2smKojce0myVqzzPTKDP9OlrA3Plw1CYvcN6Vgv0G16j+4DQ2H1SLsdiIKdBMcWX
W6otLhgtb1ArwO5fRMsmt4iFsL50x2iAxk8InEIdXuN3SrMFhevYhdfxMHPeiywq
REQ1noZX1Ov5iEnmpc+b
=+GTj
-----END PGP SIGNATURE-----

--Hplhpi8yEJNNWiIl--
