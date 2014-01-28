Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaA1AnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:43:21 -0500
Received: from ozlabs.org ([203.10.76.45]:47080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaA1AnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:43:19 -0500
Date: Tue, 28 Jan 2014 11:43:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Aaron Tomlin <atomlin@redhat.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140128114313.76eed729898870aecc5f9040@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Jan_2014_11_43_13_+1100_XOp8_CRwA.kX3G0W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jan_2014_11_43_13_+1100_XOp8_CRwA.kX3G0W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
Documentation/sysctl/kernel.txt between commit 7984754b99b6 ("kexec: add
sysctl to disable kexec_load") from Linus' tree and commit 270750dbc18a
("hung_task: Display every hung task warning") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/sysctl/kernel.txt
index ee9a2f983b99,4205f3c05cbe..000000000000
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@@ -33,7 -33,10 +33,11 @@@ show up in /proc/sys/kernel
  - domainname
  - hostname
  - hotplug
+ - hung_task_panic
+ - hung_task_check_count
+ - hung_task_timeout_secs
+ - hung_task_warnings
 +- kexec_load_disabled
  - kptr_restrict
  - kstack_depth_to_print       [ X86 only ]
  - l2cr                        [ PPC only ]
@@@ -288,18 -291,44 +292,56 @@@ Default value is "/sbin/hotplug"
 =20
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
+ hung_task_panic:
+=20
+ Controls the kernel's behavior when a hung task is detected.
+ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+=20
+ 0: continue operation. This is the default behavior.
+=20
+ 1: panic immediately.
+=20
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
+ hung_task_check_count:
+=20
+ The upper bound on the number of tasks that are checked.
+ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+=20
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
+ hung_task_timeout_secs:
+=20
+ Check interval. When a task in D state did not get scheduled
+ for more than this value report a warning.
+ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+=20
+ 0: means infinite timeout - no checking done.
+=20
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
+ hung_task_warning:
+=20
+ The maximum number of warnings to report. During a check interval
+ When this value is reached, no more the warnings will be reported.
+ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+=20
+ -1: report an infinite number of warnings.
+=20
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
 +kexec_load_disabled:
 +
 +A toggle indicating if the kexec_load syscall has been disabled. This
 +value defaults to 0 (false: kexec_load enabled), but can be set to 1
 +(true: kexec_load disabled). Once true, kexec can no longer be used, and
 +the toggle cannot be set back to false. This allows a kexec image to be
 +loaded before disabling the syscall, allowing a system to set up (and
 +later use) an image without it being altered. Generally used together
 +with the "modules_disabled" sysctl.
 +
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +
  kptr_restrict:
 =20
  This toggle indicates whether restrictions are placed on

--Signature=_Tue__28_Jan_2014_11_43_13_+1100_XOp8_CRwA.kX3G0W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS5v0lAAoJEMDTa8Ir7ZwVJ2MQAIa5v66E0Xyq7drTJavr2s6R
9UQd1rHaqYwTQwEdIB0hzaFSnSZV67d87ymJ8rfX//dwjX8afl++3si2mVj7ops7
jTQuoY1pid4oucOpvySn1sheXpVsWB0pUb8KXMhZMrMwxJ1tksIgZTOWKRYgbPqs
hQhmbgbSanPG/HrY2PzTPyykfpbkOGZoxsxiXJocWuqNzbAqTMuock1yeDyocaAa
Vp6Cvk6OLUJa2QQrCsWqSh72frI3ch5ck8dzqI3dXCq2hwU9tfCHA3CIbZvWSqpm
OAeONIvxO6841qymCuj7UDZPXpc7L/TN/dv9OWBwly1uO8eKHHlQHSgJVtLH82Wq
ZDPqI8IoOrc9oVXsrh3BmNl5ReVDEh97MKyOYdBN+kNXSqI5RV7m2sdE6UVij/1y
2XOfSrvcclB/3RbZQN1tHzzmPFzO9yg0Qw83K/qJzVzr8FEkcmAEFdF6gE65q1VU
YIirDgl14fEL/Ws7w4H+AFF2fx+As4gv66qKQsgJ20PFRhtoJYAW/FqNXSZ1p3kn
1FzS1IsJvirjXAzzws7k1TTfgYUK4Wg5pJLPi3AXSyfM/TuPa/0iT2NjZDmVRxf0
rovLssKTqBhZ9XHmUM8UNqNtvCoKsildtT7G4ZoFQ1DICQ7/uGPJRic2iUAi9m/a
eagxwguj0t/yefCugiyZ
=5XXP
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jan_2014_11_43_13_+1100_XOp8_CRwA.kX3G0W--
