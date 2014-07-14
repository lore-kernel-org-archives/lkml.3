Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaGNNgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:36:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:52117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbaGNNfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:35:52 -0400
Date: Mon, 14 Jul 2014 15:35:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140714133542.GZ9918@twins.programming.kicks-ass.net>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714114359.GA17761@krava.redhat.com>
 <20140714130237.GX9918@twins.programming.kicks-ass.net>
 <20140714132223.GC17761@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsZT+zyIIjunjBOn"
Content-Disposition: inline
In-Reply-To: <20140714132223.GC17761@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsZT+zyIIjunjBOn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 03:22:23PM +0200, Jiri Olsa wrote:
> > > if we dont do it, the event stays installed without owner and
> > > perf fork callback will be called and fail on permission checking
> > > (because of owner =3D=3D NULL) ... so yes, I think it's needed
> >=20
> > Oh, right. Alternatively, we don't need permission checking for inherits
> > at all, if we're allowed to create the initial event, we should be good
> > for inherits.
>=20
> I could adress that in follow up patch.. or you want this instead
> of this one? IMO we should close those events anyway..

I tend to agree that closing them all is nicer. But we need to be
careful while doing it so as not to make the clone/fork path block on
it.

I _think_ it might be best to separate these two issues for the moment,
so cure the reported problem by avoiding the permission check for
inherited events -- IFF you agree with the previous argument that
install_exec_creds() should be sufficient.

And then so a patch playing games with perf_event_init_context()
(clone/fork) vs perf_event_exit_task() (exit).



--JsZT+zyIIjunjBOn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw9yuAAoJEHZH4aRLwOS6mfEQAI8pabsanoHsApCDexzY2OFM
I/Thiszmd3H3biluO8H2Te+fCkzJwJGCwJn+s+K3Epx/p7cBJ4ZwWn/EYgH43WQ/
EMnWXHvu1zr+NDwNZ4Qsg56EBpW39CKiiWixFl4L6TcPaS3ySim6/jeKI7MMOKvQ
9GYJKh2rhI1fYNGpdwm95jSGS5ikfWAAmyGdjRz2l5k92MK09sFuMglT8QLyTswp
XI4Hs3R8iTsRjjpX2osMF7nUPXN8/RRLpybUX4eSeGI0awdGZ9Ebabk2vmwUrcor
Zwt6V+d1k2g/K+tSEOJo3ALUAjQo+kV41P3kUaXYcUbx9VvSt2emlGXt/jU80VQf
AbMy94q1gms23DAHc2N6PdG845ubJAwF6ppA6vRKrKfyyZZT+CRtD5Oqd4PWqdWN
abhUBV7U7fsZtMbo0KlJr0zYnA82fNPXgohjSrC1M7U07K5v4BbxPUMq8paZc2tk
MpdnUmrnDS/0b2I/y3mtFgsP+1kYDqx4o3hZrL+ofQRSPemln7vdXOHtegrx2blS
1em7VW5gdqweqYJE/7cLqzjjmeZW3rIuPvScrJ+8/OgDp+ywbMcEpQYrW5dCPK49
SpOUitNJR08wTeyOpP2W2metmXss37hmZJcQ0X/x+908O3Y+l9nCwL1orWaryOPh
ZE4vSNVFjK2oq4RrMxQZ
=Q0vA
-----END PGP SIGNATURE-----

--JsZT+zyIIjunjBOn--
