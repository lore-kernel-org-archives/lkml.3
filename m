Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3BFRom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:44:42 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55055 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BFRok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:44:40 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: next-20130206 cpufreq - WARN in sysfs_add_one
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360172675_2167P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Feb 2013 12:44:35 -0500
Message-ID: <9180.1360172675@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.51129685.00F6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360172675_2167P
Content-Type: text/plain; charset=us-ascii

Seen in dmesg.  next-20130128 was OK. Haven't done a bisect, but can
do so if the offender isn't obvious...

[    2.567662] netconsole: network logging started
[    2.581661] ------------[ cut here ]------------
[    2.581670] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0x91/0xa5()
[    2.581673] Hardware name: Latitude E6500
[    2.581676] sysfs: cannot create duplicate filename '/devices/system/cpu/cpufreq/ondemand'
[    2.581678] Modules linked in:
[    2.581684] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc6-next-20130206 #57
[    2.581687] Call Trace:
[    2.581693]  [<ffffffff811713d6>] ? sysfs_add_one+0x91/0xa5
[    2.581700]  [<ffffffff8102ecdc>] warn_slowpath_common+0x7c/0x96
[    2.581706]  [<ffffffff8102ed3d>] warn_slowpath_fmt+0x47/0x49
[    2.581711]  [<ffffffff811713d6>] sysfs_add_one+0x91/0xa5
[    2.581716]  [<ffffffff81171521>] create_dir+0x6b/0xa4
[    2.581721]  [<ffffffff81171787>] sysfs_create_subdir+0x17/0x19
[    2.581727]  [<ffffffff81172e76>] internal_create_group+0xd4/0x1df
[    2.581732]  [<ffffffff81172f8f>] sysfs_create_group+0xe/0x10
[    2.581739]  [<ffffffff813e033a>] cpufreq_governor_dbs+0x209/0x475
[    2.581744]  [<ffffffff813df187>] od_cpufreq_governor_dbs+0x15/0x17
[    2.581750]  [<ffffffff813dd6ab>] __cpufreq_governor+0x61/0xb5
[    2.581755]  [<ffffffff813dd803>] __cpufreq_set_policy+0x104/0x140
[    2.581761]  [<ffffffff81609303>] cpufreq_add_dev_interface+0x217/0x261
[    2.581767]  [<ffffffff813de5ed>] ? cpufreq_update_policy+0x133/0x133
[    2.581773]  [<ffffffff813dddc9>] cpufreq_add_dev+0x222/0x2d7
[    2.581780]  [<ffffffff812dc7da>] subsys_interface_register+0xa3/0xd7
[    2.581786]  [<ffffffff8160e6c9>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[    2.581792]  [<ffffffff813dd1ae>] cpufreq_register_driver+0x9c/0x13b
[    2.581799]  [<ffffffff81d778ed>] ? cpufreq_gov_dbs_init+0x2c/0x2c
[    2.581805]  [<ffffffff81d77968>] acpi_cpufreq_init+0x7b/0x185
[    2.581811]  [<ffffffff8100023a>] do_one_initcall+0x7a/0x130
[    2.581817]  [<ffffffff81d4ddfb>] kernel_init_freeable+0x15e/0x1df
[    2.581822]  [<ffffffff81d4d6f2>] ? do_early_param+0x88/0x88
[    2.581828]  [<ffffffff815f9568>] ? rest_init+0x12c/0x12c
[    2.581833]  [<ffffffff815f9571>] kernel_init+0x9/0xd1
[    2.581839]  [<ffffffff81614bec>] ret_from_fork+0x7c/0xb0
[    2.581844]  [<ffffffff815f9568>] ? rest_init+0x12c/0x12c
[    2.581847] ---[ end trace a0eea8e0db3a3905 ]---
[    2.585909] ALSA device list:
[    2.585913]   #0: HDA Intel at 0xf6fdc000 irq 48
[    2.590781] Freeing unused kernel memory: 852k freed


--==_Exmh_1360172675_2167P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBURKWggdmEQWDXROgAQKgaxAAg5gUAjU9f3yKt+1zXxWqUYSQ92J3nF4m
aabYNWKKqBw/zD18j/rob/uSxVhFjFVwo5C538sntdFSlH9+SDBJbxv93jFTItpx
GVzG7deOjphF7MkFHZKPwdVo1E2+3O6ntUJOjiHz9GkGrCdsnYOiXWrZwed1wgkY
uy9qtByoEFtZOcWjgj6KW1+Ah5CNYZgOau3SMz5c+pPb2TyRlykv3hVeGXd3Nvin
Rd4w+KA1bVa5gkhS3zwbp79na/lExZUv3btEDqr0uQM/lOuhqoMiyKkqTH16B2tU
iJjzRxzp56LYhggPn/e7k57+TmZ2cm+Zq3zZO/nRDDD5Hmg8cSHdTcKfm9BMCCvF
o1f5aE/SWcRFZFQbphZCdkjUe93PyV/8FUG/DYg/KM82pgQNDdI29P5DF8mXk4Cl
FpY+Xq5NJFLlbMBQroIG/QwLbtIsK+ojoYHH1eynF4X7aPOjgNocX/53oi+uE6R3
tn9HGFkuRHc0qnonac0A4UI9T8CDTSrGEUTzRUk6pmtxWad3Z/MDoTBVaR1BZN/B
3Z2Rao34/QFi1e5uog+BhINf7NCcdsWlUsfKPYFW13tQ4TQhSweZw+BRXFoELV5m
m8v67MqYqS7fMvi+TWV8flBvs6YEPRySTlQaaKG14tgSF6WZ7tqvBjUKOP4T3WVt
a9frKfyevKo=
=/OI8
-----END PGP SIGNATURE-----

--==_Exmh_1360172675_2167P--

