Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbaGOJ6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:58:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:56587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbaGOJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:58:33 -0400
Date: Tue, 15 Jul 2014 11:58:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Chen LinX <linx.z.chen@intel.com>, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: Don't enable the perf_event without in
 PERF_ATTACH_CONTEXT status
Message-ID: <20140715095821.GW9918@twins.programming.kicks-ass.net>
References: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com>
 <20140714132756.GY19379@twins.programming.kicks-ass.net>
 <53C4ECDA.6010501@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pui5YDBJbCQuJ1A1"
Content-Disposition: inline
In-Reply-To: <53C4ECDA.6010501@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pui5YDBJbCQuJ1A1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:56:58PM +0800, Zhang, Yanmin wrote:
>=20
> On 2014/7/14 21:27, Peter Zijlstra wrote:
> >On Thu, Jul 03, 2014 at 11:36:38AM +0800, Chen LinX wrote:
> >>From: "Chen LinX" <linx.z.chen@intel.com>
> >>
> >>when do cpu hotplug test and run below perf test together, pmu may acce=
ss freed perf_event
> >>
> >>while true;
> >>do
> >>perf record -a -g -f sleep 10
> >>rm perf.*
> >>done
> >>
> >>the scenario is that when cpu offline firstly, the 'perf_cpu_notify' wi=
ll disable event on the
> >>pmu and remove it from the context list. after cpu online, the perf app=
 may enable the event
> >But it does not, right?
>=20
> Thanks for your kind comments.
> It does, actually.
> The major reason is application calls many syscall to start perf.
> 1) perf_event_open =3D> perf_install_in_context;
> 2) perf_ioctl =3D> perf_event_enable.

That still does not compute; but you're right, it does call
perf_evlist__enable() which ends up calling IOC_ENABLE when there is no
target (ie. things like perf -a), because we created things with
=2Eenable_on_exec=3D1.

Similar for ->initial_delay cruft.

> >>Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
> >>Signed-off-by: Chen LinX <linx.z.chen@intel.com>
> >Wrong SoB-chain, Yanmin didn't author this patch did he, seeing how From
> >is you. And Yanmin didn't actually send me this patch either.
>=20
> Lin works with me in the same team. He is smart, but new in kernel upstre=
am
>=20
> community. I debugged with him and he caught the root cause ahead of me.

Well, then add a Reviewed-by from you or so, the double sob doesn't make
sense.

> The patch is good.=20

No its not, its got an incomprehensible changelog, and its not at all
clear why the perf_event_enable() path that doesn't use
__perf_event_enable() is correct.


--Pui5YDBJbCQuJ1A1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxPs9AAoJEHZH4aRLwOS6+HgP/0OzwviuyisByJuh4pMruKh0
MGA1PHfmJcfYormvVKazRJNFyQnlZ2cL4tYlPotFvck+l7S3D9j3Y8ix5OofFJrM
thdwUQ8gGqS2Qej+BtJWxdkeS81WixCv3w1UwMZqv5HaedsvLSQFE6/nVg043C91
UdBvXPp6KL13qHi1YPiFGl0EKPikNXngofpCNOZ+yFGX/f/cFp+y4NDVHNMSSVZb
jOlRi6V106OWWJcaITGij81KOslB4OXgxqP/KQvdV9bdldg/AoO1wv8QYMH8u6D2
FlFNKUIww0//jKdGKXphI4SbJbHtmuU4hX7lXBch47/LxfUm0JSrnmaHHidiJ3fr
9ekOJr+GDlAPzFB6EbiEQearSHgLXxDG0P7UbFwQDmtKiSYxZvLOHMgIs7+swkyI
3KLWgPaTmCRyr4ug4rRnsOJOdU4Nn2I/k+RIGgzftE3CJ0rPDCA2Utr+hRIB2kj0
Vq2+iKAdCBfjk/8O4SsrEvvIK8MJvK+wyWwDJJwBhl/TIuWCFYPVscnf5FhP0raB
z6ET8wEBrbNoW17CcZfaGiTZFGPR4PmTPXNtWpNovW2wl1idPBFN+GzcnMxESd9w
05hTmNz+pKI8coNzG6JujCEkCA+xiZU06AqOTa+TKRn8X+YauXdFSvKObBkattCe
AvS06nTWVkJGWh1FqF0H
=Ulxf
-----END PGP SIGNATURE-----

--Pui5YDBJbCQuJ1A1--
