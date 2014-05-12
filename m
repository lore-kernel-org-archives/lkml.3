Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaELGrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:47:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaELGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:47:45 -0400
Date: Mon, 12 May 2014 08:47:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140512064730.GI30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
 <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140510152902.GW11096@twins.programming.kicks-ass.net>
 <536F90BE.2080806@gmail.com>
 <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
 <20140511163531.GG30445@twins.programming.kicks-ass.net>
 <20140511145224.00412e59@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0q9y5TNQq+E02vJE"
Content-Disposition: inline
In-Reply-To: <20140511145224.00412e59@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0q9y5TNQq+E02vJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 02:52:24PM -0400, Steven Rostedt wrote:
> On Sun, 11 May 2014 18:35:31 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>=20
> > So if the wait side has already observed cond=3D=3Dfalse, then without =
the
> > wakeup, which still potentially has ->on_rq =3D=3D true, it would block.
> > Therefore the wakeup is a _real_ wakeup.
> >=20
> > We fundamentally cannot know, on the wake side, if the wait side has or
> > has not observed cond, and therefore the distinction you're trying to
> > make is a false one.
>=20
> I believe you may be misunderstanding Dongsheng. It has nothing to do
> with the wake condition. But the "success" is basically saying, "did I
> move the task on to the run queue?". That's a relevant piece of
> information that the wake up event isn't currently showing.
>=20
> Let me ask you this; with Donsheng's patch, will there ever be a
> sched_switch event when the wakeup event sees 'false' and the
> sched_switch event see the task with a state other than "R"? And if so,
> how did the task doing the wakeup event, wake up that task?

But that has nothing what so fucking ever to do with 'success'. Reusing
that trace argument for something entirely different is just retarded.

--0q9y5TNQq+E02vJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcG6CAAoJEHZH4aRLwOS6K3YQAKuUsuYsnzmHYW3YVZinjUp3
MNR0Q0kRfEBuGkH6vjWi+iTJ258CZnx8ilvomhUntBhc/Azefi9StDUhwZr2xrEb
7+yKvYB87O3Clj8tymnvMOWaR10ENQPc/6zk0+V+rNR4K5qu1WwzoqinOVzh5xk5
6z/P7oNBhtLisoU9v8eahGwtNXYAtaOsnk7pk9bqZs0TVaAqrVzRsjB4AH1I9Fxv
B0L70Aefon71VLzJ+vPG1QeiyILFm5m/gzUyZADPja5J75oSi2CcDSOBDHZH2zqq
seHifeozOxgZ6zcTqXF9xvfX0aRGUoSS+qmqWvqbVOpowfu+MJiOs00LqnVxv5fG
+Z1Ev+tVgcbeL+V+mGc8nwOv6H/qyYcelZY7WdaRGiaK3mIwUgQrhwvZURVVvn3o
Ztw/OX0etmqFBW4NDdcR5IWfegOlWin371k/Txb0OsfyI7zkrxnpMzNUPbfWi1UX
DhsYtKEzgLk6DGHqb3T3a3iDGTFVfrZRY8SiEKuKnERqu5XGowNxiP6V/LZxfJ7s
sP/1y1y2a6OtuGOq7qH02+MIoZPahdV0mJO8Eb5f5sNQ+7NqxZQ6945BGfQYuO4E
Suzb7WL3G6ElHneaKSJd8EXIWfFopMNPBgZtoGOeOIg7wV/ppqExZj6eBkCiK8yX
1FAWH8x0NmKqeGmB9FWJ
=yfK8
-----END PGP SIGNATURE-----

--0q9y5TNQq+E02vJE--
