Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab3BHS6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:58:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760223Ab3BHS6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:58:19 -0500
Date: Fri, 8 Feb 2013 12:57:47 -0600
From: Clark Williams <williams@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130208125747.06a1e260@riff.lan>
In-Reply-To: <CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
	<1360256447.2621.75.camel@gandalf.local.home>
	<CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
	<0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
	<CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/T_FLog1dXxFo+=OhnnhnomH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T_FLog1dXxFo+=OhnnhnomH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Feb 2013 16:53:17 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/2/7 Christoph Lameter <cl@linux.com>:
> > On Thu, 7 Feb 2013, Frederic Weisbecker wrote:
> >
> >> Not with hrtick.
> >
> > hrtick? Did we not already try that a couple of years back and it turned
> > out that the overhead of constantly reprogramming a timer via the PCI b=
us
> > was causing too much of a performance regression?
>=20
> Yeah Peter said that especially reprogramming the clock everytime we
> call schedule() was killing the performances. Now may be on some
> workloads, with the tick stopped, we can find some new results.
> --

I was a little apprehensive when you started talking about multiple
tasks in Adaptive NOHZ mode on a core but the more I started thinking
about it, I realized that we might end up in a cooperative multitasking
mode with no tick at all going. Multiple SCHED_FIFO threads could
run until blocking and another would be picked. Depends on well
behaved threads of course, so probably many cases of users shooting off
some toes with this...

Of course if you mix scheduling policies or have RT throttling turned
on we'll need some sort of tick for preemption. But if we can keep the
timer reprogramming down we may see some big wins for RT and HPC loads.=20

--Sig_/T_FLog1dXxFo+=OhnnhnomH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVSqsACgkQHyuj/+TTEp1B+wCeJ6DV8ozPz/ASJfZY+X5VO6nB
G7kAn3qZq9YS0N5g1yIbosqUugk9yROi
=3118
-----END PGP SIGNATURE-----

--Sig_/T_FLog1dXxFo+=OhnnhnomH--
