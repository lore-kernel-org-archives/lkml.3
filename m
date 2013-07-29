Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3G2GR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:17:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36440 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3G2GR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:17:58 -0400
Message-ID: <51F6090F.3080002@monstr.eu>
Date: Mon, 29 Jul 2013 08:17:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: monstr@monstr.eu, Rich Felker <dalias@aerifal.cx>,
        Michal Simek <michal.simek@xilinx.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Hogan <james.hogan@imgtec.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com> <20130724055518.GQ3249@brightrain.aerifal.cx> <51EF78BB.8000503@monstr.eu> <20130726160853.81f244ba08368e8cecab0c3b@linux-foundation.org>
In-Reply-To: <20130726160853.81f244ba08368e8cecab0c3b@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bi2CfGbvfltkF3JeI3suo37OsjRP1bCNm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bi2CfGbvfltkF3JeI3suo37OsjRP1bCNm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On 07/27/2013 01:08 AM, Andrew Morton wrote:
> On Wed, 24 Jul 2013 08:48:27 +0200 Michal Simek <monstr@monstr.eu> wrot=
e:
>=20
>> On 07/24/2013 07:55 AM, Rich Felker wrote:
>>> On Wed, Jul 24, 2013 at 07:34:07AM +0200, Michal Simek wrote:
>>>> Microblaze was assign to CLONE_BACKWARDS type where
>>>> parent tid was passed via 3rd argument.
>>>> Microblaze glibc is using 4th argument for it.
>>>>
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
>=20
> That's important information which was omitted from the changelog.=20
>=20
> Please identify the patch which casused this regression (SHA hash and
> title), thanks.

Title is here and no problem to add it to the patch.
"microblaze: switch to generic fork/vfork/clone"
(sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)
I will do v2 patch.
I see you have added v1 patch to your repo. What's the reason for that?
I expect just not to forget it, right?

Not sure if Al is on his vacation or not but will be helpful if you
can give me your ACK on that v2 patch and will send pull request directly=

to Linus.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bi2CfGbvfltkF3JeI3suo37OsjRP1bCNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlH2CRMACgkQykllyylKDCG4FgCeNK7qtbv74iHzmasUqp/vxstv
TksAn39l+2Jc+ZIHwDWWMnLoePD28NgJ
=5zTl
-----END PGP SIGNATURE-----

--bi2CfGbvfltkF3JeI3suo37OsjRP1bCNm--
