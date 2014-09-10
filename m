Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaIJIKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:10:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJIKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:10:09 -0400
Date: Wed, 10 Sep 2014 10:10:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers for
 scanner thread
Message-ID: <20140910081000.GN6758@twins.programming.kicks-ass.net>
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org>
 <1408536628-29379-2-git-send-email-cpandya@codeaurora.org>
 <alpine.LSU.2.11.1408272258050.10518@eggly.anvils>
 <20140903095815.GK4783@worktop.ger.corp.intel.com>
 <alpine.LSU.2.11.1409080023100.1610@eggly.anvils>
 <20140908093949.GZ6758@twins.programming.kicks-ass.net>
 <alpine.LSU.2.11.1409091225310.8432@eggly.anvils>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xwQtY96q3287+Drf"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409091225310.8432@eggly.anvils>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xwQtY96q3287+Drf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 01:14:50PM -0700, Hugh Dickins wrote:
> On Mon, 8 Sep 2014, Peter Zijlstra wrote:
> > >  		switch_mm(oldmm, mm, next);
> > > +		wake_ksm =3D ksm_switch(mm);
> >=20
> > Is this the right mm?
>=20
> It's next->mm, that's the one I intended (though the patch might
> be equally workable using prev->mm instead: given free rein, I'd
> have opted for hooking into both prev and next, but free rein is
> definitely not what should be granted around here!).
>=20
> > We've just switched the stack,
>=20
> I thought that came in switch_to() a few lines further down,
> but don't think it matters for this.

Ah, yes. Got my task and mm separation messed up.

> > so we're looing at next->mm when we switched away from current.
> > That might not exist anymore.
>=20
> I fail to see how that can be.  Looking at the x86 switch_mm(),
> I can see it referencing (unsurprisingly!) both old and new mms
> at this point, and no reference to an mm is dropped before the
> ksm_switch().  oldmm (there called mm) is mmdropped later in
> finish_task_switch().

Well, see the above confusion about switch_mm vs switch_to :-/

So if this were switch_to(), we'd see next->mm as before the last
context switch. And since that switch fully happened, it would also
already have done the finish_task_switch() -> mmdrop().



--xwQtY96q3287+Drf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEAdYAAoJEHZH4aRLwOS6A1cQAI8Vb0oUNxiFZOGEypnIBrOe
TsRhja+rHPMGJGufjUHB7KM8PPCoQv9h+lsPbVhtHo+S6JQnKS6AFUTgZomuOJrD
9cJOoTOh0fItLH0YsG9lshJngHA7YqszpqcVGhWfu9rWuWWHry1S0NvmW2Eyfg1W
nkGR742Y0T+JFqA0HiNP3/GO+G/EwMX+uW/2bf08igecE9jg0IoiHkA1hai1J1dz
IGdTBn2dkbSX6ibthhvmtGr0oBwKU/64xO6H4OXhXVim3IeSxNbBBsVIhasvTeSp
/Fxy2ptubQsXEuZ8g8R0XX+NXZ6LqycIWteO3qfGyTvttfNN7V0Z3AFxJfno1TZg
qRq/FPNEr55kSK7yaRfoX19kkEbqgC2fO0248fMqc3vmiL+UjFtr7wZUA4NXXsDB
pnJ9ESx7LqgVf0AqaoEjZOL3D+W0iQ2JYi5M7yfNaQRmXA9dlqZc/SeAH0dA4WPZ
pbo415GzR5BDrVZ58H96yw+PUcyMbxJoSD6mR21HUnrjKVsHaqHxk/CV6lKOyItp
k//n4z4HKI2aiBGiqhTCFdYi6XP2waF9C9ASeFWU5u2aDGtcUDtm8rUdWzvXHn7t
v9G0iBg5eiGNwPmJ3CgNOO2VUffBsKCoy9Jq/Pp25phIfi74jmtus0t6mHW8snbk
vdr2QsOjO08nStVEEXY8
=nrfj
-----END PGP SIGNATURE-----

--xwQtY96q3287+Drf--
