Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3FFWT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:19:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3FFWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:19:13 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=R2Y-mqpH9KAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9or6cKk1a6sA:10 a=B7GdaOoYfAgkVU2bxyEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rLYXlxgVgYe95ZCdnVcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606221909.986543723@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:16:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 4/4] tracing: Use current_uid() for critical time tracing
References: <20130606221654.698742573@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Use-current_uid-for-critical-time-tracing.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="===============4743993466497247906=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============4743993466497247906==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The irqsoff tracer records the max time that interrupts are disabled.
There are hooks in the assembly code that calls back into the tracer when
interrupts are disabled or enabled.

When they are enabled, the tracer checks if the amount of time they
were disabled is larger than the previous recorded max interrupts off
time. If it is, it creates a snapshot of the currently running trace
to store where the last largest interrupts off time was held and how
it happened.

During testing, this RCU lockdep dump appeared:

[ 1257.829021] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 1257.829021] [ INFO: suspicious RCU usage. ]
[ 1257.829021] 3.10.0-rc1-test+ #171 Tainted: G        W
[ 1257.829021] -------------------------------
[ 1257.829021] /home/rostedt/work/git/linux-trace.git/include/linux/rcupdat=
e.h:780 rcu_read_lock() used illegally while idle!
[ 1257.829021]
[ 1257.829021] other info that might help us debug this:
[ 1257.829021]
[ 1257.829021]
[ 1257.829021] RCU used illegally from idle CPU!
[ 1257.829021] rcu_scheduler_active =3D 1, debug_locks =3D 0
[ 1257.829021] RCU used illegally from extended quiescent state!
[ 1257.829021] 2 locks held by trace-cmd/4831:
[ 1257.829021]  #0:  (max_trace_lock){......}, at: [<ffffffff810e2b77>] sto=
p_critical_timing+0x1a3/0x209
[ 1257.829021]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810dae5a>] __up=
date_max_tr+0x88/0x1ee
[ 1257.829021]
[ 1257.829021] stack backtrace:
[ 1257.829021] CPU: 3 PID: 4831 Comm: trace-cmd Tainted: G        W    3.10=
.0-rc1-test+ #171
[ 1257.829021] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M.=
/To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[ 1257.829021]  0000000000000001 ffff880065f49da8 ffffffff8153dd2b ffff8800=
65f49dd8
[ 1257.829021]  ffffffff81092a00 ffff88006bd78680 ffff88007add7500 00000000=
00000003
[ 1257.829021]  ffff88006bd78680 ffff880065f49e18 ffffffff810daebf ffffffff=
810dae5a
[ 1257.829021] Call Trace:
[ 1257.829021]  [<ffffffff8153dd2b>] dump_stack+0x19/0x1b
[ 1257.829021]  [<ffffffff81092a00>] lockdep_rcu_suspicious+0x109/0x112
[ 1257.829021]  [<ffffffff810daebf>] __update_max_tr+0xed/0x1ee
[ 1257.829021]  [<ffffffff810dae5a>] ? __update_max_tr+0x88/0x1ee
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810dbf85>] update_max_tr_single+0x11d/0x12d
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810e2b15>] stop_critical_timing+0x141/0x209
[ 1257.829021]  [<ffffffff8109569a>] ? trace_hardirqs_on+0xd/0xf
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810e3057>] time_hardirqs_on+0x2a/0x2f
[ 1257.829021]  [<ffffffff811002b9>] ? user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff8109550c>] trace_hardirqs_on_caller+0x16/0x197
[ 1257.829021]  [<ffffffff8109569a>] trace_hardirqs_on+0xd/0xf
[ 1257.829021]  [<ffffffff811002b9>] user_enter+0xfd/0x107
[ 1257.829021]  [<ffffffff810029b4>] do_notify_resume+0x92/0x97
[ 1257.829021]  [<ffffffff8154bdca>] int_signal+0x12/0x17

What happened was entering into the user code, the interrupts were enabled
and a max interrupts off was recorded. The trace buffer was saved along with
various information about the task: comm, pid, uid, priority, etc.

The uid is recorded with task_uid(tsk). But this is a macro that uses rcu_r=
ead_lock()
to retrieve the data, and this happened to happen where RCU is blind (user_=
enter).

As only the preempt and irqs off tracers can have this happen, and they both
only have the tsk =3D=3D current, if tsk =3D=3D current, use current_uid() =
instead of
task_uid(), as current_uid() does not use RCU as only current can change it=
s uid.

This fixes the RCU suspicious splat.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4d79485..1a41023 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -843,7 +843,15 @@ __update_max_tr(struct trace_array *tr, struct task_st=
ruct *tsk, int cpu)
=20
 	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid =3D tsk->pid;
-	max_data->uid =3D task_uid(tsk);
+	/*
+	 * If tsk =3D=3D current, then use current_uid(), as that does not use
+	 * RCU. The irq tracer can be called out of RCU scope.
+	 */
+	if (tsk =3D=3D current)
+		max_data->uid =3D current_uid();
+	else
+		max_data->uid =3D task_uid(tsk);
+
 	max_data->nice =3D tsk->static_prio - 20 - MAX_RT_PRIO;
 	max_data->policy =3D tsk->policy;
 	max_data->rt_priority =3D tsk->rt_priority;
--=20
1.7.10.4



--===============4743993466497247906==
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRsQreAAoJEOdOSU1xswtM7+cH/iWy38cC9YTlItkGi0XcH2Ju
17sXGxylLICC+8Qp8Tf7aaH+Y8dmYyPR6o2/W1mM3zG6S/zpZsfTFGmntldlk8+2
iZ0nzlHNmD63Ju6Rt5R0xX13EqwaQYXLlRkLv1iAC9CNuA10n0QRZ58ZlNmrWP+j
GDmMegL6dxCr752UPeyTh7EcIwsh431rKWfx8wJBqGpzucrIxj7Re8FnqPCoeCmJ
2OsQUO0D5VD1u0hNghyyqTUw/EBRU0f4Y+VshqGBzJIzGdspuOpdQCWvBlk0wLVf
PpIEQqNVm0nDVG0yyoNr366FtRmu99/7us6THQ+wGkx3MUbrVh2N+QTILj35jlY=
=fayN
-----END PGP SIGNATURE-----

--===============4743993466497247906==--
