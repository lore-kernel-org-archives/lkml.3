Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3BLXAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:00:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3BLXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:00:18 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=H5_e2PVA0KgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=M8Ife_2nJ54A:10 a=VwQbUJbxAAAA:8 a=IqcJqnYv90CWoy7n3jYA:9 a=QEXdDO2ut3YA:10 a=IV7YnjFe_i_KqV6KYCMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130212225412.781044738@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Feb 2013 17:54:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] sched: clean ups and a minor fix
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

The first of the patches is a minor fix to when a woken RT task is about
to preempt a pinned RT task, push_rt_task() is called to try to
migrate the woken task if possible (to avoid preempting a pinned RT
task that may be the second highest priority task in the system).

But the issue is that push_rt_task() won't push it if the woken task
is higher priority even if the task to be preempted is pinned.

The second two patches is more of a clean up to remove the idle
hooks in the scheduler proper, and to use the pre/post schedule
methods instead.

This allows interrupts to be enabled in the idle balance, which slightly
helps latencies, especially for the -rt kernel. Other patches can be
added on top. Maybe in the future preemption could be enabled during
the idle balance as well. But that remains to be seen.

Please pull the latest tip/sched/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/sched/core

Head SHA1: 1db13ecf89054d39922e7b3323d124c7e2921560


Steven Rostedt (Red Hat) (3):
      sched/rt: Fix push_rt_task() to have the same checks as the caller did
      sched: Move idle_balance() to post_schedule
      sched: Enable interrupts in idle_balance()

----
 kernel/sched/core.c      |    3 ---
 kernel/sched/fair.c      |    8 +++++---
 kernel/sched/idle_task.c |   10 ++++++++++
 kernel/sched/rt.c        |   15 ++++++++++-----
 4 files changed, 25 insertions(+), 11 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRGsl+AAoJEOdOSU1xswtMl9gH/jesTzKjuqw+c0Bgsyy3ixLR
MKv3H8oiN9WmBO95LGToAr1++yUD6s90cv3nFRH1pVFK3R4JKfGMiYyAux3C4QOg
fZ0CG3Cgq3A0kFMaDvlhwRM0Bybgq0opjmfC/Jc8uGdR6rs1Wyg8IG6Wnx0BjmvE
dNH9brUx/coyHMlnMMrokb92F5TVdo/upu1+XN22WxgFimj+F3dm4Y8JURY2XOt4
2G1ppUSSrigI8j3Pqzxwqqz883D0B/aHDPYzDqvCSbi/k6Wup5n1CYC7c/DZKgEt
1egfAgLWNtW1zLQLqUZmZ0u9TNSeGKM7niPDSXQiQRERdFkFyBjSjchSHuMJx+U=
=aQ/T
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
