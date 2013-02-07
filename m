Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3BGPrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3BGPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:47:09 -0500
Date: Thu, 7 Feb 2013 09:46:50 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130207094650.76302f47@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lv24.vBawHGER8n5mkM6XkB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lv24.vBawHGER8n5mkM6XkB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Ingo,

Is this more in line with what you wanted?=20

I moved the sysctl bits out into include/linux/sched/sysctl.h, then
updated any source dependent on sysctl bits, then added my SCHED_RR
tuning knob, then finally created include/linux/sched/rt.h to hold
most of the rt scheduler specific bits.=20

Clark Williams (3):
  sched: move sched.h sysctl bits into separate header
  sched/rt: add a tuning knob to allow changing SCHED_RR timeslice
  sched/rt: move rt specific bits into new header file

 block/blk-exec.c                  |   1 +
 drivers/spi/spi.c                 |   2 +-
 drivers/staging/csr/bh.c          |   2 +-
 drivers/staging/csr/unifi_sme.c   |   2 +-
 drivers/tty/sysrq.c               |   1 +
 fs/select.c                       |   1 +
 include/linux/sched.h             | 144 +---------------------------------=
----
 include/linux/sched/rt.h          |  58 +++++++++++++++
 include/linux/sched/sysctl.h      | 110 +++++++++++++++++++++++++++++
 init/init_task.c                  |   2 +
 kernel/futex.c                    |   1 +
 kernel/hrtimer.c                  |   2 +
 kernel/irq/manage.c               |   1 +
 kernel/rtmutex-debug.c            |   1 +
 kernel/rtmutex-tester.c           |   1 +
 kernel/rtmutex.c                  |   1 +
 kernel/sched/core.c               |  19 +++++
 kernel/sched/cpupri.c             |   2 +
 kernel/sched/rt.c                 |   6 +-
 kernel/sched/sched.h              |   2 +
 kernel/sysctl.c                   |   8 +++
 kernel/timer.c                    |   1 +
 kernel/trace/trace.c              |   1 +
 kernel/trace/trace_sched_wakeup.c |   2 +-
 kernel/watchdog.c                 |   1 +
 mm/mmap.c                         |   1 +
 mm/mremap.c                       |   1 +
 mm/page-writeback.c               |   1 +
 mm/page_alloc.c                   |   1 +
 29 files changed, 227 insertions(+), 149 deletions(-)
 create mode 100644 include/linux/sched/rt.h
 create mode 100644 include/linux/sched/sysctl.h

--=20
1.8.1


--Sig_/lv24.vBawHGER8n5mkM6XkB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlETzGoACgkQHyuj/+TTEp2YMACfV5GvSa8r9vZR4asZfZc6ak3s
xVwAoNAE4QiHkeaIaX2PYxbHelDFNc25
=P3Gn
-----END PGP SIGNATURE-----

--Sig_/lv24.vBawHGER8n5mkM6XkB--
