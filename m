Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3EARLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:11:31 -0400
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:50047 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab3EARLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:11:24 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2013 13:11:24 EDT
Date: Wed, 1 May 2013 17:01:18 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Message-ID: <20130501170118.GB488@onny>
References: <20130218155439.GA902@onny>
 <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com>
 <20130223131856.GA682@onny>
 <51293A8B.5060107@zytor.com>
 <20130320143257.GA473@onny>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Content-Disposition: inline
In-Reply-To: <20130320143257.GA473@onny>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OzxllxdKGCiKxUZM
Content-Type: multipart/mixed; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
I tried the newest kernel, 3.9 today but the bug is still present.
Applying the attached patch solves the bug for me.

Best regards,
Jonas Heinrich

On 03-20 14:32, Jonas Heinrich wrote:
> Hello Peter,
> sorry for responding that late to your advice ...
>=20
> On 02-23 13:54, H. Peter Anvin wrote:
> > So to bisect anything between
> > 73201dbec64aebf6b0dca855b523f437972dc7bb and
> > 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e in a meaningful way you
> > will have to apply 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e on top.
>=20
> Hope I got you right:
>=20
> git bisect start
> # good: [73201dbec64aebf6b0dca855b523f437972dc7bb] x86, suspend: On
> # wakeup always initialize cr4 and EFER
> git bisect good 73201dbec64aebf6b0dca855b523f437972dc7bb
> # bad: [1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e] x86, suspend: Correct
> # the restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [a4a4fd9c1b2fa3687fa80177d5de7c551851906d] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad a4a4fd9c1b2fa3687fa80177d5de7c551851906d
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [be74ee62657cd7a51519946da7c4bedf7695b0da] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad be74ee62657cd7a51519946da7c4bedf7695b0da
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [10df153d76caf2464adb076d475c5c3bfce2c584] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 10df153d76caf2464adb076d475c5c3bfce2c584
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [5ccf64462e2ea53f6b446aea61c308f57224ad6c] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 5ccf64462e2ea53f6b446aea61c308f57224ad6c
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [6337a0046893906ef8dba2db30e36d7360101871] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 6337a0046893906ef8dba2db30e36d7360101871
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [49eeaeaf09fde353766ae0cc548c4cef752d90a9] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 49eeaeaf09fde353766ae0cc548c4cef752d90a9
> # cherry-picking
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
> # bad: [43d880b7fbaa831d5bab9bd3215d3053f7c69e97] x86, suspend: Correct t=
he restore of CR4, EFER; skip computing EFLAGS.ID
> git bisect bad 43d880b7fbaa831d5bab9bd3215d3053f7c69e97
>=20
> Well, don't know how to proceed here. As you could see, none of these ker=
nels worked for me.
>=20
> > If 73201dbec64aebf6b0dca855b523f437972dc7b with
> > 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e on top fails whereas the
> > previous one does, then that is very interesting and something we
> > can work with.
>=20
> git bisect reset
> git pull
> git checkout 73201dbec64aebf6b0dca855b523f437972dc7b
> git cherry-pick 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
>=20
> This kernel also does not work :(
>=20
> Best regards,=20
> Jonas Heinrich



--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S	2013-04-29 02:36:01.000000000 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-01 11:42:07.359999895 +0200
@@ -93,8 +93,8 @@
=20
 	/* Restore MISC_ENABLE before entering protected mode, in case
 	   BIOS decided to clear XD_DISABLE during S3. */
-	movl	pmode_behavior, %edi
-	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %edi
+	movl	pmode_behavior, %eax
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
 	jnc	1f
=20
 	movl	pmode_misc_en, %eax
@@ -110,15 +110,15 @@
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
=20
-	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
 1:
-	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--Lb0e7rgc7IsuDeGj--

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRgUpeAAoJEPFqEBdQ3ykkeUEIAIE9z7Wq8jKWFHlGFdrhpuqw
WUYdWyYjuZ+IbvIq7uGBLoX3VBmFnF5IpOsambIVLyaZeuwGDP8UWZVHNzFWDW+V
DlRIoEriXufS7UySLR7xHsXR9+qUq5FtHF2cP5L18wiv2rGJBOs7crGrASwaAh0S
Qa2in0bQNfsFlwul3CCvyzn8kqXLFNHSUbD63Q6e8MKPUs8Pgnwjwd1Y9vmyBNT6
D9Bhda8GtVSq1rvdepZukb/Ae5RYzHSeD4IZ3P6pu3rsbWIbWciK7suX+0CwNSyQ
sopeQYl5XJxJXjPW82yafjDBY3BPf277AVHm2nMUejv7UYF575hwYBd/jLj2Ah4=
=sVcA
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
