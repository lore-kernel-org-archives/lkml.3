Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaETO2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:28:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:34306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaETO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:28:10 -0400
Date: Tue, 20 May 2014 16:28:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: "bsegall@google.com" <bsegall@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "chris.j.arges@canonical.com" <chris.j.arges@canonical.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140520142804.GB30445@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
 <20140519103247.GX30445@twins.programming.kicks-ass.net>
 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140520131526.GE11096@twins.programming.kicks-ass.net>
 <99801400595675@webcorp1f.yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Epdev7n9Nu0o9kVy"
Content-Disposition: inline
In-Reply-To: <99801400595675@webcorp1f.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Epdev7n9Nu0o9kVy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 06:21:15PM +0400, Roman Gushchin wrote:
> 20.05.2014, 17:15, "Peter Zijlstra" <peterz@infradead.org>:
> > Completely untested... does anybody have a 'useful' test case for this
> > bw stuff?
>=20
> I can test it for stability.
> I'll start tomorrow, now I'm testing Ben's + my patches together.

Do you have an easy to reproduce setup and workload so I might be able
to test as well? Or are you simply dumping it in 'production' to see
what happens?

I mean, the trivial setup with a few cgroups and spinners isn't that
interesting because it'll just keep the timer ticking and never go idle.

I suppose I could try writing a sleep/spinner which randomly exceeds bw
constraints.

--Epdev7n9Nu0o9kVy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTe2Z0AAoJEHZH4aRLwOS6dngP/20hRT0SW+AhScht3lFLjLUE
iki8Ex/pF9UXAV4LjX04t2yYNIgG/B8qO+a+vo5Rr0hlOwTP5foitnRQXQht9JJe
oIn+j7jfjjX7XQJ/cR3BYlVR+GfmnCOsr15/imthi9u7SVAKQRDLmmQZ1OgtGv8v
eCBqX61n+Z7CtGsnI/d3AIPSIXJthGRyDVXMy+Gd8xM8iBuiiJNDmNL1jTn0C9iB
rPEAAgv3Jdp0tVZc3z3b2Df+3Z7v78nhMNgt7l44ja5DSQnaLpkJX0ywkh3GWGG3
BA6qjxGgtMM9CNOOILsDLdRM1Qm9wWmCTpY1ePNbezwq1BkgDvI2efEJ5PMQPupW
rxxLSYFUC/GtcCFA8Qb6n8aFFjh6PNTEJn369tLD3bcGLlYpPVi+TG2xdsdZBnB5
FxFiHFXinhGq9gVhMhjeBEkhCwbLTY9pKM2ksOlfct6y5Phx8w2/3+43kFvGKQzv
T92rM40Q/6R/+n3BQFRulSdqK6n7PJ5ohwztJUPhDaP1xatryuC34MqvTKse+IsX
no9mmvuev4Ou3CE4hShCIZZmD6tK5TkdvzA8HXPcZGTipNYikhZ74XuQ2AWONrU8
bEFMTvuMUQ3DE9XsvdwojOSlLiDGBWWKfXIZ9e0RRP6o3/qoQPlqFfNxJHfuGsDL
rcOWNqEjvlPlfNE4ZeAP
=b/yB
-----END PGP SIGNATURE-----

--Epdev7n9Nu0o9kVy--
