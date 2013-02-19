Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3BSEQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:16:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab3BSEQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:16:29 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=F819-GTHQHoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TqI8xA6DscgA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=oGMlB6cnAAAA:8 a=5IgVrKtEPMu0tqqnlLAA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=CY6gl2JlH4YA:10 a=pTue7yctxSQPybYrAT0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219041627.412646990@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 23:15:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] tracing/syscalls: Allow archs to ignore tracing compat syscalls
References: <20130219041554.221170392@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-syscalls-Allow-archs-to-ignore-tracing-compa.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

The tracing of ia32 compat system calls has been a bit of a pain as they
use different system call numbers than the 64bit equivalents.

I wrote a simple 'lls' program that lists files. I compiled it as a i686
ELF binary and ran it under a x86_64 box. This is the result:

echo 0 > /debug/tracing/tracing_on
echo 1 > /debug/tracing/events/syscalls/enable
echo 1 > /debug/tracing/tracing_on ; ./lls ; echo 0 > /debug/tracing/tracin=
g_on

grep lls /debug/tracing/trace

[.. skipping calls before TS_COMPAT is set ...]

             lls-1127  [005] d...   936.409188: sys_recvfrom(fd: 0, ubuf: 4=
d560fc4, size: 0, flags: 8048034, addr: 8, addr_len: f7700420)
             lls-1127  [005] d...   936.409190: sys_recvfrom -> 0x8a77000
             lls-1127  [005] d...   936.409211: sys_lgetxattr(pathname: 0, =
name: 1000, value: 3, size: 22)
             lls-1127  [005] d...   936.409215: sys_lgetxattr -> 0xf76ff000
             lls-1127  [005] d...   936.409223: sys_dup2(oldfd: 4d55ae9b, n=
ewfd: 4)
             lls-1127  [005] d...   936.409228: sys_dup2 -> 0xfffffffffffff=
ffe
             lls-1127  [005] d...   936.409236: sys_newfstat(fd: 4d55b085, =
statbuf: 80000)
             lls-1127  [005] d...   936.409242: sys_newfstat -> 0x3
             lls-1127  [005] d...   936.409243: sys_removexattr(pathname: 3=
, name: ffcd0060)
             lls-1127  [005] d...   936.409244: sys_removexattr -> 0x0
             lls-1127  [005] d...   936.409245: sys_lgetxattr(pathname: 0, =
name: 19614, value: 1, size: 2)
             lls-1127  [005] d...   936.409248: sys_lgetxattr -> 0xf76e5000
             lls-1127  [005] d...   936.409248: sys_newlstat(filename: 3, s=
tatbuf: 19614)
             lls-1127  [005] d...   936.409249: sys_newlstat -> 0x0
             lls-1127  [005] d...   936.409262: sys_newfstat(fd: f76fb588, =
statbuf: 80000)
             lls-1127  [005] d...   936.409279: sys_newfstat -> 0x3
             lls-1127  [005] d...   936.409279: sys_close(fd: 3)
             lls-1127  [005] d...   936.421550: sys_close -> 0x200
             lls-1127  [005] d...   936.421558: sys_removexattr(pathname: 3=
, name: ffcd00d0)
             lls-1127  [005] d...   936.421560: sys_removexattr -> 0x0
             lls-1127  [005] d...   936.421569: sys_lgetxattr(pathname: 4d5=
64000, name: 1b1abc, value: 5, size: 802)
             lls-1127  [005] d...   936.421574: sys_lgetxattr -> 0x4d564000
             lls-1127  [005] d...   936.421575: sys_capget(header: 4d70f000=
, dataptr: 1000)
             lls-1127  [005] d...   936.421580: sys_capget -> 0x0
             lls-1127  [005] d...   936.421580: sys_lgetxattr(pathname: 4d7=
10000, name: 3000, value: 3, size: 812)
             lls-1127  [005] d...   936.421589: sys_lgetxattr -> 0x4d710000
             lls-1127  [005] d...   936.426130: sys_lgetxattr(pathname: 4d7=
13000, name: 2abc, value: 3, size: 32)
             lls-1127  [005] d...   936.426141: sys_lgetxattr -> 0x4d713000
             lls-1127  [005] d...   936.426145: sys_newlstat(filename: 3, s=
tatbuf: f76ff3f0)
             lls-1127  [005] d...   936.426146: sys_newlstat -> 0x0
             lls-1127  [005] d...   936.431748: sys_lgetxattr(pathname: 0, =
name: 1000, value: 3, size: 22)

Obviously I'm not calling newfstat with a fd of 4d55b085. The calls are
obviously incorrect, and confusing.

Other efforts have been made to fix this:

https://lkml.org/lkml/2012/3/26/367

But the real solution is to rewrite the syscall internals and come up
with a fixed solution. One that doesn't require all the kluge that the
current solution has.

Thus for now, instead of outputting incorrect data, simply ignore them.
With this patch the changes now have:

 #> grep lls /debug/tracing/trace
 #>

Compat system calls simply are not traced. If users need compat
syscalls, then they should just use the raw syscall tracepoints.

For an architecture to make their compat syscalls ignored, it must
define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS (done in asm/ftrace.h) and also
define an arch_trace_is_compat_syscall() function that will return true
if the current task should ignore tracing the syscall.

I want to stress that this change does not affect actual syscalls in any
way, shape or form. It is only used within the tracing system and
doesn't interfere with the syscall logic at all. The changes are
consolidated nicely into trace_syscalls.c and asm/ftrace.h.

I had to make one small modification to asm/thread_info.h and that was
to remove the include of asm/ftrace.h. As asm/ftrace.h required the
current_thread_info() it was causing include hell. That include was
added back in 2008 when the function graph tracer was added:

 commit caf4b323 "tracing, x86: add low level support for ftrace return tra=
cing"

It does not need to be included there.

Link: http://lkml.kernel.org/r/1360703939.21867.99.camel@gandalf.local.home

Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h      |   24 ++++++++++++++++++++
 arch/x86/include/asm/thread_info.h |    1 -
 kernel/trace/trace_syscalls.c      |   43 +++++++++++++++++++++++++++++++-=
----
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 86cb51e..0525a8b 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -72,4 +72,28 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
=20
+
+#if !defined(__ASSEMBLY__) && !defined(COMPILE_OFFSETS)
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
+#include <asm/compat.h>
+
+/*
+ * Because ia32 syscalls do not map to x86_64 syscall numbers
+ * this screws up the trace output when tracing a ia32 task.
+ * Instead of reporting bogus syscalls, just do not trace them.
+ *
+ * If the user realy wants these, then they should use the
+ * raw syscall tracepoints with filtering.
+ */
+#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	if (is_compat_task())
+		return true;
+	return false;
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_IA32_EMULATION */
+#endif /* !__ASSEMBLY__  && !COMPILE_OFFSETS */
+
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thre=
ad_info.h
index 2d946e6..2cd056e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -20,7 +20,6 @@
 struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
-#include <asm/ftrace.h>
 #include <linux/atomic.h>
=20
 struct thread_info {
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5329e13e..7a809e3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,6 @@
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
+#include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
@@ -47,6 +48,38 @@ static inline bool arch_syscall_match_sym_name(const cha=
r *sym, const char *name
 }
 #endif
=20
+#ifdef ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+/*
+ * Some architectures that allow for 32bit applications
+ * to run on a 64bit kernel, do not map the syscalls for
+ * the 32bit tasks the same as they do for 64bit tasks.
+ *
+ *     *cough*x86*cough*
+ *
+ * In such a case, instead of reporting the wrong syscalls,
+ * simply ignore them.
+ *
+ * For an arch to ignore the compat syscalls it needs to
+ * define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS as well as
+ * define the function arch_trace_is_compat_syscall() to let
+ * the tracing system know that it should ignore it.
+ */
+static int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (unlikely(arch_trace_is_compat_syscall(regs)))
+		return -1;
+
+	return syscall_get_nr(task, regs);
+}
+#else
+static inline int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return syscall_get_nr(task, regs);
+}
+#endif /* ARCH_TRACE_IGNORE_COMPAT_SYSCALLS */
+
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
 {
@@ -276,10 +309,10 @@ static void ftrace_syscall_enter(void *ignore, struct=
 pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	int size;
 	int syscall_nr;
+	int size;
=20
-	syscall_nr =3D syscall_get_nr(current, regs);
+	syscall_nr =3D trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
@@ -313,7 +346,7 @@ static void ftrace_syscall_exit(void *ignore, struct pt=
_regs *regs, long ret)
 	struct ring_buffer *buffer;
 	int syscall_nr;
=20
-	syscall_nr =3D syscall_get_nr(current, regs);
+	syscall_nr =3D trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
@@ -502,7 +535,7 @@ static void perf_syscall_enter(void *ignore, struct pt_=
regs *regs, long id)
 	int rctx;
 	int size;
=20
-	syscall_nr =3D syscall_get_nr(current, regs);
+	syscall_nr =3D trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
@@ -578,7 +611,7 @@ static void perf_syscall_exit(void *ignore, struct pt_r=
egs *regs, long ret)
 	int rctx;
 	int size;
=20
-	syscall_nr =3D syscall_get_nr(current, regs);
+	syscall_nr =3D trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIvybAAoJEOdOSU1xswtMXOYIAIOlUtMcAxGpozFvXrm0DlS3
+uT+Sl2+EGQqB6Qyx7boe2bQsspVVUtamAL+2PjiMnprj/asXDqYcoZcN+nz8CH7
Yu5CT5oSaHUTpC5rDbE+pXZ0G14dS6/Z/rjXyA3G8rIJVdqbiK7+l+ZzK9V2IrbY
/kXToXpWRm2VDBCop8kHR4bMyo9PoLjs2rm0ybfv8bkM9zgUBgoSm5LQ4T8o56II
iHSnqTaKpJt41yo83lQG8epP6Ie2uAbQTsjl82yKdmtm5v8XRsnRTvANEjwHxWb5
09oBjQCssqIRK7WLK2GdXo0A17gA8FC0UbR6zGkq4cGj4AbPm5r9xAXj87JvQVM=
=qcyy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
