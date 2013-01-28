Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3A1UbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:31:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3A1UbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:31:22 -0500
Date: Mon, 28 Jan 2013 14:31:05 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] sched:  move sysctl bits into new header and add a
 SCHED_RR tuning knob
Message-ID: <20130128143105.7e800341@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m_9EVqBjs3jQSiP1K0ES/5n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m_9EVqBjs3jQSiP1K0ES/5n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ingo,

What follows are the changes I submitted earlier as two patches. The
first creates the new file include/linux/sched_sysctl.h and moves all
the existing sysctl scheduler knobs into there. The second creates a
new scheduler tuning knob which allows changes the SCHED_RR timeslice
value.=20

These patches are against tip/master.

Clark Williams (2):
  sched: move scheduler sysctl bits into dedicated header file
  sched/rt:  add a tuning knob to allow changing RR timeslice

 include/linux/sched.h        | 102 +----------------------------------
 include/linux/sched_sysctl.h | 126 +++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched/core.c          |  18 +++++++
 kernel/sched/rt.c            |   6 ++-
 kernel/sysctl.c              |   8 +++
 5 files changed, 157 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/sched_sysctl.h

--=20
1.7.11.7


--Sig_/m_9EVqBjs3jQSiP1K0ES/5n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEG4AkACgkQHyuj/+TTEp0HswCfQmFjnQrQnf8F+BTkA7f2VMAj
GcwAn2J3fYb3yHmGYb+kWtCWh9Af1ppL
=E1U4
-----END PGP SIGNATURE-----

--Sig_/m_9EVqBjs3jQSiP1K0ES/5n--
