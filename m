Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab3HHAW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 20:22:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37240 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab3HHAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 20:22:56 -0400
Date: Thu, 8 Aug 2013 10:22:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        sedat.dilek@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
In-Reply-To: <87zjsted0c.fsf@linaro.org>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
	<87zjsted0c.fsf@linaro.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Aug_2013_10_22_28_+1000_5EPi9PND=42egxuc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Aug_2013_10_22_28_+1000_5EPi9PND=42egxuc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

On Wed, 07 Aug 2013 08:28:35 -0700 Kevin Hilman
<khilman@linaro.org> wrote:
>
> However, this same commit does introduce a new build failure (not
> present in next-20130806) when ext4 is built as a module:
>=20
> ERROR: "dirty_expire_interval" [fs/ext4/ext4.ko] undefined!
> make[3]: *** [__modpost] Error 1
> make[2]: *** [modules] Error 2
>=20
> The change below fixes the problem.
>=20
> Found when building the mv78xx0_defconfig on ARM.

OK, this raises an interesting question for me.  Why does an x86_64
allmodconfig build build ext4 (amongst lots of other things) into the
kernel (instead of making them modules)?

Well, it seems that normally it doesn't.  However when I do my
x86_64 allmodconfig builds, I set

CONFIG_PROFILE_ALL_BRANCHES=3Dn
CONFIG_DEBUG_INFO=3Dn
CONFIG_X86_DECODER_SELFTEST=3Dn

via the KCONFIG_ALLCONFIG=3D<file> mechanism and that is enough to make
sure that CONFIG_MODULES=3Dn - which is a bit self defeating for an
allmodconfig build. :-(

In fact, even giving an empty file to KCONFIG_ALLCONFIG=3D is enough to
turn CONFIG_MODULES off ...

These tests were done with Linus' tree of today (head commit b7bc9e7
"Merge tag 'trace-fixes-3.11-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace").

More quick testing with an empty file: v3.9 is OK, v3.10 gives
CONFIG_MODULES unset.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Aug_2013_10_22_28_+1000_5EPi9PND=42egxuc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAuTYAAoJEECxmPOUX5FEQp8P/10KFRMDxYR/OYBZgsMycv3o
Fk7MHg+ljc5NN3nimlT3Rc587o4jXeTIlXdHexjovN2IGqiBJ698uJvv5VKrRiEX
qOugsRO32MFg6lMIViQhc9LfKTDarXnr1vrXP/NUzoiuvnALSCoJTsvf7LK3SflB
sRz3/xLRjwgbPF2jTb32NaoouNq/To3VTI2e+OqumK6IkYcttxCzOOdTm4fQx6Ds
qGmdsq29brB5IFcF25jVEGBBlRe1EfZauDvbEZ7Ihb6GU7E/kO6MQbK43GPPKhQU
6fwmRA7azibU+qRd4QgY/ERIiNXT7tb55h73zolHFnx2CmtZXG+Kx8IDAjMmu1rA
0XLTg13ZbjudpbiQjoKX50wqihx43FOaTGuVzfXWAbmQi+f7EZRtblw1ztTj5vPV
Nq30ZwAcJuPtcbgZ/D9p1PrvLOazTUEIdCdHPqbB4S+lTTYSFiV3TJ/GSnNqkEos
2gQHhSl5xi1P55SxiZ21u0Oih9UvfTZWyO+o9ofMUQQoALf1y+HFw19z/yCeu+Ws
ZhETBC+qRzcH1JAn1vOq/8SBoYjLfeO0bAGbFi3MhQsLIETMg01Rnej/LpeZ1AuL
OVwf0aYgHIWmMIkb67c4HduqDsTBbQb7EBfszyeLgQ2SozkV6CHAkYrrMV94lUTe
bIsteu2Oo1ChFfG0IXHl
=YnYu
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Aug_2013_10_22_28_+1000_5EPi9PND=42egxuc--
