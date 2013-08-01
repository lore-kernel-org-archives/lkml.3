Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3HAH6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:58:37 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63409 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3HAH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:58:36 -0400
Message-ID: <51FA1528.4070709@monstr.eu>
Date: Thu, 01 Aug 2013 09:58:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, dholsgrove@xilinx.com,
        Rich Felker <dalias@aerifal.cx>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH v3] microblaze: Fix clone syscall
References: <db3f4687983a591b1797f2a54a9a8eb695afb9ac.1375081274.git.michal.simek@xilinx.com> <20130731131030.3d03c68362382dad78136cfb@linux-foundation.org>
In-Reply-To: <20130731131030.3d03c68362382dad78136cfb@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jdbE6b8V5MNUHdTdGVcAiXerTFf0KH4QM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jdbE6b8V5MNUHdTdGVcAiXerTFf0KH4QM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/31/2013 10:10 PM, Andrew Morton wrote:
> On Mon, 29 Jul 2013 09:01:48 +0200 Michal Simek <michal.simek@xilinx.co=
m> wrote:
>=20
>> Fix inadvertent breakage in the clone syscall ABI for Microblaze
>> that was introduced in this patch:
>> "microblaze: switch to generic fork/vfork/clone"
>> (sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)
>>
>> The Microblaze syscall ABI for clone takes the parent tid address in
>> the 4th argument; the third argument slot is used for the stack size.
>> The incorrectly-used CLONE_BACKWARDS type assigned parent tid to the
>> 3rd slot.
>>
>> This commit restores the original ABI so that existing userspace libc
>> code will work correctly.
>>
>> All kernel versions from v3.8-rc1 were affected.
>=20
> x86_64 allnoconfig generates screenfuls of
>=20
> In file included from fs/signalfd.c:31:
> include/linux/syscalls.h:805:5: warning: "CONFIG_CLONE_BACKWARDS3" is n=
ot defined
>=20
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
>>  asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,=
 int,
>>  	       int __user *);
>>  #else
>> +#if CONFIG_CLONE_BACKWARDS3
>=20
> Presumably ifdef here will fix that.  Please redo, retest and resend?

Yes,
I have got that email from Zero day testing system too.

Fixed in v4. I have also retest it for Microblaze.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jdbE6b8V5MNUHdTdGVcAiXerTFf0KH4QM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlH6FSgACgkQykllyylKDCHd4QCggwYFHXbvvXldBLmVTGbLSDLk
qI4AnjDbZe+ogfg6a2807pNnwmjcn9Pb
=m7Rt
-----END PGP SIGNATURE-----

--jdbE6b8V5MNUHdTdGVcAiXerTFf0KH4QM--
