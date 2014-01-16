Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaAPRsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:48:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaAPRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:48:27 -0500
Message-ID: <1389894499.21293.15.camel@fourier>
Subject: Re: [PATCH 3.8 112/166] power_supply: Fix Oops from NULL pointer
 dereference from wakeup_source_activate
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Shuah Khan <shuah.kh@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Date: Thu, 16 Jan 2014 09:48:19 -0800
In-Reply-To: <1389822780-4729-113-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
	 <1389822780-4729-113-git-send-email-kamal@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LHesmPVL2BDTRGI4uZZv"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LHesmPVL2BDTRGI4uZZv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-01-15 at 13:52 -0800, Kamal Mostafa wrote:
> 3.8.13.16 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: Shuah Khan <shuah.kh@samsung.com>
>=20
> commit 80c6463e2fa3377febfc98a6672d92d07f3c26c1 upstream.

Actually, I'm dropping this one from the 3.8-stable queue since it isn't
really needed until 3.12.

 -Kamal


> power_supply_register() calls device_init_wakeup() to register a wakeup
> source before initializing dev_name. As a result, device_wakeup_enable()
> end up registering wakeup source with a null name when
> wakeup_source_register() gets called with dev_name(dev) which is null at
> the time.
>=20
> When kernel is booted with wakeup_source_activate enabled, it will panic
> when the trace point code tries to dereference ws->name.
>=20
> Fixed the problem by moving up the kobject_set_name() call prior to
> accesses to dev_name(). Replaced kobject_set_name() with dev_set_name()
> which is the right interface to be called from drivers. Fixed the call to
> device_del() prior to device_add() in for wakeup_init_failed error
> handling code.
>=20
> Trace after the change:
>=20
>             bash-2143  [003] d...   132.280697: wakeup_source_activate: B=
AT1 state=3D0x20001
>      kworker/3:2-1169  [003] d...   132.281305: wakeup_source_deactivate:=
 BAT1 state=3D0x30000
>=20
> Oops message:
>=20
> [  819.769934] device: 'BAT1': device_add
> [  819.770078] PM: Adding info for No Bus:BAT1
> [  819.770235] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
> [  819.770435] IP: [<ffffffff813381c0>] skip_spaces+0x30/0x30
> [  819.770572] PGD 3efd90067 PUD 3eff61067 PMD 0
> [  819.770716] Oops: 0000 [#1] SMP
> [  819.770829] Modules linked in: arc4 iwldvm mac80211 x86_pkg_temp_therm=
al coretemp kvm_intel joydev i915 kvm uvcvideo ghash_clmulni_intel videobuf=
2_vmalloc aesni_intel videobuf2_memops videobuf2_core aes_x86_64 ablk_helpe=
r cryptd videodev iwlwifi lrw rfcomm gf128mul glue_helper bnep btusb media =
bluetooth parport_pc hid_generic ppdev snd_hda_codec_hdmi drm_kms_helper sn=
d_hda_codec_realtek cfg80211 drm tpm_infineon samsung_laptop snd_hda_intel =
usbhid snd_hda_codec hid snd_hwdep snd_pcm microcode snd_page_alloc snd_tim=
er psmouse i2c_algo_bit lpc_ich tpm_tis video wmi mac_hid serio_raw ext2 lp=
 parport r8169 mii
> [  819.771802] CPU: 0 PID: 2167 Comm: bash Not tainted 3.12.0+ #25
> [  819.771876] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D=
/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
> [  819.772022] task: ffff88002e6ddcc0 ti: ffff8804015ca000 task.ti: ffff8=
804015ca000
> [  819.772119] RIP: 0010:[<ffffffff813381c0>]  [<ffffffff813381c0>] skip_=
spaces+0x30/0x30
> [  819.772242] RSP: 0018:ffff8804015cbc70  EFLAGS: 00010046
> [  819.772310] RAX: 0000000000000003 RBX: ffff88040cfd6d40 RCX: 000000000=
0000018
> [  819.772397] RDX: 0000000000020001 RSI: 0000000000000000 RDI: 000000000=
0000000
> [  819.772484] RBP: ffff8804015cbcc0 R08: 0000000000000000 R09: ffff8803f=
0768d40
> [  819.772570] R10: ffffea001033b800 R11: 0000000000000000 R12: ffffffff8=
1c519c0
> [  819.772656] R13: 0000000000020001 R14: 0000000000000000 R15: 000000000=
0020001
> [  819.772744] FS:  00007ff98309b740(0000) GS:ffff88041f200000(0000) knlG=
S:0000000000000000
> [  819.772845] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  819.772917] CR2: 0000000000000000 CR3: 00000003f59dc000 CR4: 000000000=
01407f0
> [  819.773001] Stack:
> [  819.773030]  ffffffff81114003 ffff8804015cbcb0 0000000000000000 000000=
0000000046
> [  819.773146]  ffff880409757a18 ffff8803f065a160 0000000000000000 000000=
0000020001
> [  819.773273]  0000000000000000 0000000000000000 ffff8804015cbce8 ffffff=
ff8143e388
> [  819.773387] Call Trace:
> [  819.773434]  [<ffffffff81114003>] ? ftrace_raw_event_wakeup_source+0x4=
3/0xe0
> [  819.773520]  [<ffffffff8143e388>] wakeup_source_report_event+0xb8/0xd0
> [  819.773595]  [<ffffffff8143e3cd>] __pm_stay_awake+0x2d/0x50
> [  819.773724]  [<ffffffff8153395c>] power_supply_changed+0x3c/0x90
> [  819.773795]  [<ffffffff8153407c>] power_supply_register+0x18c/0x250
> [  819.773869]  [<ffffffff813d8d18>] sysfs_add_battery+0x61/0x7b
> [  819.773935]  [<ffffffff813d8d69>] battery_notify+0x37/0x3f
> [  819.774001]  [<ffffffff816ccb7c>] notifier_call_chain+0x4c/0x70
> [  819.774071]  [<ffffffff81073ded>] __blocking_notifier_call_chain+0x4d/=
0x70
> [  819.774149]  [<ffffffff81073e26>] blocking_notifier_call_chain+0x16/0x=
20
> [  819.774227]  [<ffffffff8109397a>] pm_notifier_call_chain+0x1a/0x40
> [  819.774316]  [<ffffffff81095b66>] hibernate+0x66/0x1c0
> [  819.774407]  [<ffffffff81093931>] state_store+0x71/0xa0
> [  819.774507]  [<ffffffff81331d8f>] kobj_attr_store+0xf/0x20
> [  819.774613]  [<ffffffff811f8618>] sysfs_write_file+0x128/0x1c0
> [  819.774735]  [<ffffffff8118579d>] vfs_write+0xbd/0x1e0
> [  819.774841]  [<ffffffff811861d9>] SyS_write+0x49/0xa0
> [  819.774939]  [<ffffffff816d1052>] system_call_fastpath+0x16/0x1b
> [  819.775055] Code: 89 f8 48 89 e5 f6 82 c0 a6 84 81 20 74 15 0f 1f 44 0=
0 00 48 83 c0 01 0f b6 10 f6 82 c0 a6 84 81 20 75 f0 5d c3 66 0f 1f 44 00 0=
0 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0 01 80
> [  819.775760] RIP  [<ffffffff813381c0>] skip_spaces+0x30/0x30
> [  819.775881]  RSP <ffff8804015cbc70>
> [  819.775949] CR2: 0000000000000000
> [  819.794175] ---[ end trace c4ef25127039952e ]---
>=20
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Acked-by: Anton Vorontsov <anton@enomsg.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Anton Vorontsov <anton@enomsg.org>
> [ kamal: backport to 3.8 (context) ]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  drivers/power/power_supply_core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supp=
ly_core.c
> index 8a7cfb3..b89ca61 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -334,11 +334,11 @@ int power_supply_register(struct device *parent, st=
ruct power_supply *psy)
>  	dev_set_drvdata(dev, psy);
>  	psy->dev =3D dev;
> =20
> -	INIT_WORK(&psy->changed_work, power_supply_changed_work);
> -
> -	rc =3D kobject_set_name(&dev->kobj, "%s", psy->name);
> +	rc =3D dev_set_name(dev, "%s", psy->name);
>  	if (rc)
> -		goto kobject_set_name_failed;
> +		goto dev_set_name_failed;
> +
> +	INIT_WORK(&psy->changed_work, power_supply_changed_work);
> =20
>  	rc =3D device_add(dev);
>  	if (rc)
> @@ -366,8 +366,8 @@ register_cooler_failed:
>  	psy_unregister_thermal(psy);
>  register_thermal_failed:
>  	device_del(dev);
> -kobject_set_name_failed:
>  device_add_failed:
> +dev_set_name_failed:
>  	put_device(dev);
>  success:
>  	return rc;


--=-LHesmPVL2BDTRGI4uZZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCAAGBQJS2BtjAAoJEHqwmdxYrXhZ4vMP/2T2+qODDdhxCk04oJBudPwx
TtJP8vYJA8O1x+xF6HvdEU5wu9j+nGoqUYiS9/og3eq8nOujufYAB7Sl24kqPvP0
hCMdqLOooOE5f4zc9diOT953adymVvG9SxMzmvfgYzC10Z+0ZF6T6F8CuBxduMuR
vzmNHX+R7g9W1rCk8ADqTMdygBqp3Kv2cxh1f2sOY1NKaxoj9ERqyIYSXEJoEgjl
N90saFRYHKMDyjEGXUXXr9ZkM9ENu+naeod1efmSWiJI3s9HYzOeGb0YnbfXnbl/
oQGyMkVAsjnt2ro7nm5+mIzlqP3QdJfxMym7huxGZDmQBPzcU97ZNuMEWaJpANkQ
1swAkfJu/mL6hzHSK6jkrCIT2h1XjGvbUJpDCePC5piEBCR0DT1xSaa2BcQE79w6
+1KvfTQ2+sO//qlNL5cbm7JUK5hVje6hdQsB1ca0SiFucLSfLP4YUIUe1bnI5LhT
CvKIlj94bBjb9L/MrPM1qyr6+E1eniWV+wxMdx7JJRtvShESMGRVGdbIk3RsqWLf
t+3RxKjPhAm/CneAozEsb9YsxC6/+4TGA9Z6IxEpTI3X1Ipct421oPdEiy1Gf1nn
Zo4vrkzwF5cpDYNcWLgMvexIVGibfmZBFdlt/vK4VTE5WO7NsnBxpvct0gwESu0x
0U+YS9UGTAJ0hUqR+81k
=91Hr
-----END PGP SIGNATURE-----

--=-LHesmPVL2BDTRGI4uZZv--

