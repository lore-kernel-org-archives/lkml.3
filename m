Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaFJNBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:01:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaFJNBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:01:42 -0400
Date: Tue, 10 Jun 2014 15:01:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610130138.GC3213@twins.programming.kicks-ass.net>
References: <20140603130233.658a6a3c@gandalf.local.home>
 <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140610083726.GY3213@twins.programming.kicks-ass.net>
 <20140610125234.GI4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7KvBbaRjXS2SFKKp"
Content-Disposition: inline
In-Reply-To: <20140610125234.GI4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7KvBbaRjXS2SFKKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 05:52:35AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 10, 2014 at 10:37:26AM +0200, Peter Zijlstra wrote:
> > On Mon, Jun 09, 2014 at 09:26:13AM -0700, Paul E. McKenney wrote:
> > > That would indeed be a bad thing, as it could potentially lead to
> > > use-after-free bugs.  Though one could argue that any code that resul=
ted
> > > in use-after-free would be quite aggressive.  But still...
> >=20
> > Let me hijack this thread for yet another issue... So I had an RCU
> > related use-after-free the other day, and while Sasha was able to
> > trigger it quite easily, I had a multi-day struggle to reproduce.
> >=20
> > Once I figured out what the exact problem was it was also clear to me
> > why it was so hard for me to reproduce.
> >=20
> > So normally its easier to trigger races on bigger machines, more cpus,
> > more concurrency, more races, all good.
> >=20
> > _However_ with RCU the grace period machinery is slower the bigger the
> > machine, so bigger machine, slower grace period, slower RCU free, less
> > likely to hit use-after-free.
> >=20
> > So I was thinking, and I know you all will go kick me for this because
> > the very last thing we need is what I'm about to propose: more RCU
> > flavours :-).
> >=20
> > How about an rcu_read_unlock() reference counted RCU variant that's
> > ultra aggressive in doing the callbacks in order to better trigger such
> > issues?
>=20
> If you are using synchronize_rcu() for the update side, then I suggest
> rcutorture.gp_exp=3D1 to force use expediting throughout.

No such luck, this was regular kfree() from call_rcu(). And the callback
execution was typically delayed long enough to never 'see' the
use-after-free.

--7KvBbaRjXS2SFKKp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlwGyAAoJEHZH4aRLwOS6yBQQAITtNht+9dCK16Jxlyk2ArPb
rqIW5pfTPuGewOzMSc3jgcj5eYiQccE3bxGq1ygo1pxleC+ehPqc6UBLKmcfUPh2
g4iVL9sAomJHnCRmxS6v7BEA5yBfqPyC9f0MhGSH20ZK+OpzodyOMiLL+WOOmBY3
lc2gmLfuvg9CXQWGPsJpk/1H3dJsY2F3GCE7HIU68fpNIQ3KfpQJkQegBvHisxV4
GtiS+w6MmCwHpH6THXnUP8rwySsSgBPIZAWQQWDsIY6C4McL8D8iplQrMcGWvpy+
JTfM/NmQ5QDEps5XL992ohDpPH8K4C64GldL+K127a2j+HI6Dhyv3AT24X2X+2QT
1oKNi/wasjKsuGSEbFEsSvEzFugE0yz6fYYdTtQfmRIKNJCf/iZfBIYMQcTmzI8v
T4i7j3sxZO/Z1h3qwCYqzrT0gnXI/5tHe86W7cygg1wphdY5PfdVO1hEG+O7iFzw
eReEA18/xCZ6vK8luOxjG1m3y/B8Khyzw2VmKFMIDGTznhjQxC6VVcYk/jcGBVaT
emZjKARjrEXJtvsUzYZYby/EwlgC8h8m50AP9OzKXK30erEd6V03n84/FyH5BVtx
kMbkug+ETYsuJFB9S0fV31IB0EQZHD2KKyV2vpgqxqNkV5rCzCrfxmuHyoKgqxna
NewdUxrE4rgBB/KYsRPZ
=rljS
-----END PGP SIGNATURE-----

--7KvBbaRjXS2SFKKp--
