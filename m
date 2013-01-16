Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3APVtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:49:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40205 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3APVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:49:18 -0500
Message-ID: <50F72047.6000904@pengutronix.de>
Date: Wed, 16 Jan 2013 22:48:55 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Subodh Nijsure <snijsure@grid-net.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, penguin-kernel@I-love.SAKURA.ne.jp,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-security-module@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [v4] Add security.* XATTR support for the UBIFS
References: <1336915488-23943-1-git-send-email-snijsure@grid-net.com> <50F57A30.10109@pengutronix.de>
In-Reply-To: <50F57A30.10109@pengutronix.de>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2IXEIIHWAETEAODBOHVRI"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2IXEIIHWAETEAODBOHVRI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/15/2013 04:48 PM, Marc Kleine-Budde wrote:
> On 05/13/2012 05:24 AM, Subodh Nijsure wrote:
>> From: Subodh Nijsure <snijsure@grid-net.com>
>>
>> Also fix couple of bugs in UBIFS extended attribute length calculation=
=2E
>>
>> Changes in v4:
>>         Fix lock issues introduced in v3.
>>         Tested with CONFIG_SECURITY enabled & disabled.
>>
>> Changes in v3:
>> 	 Remove #ifdef CONFIG_UBIFS_FS_XATTR
>>
>> Changes in v2:
>>          Instead of just handling security.selinux extended attribute =
handle
>>          all security.* attributes.
>>
>> TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4=
 NAND
>>          With these change we are able to label UBIFS filesystem with
>>          security.selinux and run system with selinux enabled.
>>          This change also allows one to set other security.* extended
>>          attributes, such as security.smack security.evm, security.ima=

>>          Ran integck test on UBI filesystem.
>>          This patch set has been tested with CONFIG_LOCKDEP=3Dy and ot=
her options
>>          suggested in Submitchecklist
>>
>> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
>=20
> What's the status of this patch? Was there a v5?

I've ported v4 to v3.7.2 and get this deadlock:

> [   18.870000] UBIFS: background thread "ubifs_bgt0_0" started, PID 101=

> [   20.650000]
> [   20.650000] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   20.650000] [ INFO: possible circular locking dependency detected ]
> [   20.650000] 3.7.2-00001-g8cdd29c #2 Not tainted
> [   20.650000] -------------------------------------------------------
> [   20.650000] systemd-rc-once/79 is trying to acquire lock:
> [   20.650000]  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<c01afe64>] =
ubifs_init_security+0x28/0x74
> [   20.650000]
> [   20.650000] but task is already holding lock:
> [   20.650000]  (&ui->ui_mutex){+.+...}, at: [<c018a404>] ubifs_create+=
0x9c/0x1f8
> [   20.650000]
> [   20.650000] which lock already depends on the new lock.
> [   20.650000]
> [   20.650000]
> [   20.650000] the existing dependency chain (in reverse order) is:
> [   20.650000]
> -> #1 (&ui->ui_mutex){+.+...}:
> [   20.650000]        [<c0054c3c>] lock_acquire+0x64/0x78
> [   20.650000]        [<c0391b80>] mutex_lock_nested+0x68/0x2f8
> [   20.650000]        [<c01876fc>] ubifs_setattr+0xe4/0x3ec
> [   20.650000]        [<c00c8f48>] notify_change+0x1dc/0x324
> [   20.650000]        [<c00af3c8>] do_truncate+0x78/0x94
> [   20.650000]        [<c00bd738>] do_last.isra.24+0x530/0xc30
> [   20.650000]        [<c00bdee0>] path_openat+0xa8/0x4b8
> [   20.650000]        [<c00be5ec>] do_filp_open+0x2c/0x80
> [   20.650000]        [<c00b0128>] do_sys_open+0xe4/0x170
> [   20.650000]        [<c000e260>] ret_fast_syscall+0x0/0x38
> [   20.650000]
> -> #0 (&sb->s_type->i_mutex_key#9){+.+.+.}:
> [   20.650000]        [<c0054138>] __lock_acquire+0x1354/0x19b0
> [   20.650000]        [<c0054c3c>] lock_acquire+0x64/0x78
> [   20.650000]        [<c0391b80>] mutex_lock_nested+0x68/0x2f8
> [   20.650000]        [<c01afe64>] ubifs_init_security+0x28/0x74
> [   20.650000]        [<c018a488>] ubifs_create+0x120/0x1f8
> [   20.650000]        [<c00bb7d4>] vfs_create+0xac/0xd8
> [   20.650000]        [<c00bdcb8>] do_last.isra.24+0xab0/0xc30
> [   20.650000]        [<c00bdee0>] path_openat+0xa8/0x4b8
> [   20.650000]        [<c00be5ec>] do_filp_open+0x2c/0x80
> [   20.650000]        [<c00b0128>] do_sys_open+0xe4/0x170
> [   20.650000]        [<c000e260>] ret_fast_syscall+0x0/0x38
> [   20.650000]
> [   20.650000] other info that might help us debug this:
> [   20.650000]
> [   20.650000]  Possible unsafe locking scenario:
> [   20.650000]
> [   20.650000]        CPU0                    CPU1
> [   20.650000]        ----                    ----
> [   20.650000]   lock(&ui->ui_mutex);
> [   20.650000]                                lock(&sb->s_type->i_mutex=
_key#9);
> [   20.650000]                                lock(&ui->ui_mutex);
> [   20.650000]   lock(&sb->s_type->i_mutex_key#9);
> [   20.650000]
> [   20.650000]  *** DEADLOCK ***
> [   20.650000]
> [   20.650000] 3 locks held by systemd-rc-once/79:
> [   20.650000]  #0:  (sb_writers#3){.+.+.+}, at: [<c00cc300>] mnt_want_=
write+0x18/0x3c
> [   20.650000]  #1:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c00bd4ac>]=
 do_last.isra.24+0x2a4/0xc30
> [   20.650000]  #2:  (&ui->ui_mutex){+.+...}, at: [<c018a404>] ubifs_cr=
eate+0x9c/0x1f8
> [   20.650000]
> [   20.650000] stack backtrace:
> [   20.650000] [<c00123e8>] (unwind_backtrace+0x0/0xf0) from [<c038c874=
>] (print_circular_bug+0x254/0x2a0)
> [   20.650000] [<c038c874>] (print_circular_bug+0x254/0x2a0) from [<c00=
54138>] (__lock_acquire+0x1354/0x19b0)
> [   20.650000] [<c0054138>] (__lock_acquire+0x1354/0x19b0) from [<c0054=
c3c>] (lock_acquire+0x64/0x78)
> [   20.650000] [<c0054c3c>] (lock_acquire+0x64/0x78) from [<c0391b80>] =
(mutex_lock_nested+0x68/0x2f8)
> [   20.650000] [<c0391b80>] (mutex_lock_nested+0x68/0x2f8) from [<c01af=
e64>] (ubifs_init_security+0x28/0x74)
> [   20.650000] [<c01afe64>] (ubifs_init_security+0x28/0x74) from [<c018=
a488>] (ubifs_create+0x120/0x1f8)
> [   20.650000] [<c018a488>] (ubifs_create+0x120/0x1f8) from [<c00bb7d4>=
] (vfs_create+0xac/0xd8)
> [   20.650000] [<c00bb7d4>] (vfs_create+0xac/0xd8) from [<c00bdcb8>] (d=
o_last.isra.24+0xab0/0xc30)
> [   20.650000] [<c00bdcb8>] (do_last.isra.24+0xab0/0xc30) from [<c00bde=
e0>] (path_openat+0xa8/0x4b8)
> [   20.650000] [<c00bdee0>] (path_openat+0xa8/0x4b8) from [<c00be5ec>] =
(do_filp_open+0x2c/0x80)
> [   20.650000] [<c00be5ec>] (do_filp_open+0x2c/0x80) from [<c00b0128>] =
(do_sys_open+0xe4/0x170)
> [   20.650000] [<c00b0128>] (do_sys_open+0xe4/0x170) from [<c000e260>] =
(ret_fast_syscall+0x0/0x38)
> [   49.430000] UBIFS: background thread "ubifs_bgt0_0" stops

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2IXEIIHWAETEAODBOHVRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlD3IE4ACgkQjTAFq1RaXHN2bgCdH8WLSpoHMzviW7+Sv0mhPNiS
FE0An0PH0tj3VdAPDmPaDB4UP4sjU/cw
=apn+
-----END PGP SIGNATURE-----

------enig2IXEIIHWAETEAODBOHVRI--
