Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbbAUKuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:50:44 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12395 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbAUKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:50:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Jan 2015 02:41:19 -0800
Date: Wed, 21 Jan 2015 11:50:03 +0100
From: Thierry Reding <treding@nvidia.com>
To: Paul Walmsley <paul@pwsan.com>, Tejun Heo <tj@kernel.org>
CC: <gregory.clement@free-electrons.com>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <pwalmsley@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: next-20150120 broken on Tegra by "ata: libahci: Allow using
 multiple regulators"
Message-ID: <20150121105001.GA9921@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.160]
X-ClientProxiedBy: UKMAIL101.nvidia.com (10.26.138.13) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 12:03:41AM +0000, Paul Walmsley wrote:
> (linux-ide@ added)
>=20
> Commit c7d7ddee7e24eedde6149eefbcfbfbc7125b9ff0 ("ata: libahci: Allow
> using multiple regulators") in Linux-next 20150120 causes a panic
> during boot on multiple Tegra boards:
>=20
> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/=
20150120001539/boot/tegra30-beaver/tegra30-beaver/tegra_defconfig_log.txt
> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/=
20150120001539/boot/tegra114-dalmore-a04/tegra114-dalmore/tegra_defconfig_l=
og.txt
> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/=
20150120001539/boot/tegra124-jetson-tk1/tegra124-jetson-tk1/tegra_defconfig=
_log.txt
>=20
> Taking the latter boot log as an example, the 6b6b6b9f value that the=20
> kernel is trying to dereference is being passed into _regulator_put() as =
a=20
> struct regulator *.
>=20
>=20
> - Paul
>=20

Here's the devres log of what's happening:

	[    4.949689] tegra-ahci 70027000.sata: DEVRES ADD ee1e2a00 devm_kzalloc_=
release (16 bytes)
	[    4.957886] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 devm_pinctrl_=
release (4 bytes)
	[    4.965984] tegra-ahci 70027000.sata: DEVRES REM ee1e29c0 devm_pinctrl_=
release (4 bytes)
	[    4.974079] tegra-ahci 70027000.sata: DEVRES REM ee1e2a00 devm_kzalloc_=
release (16 bytes)
	[    4.982298] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 grp< (0 bytes)
	[    4.989006] tegra-ahci 70027000.sata: DEVRES ADD ee1dae00 ahci_platform=
_put_resources (96 bytes)
	[    4.997784] tegra-ahci 70027000.sata: DEVRES ADD ee1e2980 devm_region_r=
elease (12 bytes)
	[    5.005879] tegra-ahci 70027000.sata: DEVRES ADD ee1e2900 devm_ioremap_=
release (4 bytes)
	[    5.014005] tegra-ahci 70027000.sata: DEVRES ADD ee1e28c0 devm_kzalloc_=
release (4 bytes)
	[    5.022096] tegra-ahci 70027000.sata: DEVRES ADD ee1e2880 devm_kzalloc_=
release (4 bytes)
	[    5.030209] tegra-ahci 70027000.sata: DEVRES ADD ee1e2840 devm_phy_rele=
ase (4 bytes)
	[    5.037952] tegra-ahci 70027000.sata: DEVRES REM ee1e29c0 grp< (0 bytes)
	[    5.044660] tegra-ahci 70027000.sata: DEVRES ADD ee1dad80 devm_kzalloc_=
release (84 bytes)
	[    5.052845] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 devm_region_r=
elease (12 bytes)
	[    5.060938] tegra-ahci 70027000.sata: DEVRES ADD ee1e2f80 devm_ioremap_=
release (4 bytes)
	[    5.069039] tegra-ahci 70027000.sata: DEVRES ADD ee1e2f40 devm_reset_co=
ntrol_release (4 bytes)
	[    5.077647] tegra-ahci 70027000.sata: DEVRES ADD ee1e2ec0 devm_reset_co=
ntrol_release (4 bytes)
	[    5.086271] tegra-ahci 70027000.sata: DEVRES ADD ee1e2e40 devm_reset_co=
ntrol_release (4 bytes)
	[    5.094890] tegra-ahci 70027000.sata: DEVRES ADD ee1e2dc0 devm_clk_rele=
ase (4 bytes)
	[    5.102659] tegra-ahci 70027000.sata: Failed to get supply 'avdd': -517
	[    5.109276] tegra-ahci 70027000.sata: Failed to get regulators
	[    5.115103] tegra-ahci 70027000.sata: DEVRES REL ee1e2dc0 devm_clk_rele=
ase (4 bytes)
	[    5.122850] tegra-ahci 70027000.sata: DEVRES REL ee1e2e40 devm_reset_co=
ntrol_release (4 bytes)
	[    5.131462] tegra-ahci 70027000.sata: DEVRES REL ee1e2ec0 devm_reset_co=
ntrol_release (4 bytes)
	[    5.140073] tegra-ahci 70027000.sata: DEVRES REL ee1e2f40 devm_reset_co=
ntrol_release (4 bytes)
	[    5.148672] tegra-ahci 70027000.sata: DEVRES REL ee1e2f80 devm_ioremap_=
release (4 bytes)
	[    5.156764] tegra-ahci 70027000.sata: DEVRES REL ee1e29c0 devm_region_r=
elease (12 bytes)
	[    5.164856] tegra-ahci 70027000.sata: DEVRES REL ee1dad80 devm_kzalloc_=
release (84 bytes)
	[    5.173034] tegra-ahci 70027000.sata: DEVRES REL ee1e2840 devm_phy_rele=
ase (4 bytes)
	[    5.180778] tegra-ahci 70027000.sata: DEVRES REL ee1e2880 devm_kzalloc_=
release (4 bytes)
	[    5.188868] tegra-ahci 70027000.sata: DEVRES REL ee1e28c0 devm_kzalloc_=
release (4 bytes)
	[    5.196948] tegra-ahci 70027000.sata: DEVRES REL ee1e2900 devm_ioremap_=
release (4 bytes)
	[    5.205037] tegra-ahci 70027000.sata: DEVRES REL ee1e2980 devm_region_r=
elease (12 bytes)
	[    5.213129] tegra-ahci 70027000.sata: DEVRES REL ee1dae00 ahci_platform=
_put_resources (96 bytes)

What's happening here is that ahci_platform_put_resources() is added to
the devres list before the devm_kzalloc() that allocates the target_pwrs
array, which causes the target_pwrs array to be freed before devres gets
to call ahci_platform_put_resources().

Mixing managed and non-managed resources this way doesn't work, so I had
to apply the attached patch to fix this.

Tejun, preferably the attached patch should be squashed into commit
c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators") to avoid
breaking bisectability. If you don't want to rewrite history, let me
know and I can turn it into a proper patch.

Thierry

> [    1.353036] platform as3722-regulator: Driver as3722-regulator request=
s probe deferral
> [    1.362978] tegra-ahci 70027000.sata: Failed to get supply 'avdd': -517
> [    1.369607] tegra-ahci 70027000.sata: Failed to get regulators
> [    1.375479] Unable to handle kernel paging request at virtual address =
6b6b6b9f
> [    1.382689] pgd =3D c0004000
> [    1.385517] [6b6b6b9f] *pgd=3D00000000
> [    1.389101] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [    1.394403] Modules linked in:
> [    1.397467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5-next-=
20150120-72727-g5d0eebb #1
> [    1.406237] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [    1.412493] task: ee053840 ti: ee054000 task.ti: ee054000
> [    1.417891] PC is at _regulator_put+0x14/0xa0
> [    1.422241] LR is at regulator_put+0x1c/0x2c
> [    1.426506] pc : [<c027764c>]    lr : [<c02776f4>]    psr: 00000113
> [    1.426506] sp : ee055e40  ip : ee18aedc  fp : 00000000
> [    1.437964] r10: c02f94b4  r9 : c02f94b0  r8 : ee055e70
> [    1.443179] r7 : 0000000d  r6 : 00000005  r5 : 6b6b6b6b  r4 : 6b6b6b6b
> [    1.449695] r3 : ee053840  r2 : ee055e48  r1 : 00000000  r0 : 6b6b6b6b
> [    1.456213] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segme=
nt kernel
> [    1.463509] Control: 10c5387d  Table: 8000406a  DAC: 00000015
> [    1.469245] Process swapper/0 (pid: 1, stack limit =3D 0xee054210)
> [    1.475242] Stack: (0xee055e40 to 0xee056000)
> [    1.479596] 5e40: c08ff470 6b6b6b6b 00000005 c02776f4 6b6b6b6b 0000000=
1 ee3d9990 c03481a4
> [    1.487761] 5e60: ee3d9980 ee055e70 ee18ae10 c02f99f8 ee3d9980 ee3ed98=
0 ee18ae10 c09804c0
> [    1.495927] 5e80: fffffdfb c0910898 00000000 c08d31e4 00000000 c02f6ea=
8 ee18ae10 c0910898
> [    1.504093] 5ea0: ee18ae44 00000000 c08b996c c02f70f0 00000000 c091089=
8 c02f7064 c02f577c
> [    1.512258] 5ec0: ee036560 ee15f934 c0910898 ee3d9a00 c090dc08 c02f674=
4 c07e6d00 c0910898
> [    1.520423] 5ee0: c08ee018 c0910898 c08ee018 ee3ed700 c0939340 c02f771=
4 00000000 c08ee018
> [    1.528588] 5f00: c08ee018 c0008b04 c063dd14 00000014 00000000 0000000=
0 00000000 c012d2dc
> [    1.536752] 5f20: 00000000 c08f2684 60000113 00000001 ef7fcca0 c0659cb=
c 000000d9 c003bdd4
> [    1.544917] 5f40: c08626bc 00000006 ef7fcca8 00000006 c08f264c ef7fcc4=
0 c08e3474 00000006
> [    1.553082] 5f60: c08d31d8 c0939340 000000d9 c08d31e4 c089c598 c089cd8=
0 00000006 00000006
> [    1.561247] 5f80: c089c598 7fffffff 00000000 c062f028 00000000 0000000=
0 00000000 00000000
> [    1.569413] 5fa0: 00000000 c062f030 00000000 c000e9c0 00000000 0000000=
0 00000000 00000000
> [    1.577578] 5fc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
> [    1.585743] 5fe0: 00000000 00000000 00000000 00000000 00000013 0000000=
0 ffffffff 7fffffff
> [    1.593920] [<c027764c>] (_regulator_put) from [<c02776f4>] (regulator=
_put+0x1c/0x2c)
> [    1.601751] [<c02776f4>] (regulator_put) from [<c03481a4>] (ahci_platf=
orm_put_resources+0x74/0xa0)
> [    1.610704] [<c03481a4>] (ahci_platform_put_resources) from [<c02f99f8=
>] (release_nodes+0x164/0x1d8)
> [    1.619828] [<c02f99f8>] (release_nodes) from [<c02f6ea8>] (driver_pro=
be_device+0x70/0x22c)
> [    1.628170] [<c02f6ea8>] (driver_probe_device) from [<c02f70f0>] (__dr=
iver_attach+0x8c/0x90)
> [    1.636604] [<c02f70f0>] (__driver_attach) from [<c02f577c>] (bus_for_=
each_dev+0x54/0x88)
> [    1.644774] [<c02f577c>] (bus_for_each_dev) from [<c02f6744>] (bus_add=
_driver+0xd4/0x1d0)
> [    1.652940] [<c02f6744>] (bus_add_driver) from [<c02f7714>] (driver_re=
gister+0x78/0xf4)
> [    1.660936] [<c02f7714>] (driver_register) from [<c0008b04>] (do_one_i=
nitcall+0x80/0x1d0)
> [    1.669108] [<c0008b04>] (do_one_initcall) from [<c089cd80>] (kernel_i=
nit_freeable+0x108/0x1d4)
> [    1.677802] [<c089cd80>] (kernel_init_freeable) from [<c062f030>] (ker=
nel_init+0x8/0xec)
> [    1.685887] [<c062f030>] (kernel_init) from [<c000e9c0>] (ret_from_for=
k+0x14/0x34)
> [    1.693447] Code: e2504000 08bd8070 e3740a01 88bd8070 (e5940034)=20
> [    1.699578] ---[ end trace 6cc7849b05d3269f ]---
> [    1.704225] Kernel panic - not syncing: Attempted to kill init! exitco=
de=3D0x0000000b
> [    1.704225]=20
> [    1.713348] CPU2: stopping
> [    1.716059] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D         3.=
19.0-rc5-next-20150120-72727-g5d0eebb #1
> [    1.726041] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [    1.732316] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_st=
ack+0x10/0x14)
> [    1.740057] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x=
84/0xd0)
> [    1.747273] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x=
134/0x160)
> [    1.754660] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_ir=
q+0x54/0x5c)
> [    1.762222] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc=
+0x40/0x74)
> [    1.769691] Exception stack(0xee079f98 to 0xee079fe0)
> [    1.774734] 9f80:                                                     =
  ffffffed 00000000
> [    1.782900] 9fa0: ee079fe8 c001ee80 c08ea4f8 c08ea494 00000000 0000000=
0 c08e6a00 c08e5d98
> [    1.791064] 9fc0: ffffffed 00000000 00000000 ee079fe0 c000f48c c000f49=
0 60000113 ffffffff
> [    1.799236] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+=
0x30/0x3c)
> [    1.806626] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startu=
p_entry+0x1a4/0x278)
> [    1.814881] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x8000=
8864)
> [    1.821831] CPU3: stopping
> [    1.824542] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D         3.=
19.0-rc5-next-20150120-72727-g5d0eebb #1
> [    1.834526] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [    1.840797] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_st=
ack+0x10/0x14)
> [    1.848536] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x=
84/0xd0)
> [    1.855751] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x=
134/0x160)
> [    1.863138] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_ir=
q+0x54/0x5c)
> [    1.870701] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc=
+0x40/0x74)
> [    1.878170] Exception stack(0xee07bf98 to 0xee07bfe0)
> [    1.883212] bf80:                                                     =
  ffffffed 00000000
> [    1.891377] bfa0: ee07bfe8 c001ee80 c08ea4f8 c08ea494 00000000 0000000=
0 c08e6a00 c08e5d98
> [    1.899543] bfc0: ffffffed 00000000 00000000 ee07bfe0 c000f48c c000f49=
0 60000113 ffffffff
> [    1.907715] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+=
0x30/0x3c)
> [    1.915105] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startu=
p_entry+0x1a4/0x278)
> [    1.923358] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x8000=
8864)
> [    1.930309] CPU1: stopping
> [    1.933018] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D         3.=
19.0-rc5-next-20150120-72727-g5d0eebb #1
> [    1.943002] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [    1.949273] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_st=
ack+0x10/0x14)
> [    1.957012] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x=
84/0xd0)
> [    1.964227] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x=
134/0x160)
> [    1.971614] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_ir=
q+0x54/0x5c)
> [    1.979177] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc=
+0x40/0x74)
> [    1.986646] Exception stack(0xee077f98 to 0xee077fe0)
> [    1.991690] 7f80:                                                     =
  ffffffed 00000000
> [    1.999856] 7fa0: ee077fe8 c001ee80 c08ea4f8 c08ea494 00000000 0000000=
0 c08e6a00 c08e5d98
> [    2.008022] 7fc0: ffffffed 00000000 00000000 ee077fe0 c000f48c c000f49=
0 60000113 ffffffff
> [    2.016194] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+=
0x30/0x3c)
> [    2.023585] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startu=
p_entry+0x1a4/0x278)
> [    2.031838] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x8000=
8864)
> [    2.038794] ---[ end Kernel panic - not syncing: Attempted to kill ini=
t! exitcode=3D0x0000000b
> [    2.038794]=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 73a086664ee7..504d534ccbfe 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -276,6 +276,7 @@ static void ahci_platform_put_resources(struct device *=
dev, void *res)
 		if (hpriv->target_pwrs && hpriv->target_pwrs[c])
 			regulator_put(hpriv->target_pwrs[c]);
=20
+	kfree(hpriv->target_pwrs);
 }
=20
 static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
@@ -412,7 +413,7 @@ struct ahci_host_priv *ahci_platform_get_resources(stru=
ct platform_device *pdev)
 		goto err_out;
 	}
 	sz =3D hpriv->nports * sizeof(*hpriv->target_pwrs);
-	hpriv->target_pwrs =3D devm_kzalloc(dev, sz, GFP_KERNEL);
+	hpriv->target_pwrs =3D kzalloc(sz, GFP_KERNEL);
 	if (!hpriv->target_pwrs) {
 		rc =3D -ENOMEM;
 		goto err_out;

--FCuugMFkClbJLl1L--

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv4RZAAoJEN0jrNd/PrOhi4YP/iOa3CLsMM/yiMOKpoMrd+QY
kCSbiKMGm+1/kKcOBsaZO0/SGUCn9e16oMW5cF+sZWtSk8EEB3zoqmVbzqFjTnBx
w/qBbuEtuDe4Ff/nRN4EnlRGWq8nKWtHS7mge2oN1TTf8lQ7hcjBznP3FnLtVUAD
obY8K6sj0itaO08ICZ9Pye4BjS31c5BR8Vkbut+Yl+UKDcQoQeeGCPi+q4brQ5uX
3FIkp74nGJy5NIp3t0RRZ4fsiiVYc3luGVHX6YwAYdFHECq69ige38XFRdX6Pk72
Cu7F+bauCX+451Bwrt70eKb3gXG9M9JpkK9KxK8lUabTzl5QDcQMOKSed8DPF2Oi
hx7lEHCslK2hTNPYKLV3CnuOB8TBMuAe0Bc6RsIuQrvQox9OCLr+waxXtFxd/nrm
F2MchlcRZjKlo/7BnChgrHy2osKQvJpQgDryKBJPseIQqqVwwi+99DDEjhLbNJ5P
UN89Yg6+5FAHJlGfDJVXTfRg1htm6s18GxTV4+YyXFWowatuDUkZ9HLkKilNlU2C
6Jhvklm55Ir/W4yIYHrf/Q41TygYDeU2/XFicKu0WCU7PTwEGA4TYeSHB8ASsbu+
J/Z75+XLzhh+SUoMGFTJQMWeiriC8V3GxU4BbxUcanyibVLR5VuKuUDYtxrQibKn
Q//S+W5rumkVAwTxGlz+
=sOVm
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
