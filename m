Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaGPVre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:47:34 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:37646 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaGPVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:47:22 -0400
Date: Wed, 16 Jul 2014 16:47:18 -0500
From: Greg Donald <gdonald@gmail.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: find_busiest_group divide error
Message-ID: <20140716214718.GA11183@gmail.com>
References: <20140714165659.GA9289@gmail.com>
 <20140716152736.GD19379@twins.programming.kicks-ass.net>
 <20140716175259.GA5956@gmail.com>
 <53C6EF16.30506@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <53C6EF16.30506@arm.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=0x42C14D83&op=vindex
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 11:31:02PM +0200, Dietmar Eggemann wrote:
> My patch caffcdd8d27ba78730d5540396ce72ad022aff2c got rid of
> cpumask_clear(sched_group_cpus(sg)); and sg->sgp->power =3D 0; so
> reverting it (and replacing sg->sgp->power =3D 0 with
> sg->sgc->capacity =3D 0) should cure it too. (although the missing
> cpumask_clear() is the culprit on your machine here).
>=20
> Could I ask you to share the content of your /proc/cpuinfo file? I
> suspect it might be the same topology as the one Bruno just sent out
> (the one of a dual single core CPU with hyper-threading ?)
>=20
> https://lkml.org/lkml/2014/7/16/603

Sounds like what I have:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.00GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 1993.502
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs
bts cid
bogomips	: 3987.00
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.00GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 1993.502
cache size	: 512 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 6
initial apicid	: 6
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs
bts cid
bogomips	: 3987.39
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.00GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 1993.502
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs
bts cid
bogomips	: 3987.34
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.00GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 1993.502
cache size	: 512 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 7
initial apicid	: 7
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs
bts cid
bogomips	: 3987.42
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:


--=20
Greg Donald

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTxvLmAAoJEHjl9MlCwU2DK58IAPGZckoXXp6Rf32aQOvxdmtU
IDA53AuBaSl9wp20KssVj6TTgrJ761FBO9p/jMwfJz0aNt/NBQmDLc3rst1RjTL1
6hsfcbcVwcvx2L7u35LD40tU+47inGK76cOvWdvf7YRU3RdJ6bpBr97F7eQRMAfF
DiuQM3yqyqh7ySPZ1Pmxbc017g7NAyxjP90OOKiL5Br458uOUSE55/EMp/4zHs2s
uy5J11K+4Ks2EnSIWxM94yG0e39iLN18N0gW5cGzGyOpAKecdvKJfqXjnObahjqt
U6ocB9DNuHrmPfiVTtUesmeqAj7SoEvSOIZwU7Qi1vkgB9qELeAqdcA23j+Zcbc=
=BKIk
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
