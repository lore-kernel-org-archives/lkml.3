Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3GXGsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:48:37 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52518 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3GXGsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:48:36 -0400
Message-ID: <51EF78BB.8000503@monstr.eu>
Date: Wed, 24 Jul 2013 08:48:27 +0200
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
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com> <20130724055518.GQ3249@brightrain.aerifal.cx>
In-Reply-To: <20130724055518.GQ3249@brightrain.aerifal.cx>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2MJMCEHFAWIFLQTLKFGVU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2MJMCEHFAWIFLQTLKFGVU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Rich,

On 07/24/2013 07:55 AM, Rich Felker wrote:
> On Wed, Jul 24, 2013 at 07:34:07AM +0200, Michal Simek wrote:
>> Microblaze was assign to CLONE_BACKWARDS type where
>> parent tid was passed via 3rd argument.
>> Microblaze glibc is using 4th argument for it.
>>
>> Create new CLONE_BACKWARDS3 type where stack_size is passed
>> via 3rd argument, parent thread id pointer via 4th,
>> child thread id pointer via 5th and tls value as 6th
>> argument
>=20
> I believe this also affects us in musl. What is the motivation for
> making a configure option that results in there being two incompatible
> syscall ABIs for the same arch?
> This sounds like a really bad idea...

This patch fixes bug which was introduced by Al's patch where he moved
clone implementation from microblaze folder to generic location.
It means I am not creating two incompatible syscalls ABIs but fixing
broken one.

> And how was glibc successfuly using a form that mismatched the
> existing kernel? Did nobody ever use/test it?

We are running LTP syscall tests and there is not LTP test which
was able to find out this mismatch in clone. That's why I haven't
figure it out at that time and ACKed that origin patch.

In my email you can see that I have also asked about tools which should b=
e used
for kernel API testing.

> I think the broken
> userspace software that was already failing to work due to this
> mismatch should simply be fixed rather than adding incompatible kernel
> ABI variants.

The incompatibility is between glibc register setup and the kernel sys_cl=
one
register expectation which doesn't match right now.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2MJMCEHFAWIFLQTLKFGVU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHveLsACgkQykllyylKDCFr9ACgkkKP0zb/UUQq3PspySAT30O9
+bcAoJAZr9/vcxMQSBSpIQeOed7h+kWH
=uuar
-----END PGP SIGNATURE-----

------enig2MJMCEHFAWIFLQTLKFGVU--
