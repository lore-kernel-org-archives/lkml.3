Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3BSFau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:30:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19180 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3BSFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:30:47 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=St6oyMYu99MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ICH0LHA2qHQA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=RS_Fx8fcj6MjFW4DvnMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=gkqcZIZ8LJXiGu7MJYQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219053045.352192700@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 00:30:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Kacur <jkacur@gmail.com>, Clark Williams <clark@redhat.com>,
        <stable-rt@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] acpi/rt: Convert acpi_gbl_hardware lock back to a raw_spinlock_t
References: <20130219053021.721159211@goodmis.org>
Content-Disposition: inline; filename=0002-acpi-rt-Convert-acpi_gbl_hardware-lock-back-to-a-raw.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

We hit the following bug with 3.6-rt:

[    5.898990] BUG: scheduling while atomic: swapper/3/0/0x00000002
[    5.898991] no locks held by swapper/3/0.
[    5.898993] Modules linked in:
[    5.898996] Pid: 0, comm: swapper/3 Not tainted 3.6.11-rt28.19.el6rt.x86=
_64.debug #1
[    5.898997] Call Trace:
[    5.899011]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90
[    5.899028]  [<ffffffff81577923>] __schedule+0x793/0x7a0
[    5.899032]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0=
x200
[    5.899034]  [<ffffffff81577b89>] schedule+0x29/0x70
[    5.899036] BUG: scheduling while atomic: swapper/7/0/0x00000002
[    5.899037] no locks held by swapper/7/0.
[    5.899039]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0
[    5.899040] Modules linked in:
[    5.899041]
[    5.899045]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90
[    5.899046] Pid: 0, comm: swapper/7 Not tainted 3.6.11-rt28.19.el6rt.x86=
_64.debug #1
[    5.899047] Call Trace:
[    5.899049]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40
[    5.899052]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90
[    5.899054]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80
[    5.899056]  [<ffffffff81577923>] __schedule+0x793/0x7a0
[    5.899059]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23
[    5.899062]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0=
x200
[    5.899068]  [<ffffffff8130be64>] acpi_write_bit_register+0x33/0xb0
[    5.899071]  [<ffffffff81577b89>] schedule+0x29/0x70
[    5.899072]  [<ffffffff8130be13>] ? acpi_read_bit_register+0x33/0x51
[    5.899074]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0
[    5.899077]  [<ffffffff8131d1fc>] acpi_idle_enter_bm+0x8a/0x28e
[    5.899079]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90
[    5.899081]  [<ffffffff8107e5da>] ? this_cpu_load+0x1a/0x30
[    5.899083]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40
[    5.899087]  [<ffffffff8144c759>] cpuidle_enter+0x19/0x20
[    5.899088]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80
[    5.899090]  [<ffffffff8144c777>] cpuidle_enter_state+0x17/0x50
[    5.899092]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23
[    5.899094]  [<ffffffff8144d1a1>] cpuidle899101]  [<ffffffff8130be13>] ?

As the acpi code disables interrupts in acpi_idle_enter_bm, and calls
code that grabs the acpi lock, it causes issues as the lock is currently
in RT a sleeping lock.

The lock was converted from a raw to a sleeping lock due to some
previous issues, and tests that showed it didn't seem to matter.
Unfortunately, it did matter for one of our boxes.

This patch converts the lock back to a raw lock. I've run this code on a
few of my own machines, one being my laptop that uses the acpi quite
extensively. I've been able to suspend and resume without issues.

[ tglx: Made the change exclusive for acpi_gbl_hardware_lock ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@gmail.com>
Cc: Clark Williams <clark@redhat.com>
Link: http://lkml.kernel.org/r/1360765565.23152.5.camel@gandalf.local.home
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/hwregs.c    |    4 ++--
 drivers/acpi/acpica/hwxface.c   |    4 ++--
 drivers/acpi/acpica/utmutex.c   |    4 ++--
 include/acpi/platform/aclinux.h |   14 ++++++++++++++
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 73863d8..3d208c8 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -230,7 +230,7 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * interrupt level
  */
 ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and r=
egisters */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except G=
PE registers */
+ACPI_EXTERN acpi_raw_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W exce=
pt GPE registers */
=20
 /*************************************************************************=
****
  *
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 55accb7..1da9213 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,7 +263,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
=20
 	/* Clear the fixed events in PM1 A/B */
=20
@@ -278,7 +278,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status =3D acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index f75f81a..94a33ce 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -386,7 +386,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
=20
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -447,7 +447,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
=20
 unlock_and_exit:
=20
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 7d797e2..b611bf3 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -88,7 +88,7 @@ acpi_status acpi_ut_mutex_initialize(void)
 		return_ACPI_STATUS (status);
 	}
=20
-	status =3D acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	status =3D acpi_os_create_raw_lock (&acpi_gbl_hardware_lock);
 	if (ACPI_FAILURE (status)) {
 		return_ACPI_STATUS (status);
 	}
@@ -135,7 +135,7 @@ void acpi_ut_mutex_terminate(void)
 	/* Delete the spinlocks */
=20
 	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
+	acpi_os_delete_raw_lock(acpi_gbl_hardware_lock);
=20
 	/* Delete the reader/writer lock */
=20
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinu=
x.h
index 2ce1be9..17d24de 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -74,6 +74,7 @@
=20
 #define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                       spinlock_t *
+#define acpi_raw_spinlock                   raw_spinlock_t *
 #define acpi_cpu_flags                      unsigned long
=20
 #else /* !__KERNEL__ */
@@ -177,6 +178,19 @@ static inline void *acpi_os_acquire_object(acpi_cache_=
t * cache)
 	lock ? AE_OK : AE_NO_MEMORY;				\
 })
=20
+#define acpi_os_create_raw_lock(__handle)			\
+({								\
+	raw_spinlock_t *lock =3D ACPI_ALLOCATE(sizeof(*lock));	\
+								\
+	if (lock) {						\
+		*(__handle) =3D lock;				\
+		raw_spin_lock_init(*(__handle));		\
+	}							\
+	lock ? AE_OK : AE_NO_MEMORY;				\
+})
+
+#define acpi_os_delete_raw_lock(__handle)	kfree(__handle)
+
 #endif /* __KERNEL__ */
=20
 #endif /* __ACLINUX_H__ */
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIw4FAAoJEOdOSU1xswtMNcgIAMRWcBs+5/Z9QsDZ7bj5azTJ
gm1xvN1s4LVPq2cIGLQfDj3YrIfGXkNl9cn5+bj8jG+ytu2Ola5m9TD1m3lOHTZV
z3DhX7cJLlLWi1DdvNesCl5NYkgrYQlem+XEMRXX78UoUAj0YxxZx1aFg5E+TMZw
cN+GLExAAe/U9cC7DaIIFTrw6xfxcJyuxL1H6NIhvuImaJiFmMv4aFiDkbzUeOqi
9xZqOos/LV2j8ZbGkCL1tegMCpAaKtwt5zCqUTlkSsuyp5l9Vdihmxkl0tm4s08A
uljV5YsfpLWJvfOxnHWAupHC4aTNHgMjOdyCwtEff0Oqv67vRWphZjBhLypONlE=
=t3bz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
