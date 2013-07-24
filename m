Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3GXHQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:16:10 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46340 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3GXHQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:16:08 -0400
Message-ID: <51EF7F33.8020305@monstr.eu>
Date: Wed, 24 Jul 2013 09:16:03 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rich Felker <dalias@aerifal.cx>
CC: Michal Simek <michal.simek@xilinx.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Hogan <james.hogan@imgtec.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com> <20130724055518.GQ3249@brightrain.aerifal.cx> <51EF78BB.8000503@monstr.eu> <20130724065957.GR3249@brightrain.aerifal.cx>
In-Reply-To: <20130724065957.GR3249@brightrain.aerifal.cx>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WMFDHDNWEDFSAPBXEWKI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WMFDHDNWEDFSAPBXEWKI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/24/2013 08:59 AM, Rich Felker wrote:
> On Wed, Jul 24, 2013 at 08:48:27AM +0200, Michal Simek wrote:
>>>> Create new CLONE_BACKWARDS3 type where stack_size is passed
>>>> via 3rd argument, parent thread id pointer via 4th,
>>>> child thread id pointer via 5th and tls value as 6th
>>>> argument
>>>
>>> I believe this also affects us in musl. What is the motivation for
>>> making a configure option that results in there being two incompatibl=
e
>>> syscall ABIs for the same arch?
>>> This sounds like a really bad idea...
>>
>> This patch fixes bug which was introduced by Al's patch where he moved=

>> clone implementation from microblaze folder to generic location.
>> It means I am not creating two incompatible syscalls ABIs but fixing
>> broken one.
>=20
> So this patch is just fixing a regression in the kernel?

yes.


>>> And how was glibc successfuly using a form that mismatched the
>>> existing kernel? Did nobody ever use/test it?
>>
>> We are running LTP syscall tests and there is not LTP test which
>> was able to find out this mismatch in clone. That's why I haven't
>> figure it out at that time and ACKed that origin patch.
>=20
> I would think pthread_create would have broken pretty badly; I
> remember early-on in porting musl to microblaze, we had the clone
> arguments misordered, and it blew up badly. ;) Perhaps you could just
> run some general libc/libpthread level tests to catch things like this
> that are hard to measure at the syscall-test level with existing
> tests.

David was running glibc tests and I was also running some pthreads tests
but we have seen the problem only on timer_create tests we have got from
customer.
I found that we should maybe invest our time to open posix testsuite
to get another set of tests we should run.

BTW: Where to get musl package and are there any tests we should regularl=
y run?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WMFDHDNWEDFSAPBXEWKI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHvfzMACgkQykllyylKDCFxpwCghIuUzmlFFlJpuLPm0J+/s/lj
fFoAniHCe6Iz+UgfprnO06cTKnQlPTYP
=nnSE
-----END PGP SIGNATURE-----

------enig2WMFDHDNWEDFSAPBXEWKI--
