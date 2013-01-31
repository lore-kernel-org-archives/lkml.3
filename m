Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AaTwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:52:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3AaTwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:52:43 -0500
Date: Thu, 31 Jan 2013 13:52:25 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/2] move sysctl bits into new header and add a SCHED_RR
 tuning knob
Message-ID: <20130131135225.6f32af1a@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ebZMPOYnUqIywEa90E8NXxX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ebZMPOYnUqIywEa90E8NXxX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Ingo,

On your suggestion, I created the directory include/linux/sched and created=
=20
include/linux/sched/sysctl.h, which contains all the sysctl scheduler bits =
(plus a=20
few autogroup prototype definitions). If there are still objections we can =
create
autogroup.h or some other more generic entry in include/linux/sched and mov=
e them
there (or even back to include/linux/sched.h).

The second patch is just adding the SCHED_RR tuning knob to the new sysctl =
header
and the code changes to core.c, rt.c and sysctl.c.=20

I saw a few other things that might be candidates for a new file in the sch=
ed dir,
things like NO_HZ and CGROUPS but wanted to get this in place first.=20

Clark Williams (2):
  sched: create new scheduler include dir and move sysctl defs there
  sched/rt:  add a tuning knob to allow changing SCHED_RR timeslice

 include/linux/sched.h        | 108 +------------------------------------
 include/linux/sched/sysctl.h | 126 +++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched/core.c          |  19 +++++++
 kernel/sched/rt.c            |   6 ++-
 kernel/sysctl.c              |   8 +++
 5 files changed, 158 insertions(+), 109 deletions(-)
 create mode 100644 include/linux/sched/sysctl.h

--=20
1.7.11.7


--Sig_/ebZMPOYnUqIywEa90E8NXxX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEKy3kACgkQHyuj/+TTEp3N4ACgoEgPikjIFBwpHGOO+K1opcOB
Iv4AmwQ+Th+Ds9p2QPp6Q49MzzgdkkVw
=uckW
-----END PGP SIGNATURE-----

--Sig_/ebZMPOYnUqIywEa90E8NXxX--
