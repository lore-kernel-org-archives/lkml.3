Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaJDKgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:36:39 -0400
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:23280
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751072AbaJDKgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:36:37 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: RE: [PATCH 3.14 104/238] iommu/fsl: Fix warning resulting from adding
 PCI device twice
Thread-Topic: [PATCH 3.14 104/238] iommu/fsl: Fix warning resulting from
 adding PCI device twice
Thread-Index: AQHP31Xp8t8tP1EFcUuIG1ac+WkVAZwfuLrA
Date: Sat, 4 Oct 2014 10:21:19 +0000
Message-ID: <6155d43b3a044373b0d08c7aa6183ae1@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20141003212913.680985295@linuxfoundation.org>
 <20141003212917.004490011@linuxfoundation.org>
In-Reply-To: <20141003212917.004490011@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(51704005)(199003)(13464003)(66066001)(4396001)(107046002)(101416001)(76482002)(99396003)(95666004)(19580405001)(74316001)(106116001)(85306004)(33646002)(108616004)(50986999)(40100001)(106356001)(99286002)(46102003)(97736003)(76176999)(10300001)(19580395003)(54356999)(120916001)(575784001)(105586002)(80022003)(20776003)(31966008)(87936001)(21056001)(2656002)(86362001)(64706001)(92566001)(76576001)(85852003)(122556001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s94AakQ1023893

Hi Greg,
This fix is not required on 3.14. Fix was required to address an issue, introduced by the iommu_group_get_for_dev API in the PAMU driver code.

Regards
Varun

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Saturday, October 04, 2014 3:00 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman; stable@vger.kernel.org; Sethi Varun-B16395; Joerg
> Roedel
> Subject: [PATCH 3.14 104/238] iommu/fsl: Fix warning resulting from adding PCI
> device twice
> 
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Varun Sethi <Varun.Sethi@freescale.com>
> 
> commit 5a9137a66b521d667236e95c307b92af532fe600 upstream.
> 
> iommu_group_get_for_dev determines the iommu group for the PCI device
> and adds the device to the group.
> 
> In the PAMU driver we were again adding the device to the same group
> without checking if the device already had an iommu group. This resulted in the
> following warning.
> 
> sysfs: cannot create duplicate filename
> '/devices/ffe200000.pcie/pci0000:00/0000:00:00.0/iommu_group'
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:31
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc3-00002-g7505cea-dirty
> #126
> task: c0000001fe0a0000 ti: c0000001fe044000 task.ti: c0000001fe044000
> NIP: c00000000018879c LR: c000000000188798 CTR: c00000000001ea50
> REGS: c0000001fe047040 TRAP: 0700   Not tainted  (3.17.0-rc3-00002-g7505cea-
> dirty)
> MSR: 0000000080029000 <CE,EE,ME>  CR: 24ad8e22  XER: 20000000
> SOFTE: 1
> GPR00: c000000000188798 c0000001fe0472c0 c0000000009a52e0
> 0000000000000065
> GPR04: 0000000000000001 0000000000000000 3a30303a00000000
> 0000000027000000
> GPR08: 2f696f6d00000000 c0000000008d3830 c0000000009b3938
> c0000000009bb3d0
> GPR12: 0000000028ad8e24 c00000000fff4000 c00000000000205c
> 0000000000000000
> GPR16: 0000000000000000 0000000000000000 0000000000000000
> 0000000000000000
> GPR20: 0000000000000000 0000000000000000 0000000000000000
> c0000000008a4c70
> GPR24: c0000000007e9010 c0000001fe0140a8 ffffffffffffffef 0000000000000001
> GPR28: c0000001fe22ebb8 c0000000007e9010 c00000000090bf10
> c0000001fe220000 NIP [c00000000018879c] .sysfs_warn_dup+0x74/0xa4 LR
> [c000000000188798] .sysfs_warn_dup+0x70/0xa4 Call Trace:
> [c0000001fe0472c0] [c000000000188798] .sysfs_warn_dup+0x70/0xa4
> (unreliable) [c0000001fe047350] [c000000000188d34]
> .sysfs_do_create_link_sd.clone.2+0x168/0x174
> [c0000001fe047400] [c0000000004b3cf8]
> .iommu_group_add_device+0x78/0x244
> [c0000001fe0474b0] [c0000000004b6964] .fsl_pamu_add_device+0x88/0x1a8
> [c0000001fe047570] [c0000000004b3960] .iommu_bus_notifier+0xdc/0x15c
> [c0000001fe047600] [c000000000059848] .notifier_call_chain+0x8c/0xe8
> [c0000001fe0476a0] [c000000000059d04]
> .__blocking_notifier_call_chain+0x58/0x84
> [c0000001fe047750] [c00000000036619c] .device_add+0x464/0x5c8
> [c0000001fe047820] [c000000000300ebc] .pci_device_add+0x14c/0x17c
> [c0000001fe0478c0] [c000000000300fbc] .pci_scan_single_device+0xd0/0xf4
> [c0000001fe047970] [c00000000030104c] .pci_scan_slot+0x6c/0x18c
> [c0000001fe047a10] [c00000000030226c] .pci_scan_child_bus+0x40/0x114
> [c0000001fe047ac0] [c000000000021974] .pcibios_scan_phb+0x240/0x2c8
> [c0000001fe047b70] [c00000000085a970] .pcibios_init+0x64/0xc8
> [c0000001fe047c00] [c000000000001884] .do_one_initcall+0xbc/0x224
> [c0000001fe047d00] [c000000000852d50] .kernel_init_freeable+0x14c/0x21c
> [c0000001fe047db0] [c000000000002078] .kernel_init+0x1c/0xfa4
> [c0000001fe047e30] [c000000000000884] .ret_from_kernel_thread+0x58/0xd4
> Instruction dump:
> 7c7f1b79 4182001c 7fe4fb78 7f83e378 38a01000 4bffc905 60000000 7c641b78
> e87e8008 7fa5eb78 48482ff5 60000000 <0fe00000> 7fe3fb78 4bf7bd39 60000000
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/iommu/fsl_pamu_domain.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -1050,7 +1050,7 @@ static int fsl_pamu_add_device(struct de
>  	struct iommu_group *group = NULL;
>  	struct pci_dev *pdev;
>  	const u32 *prop;
> -	int ret, len;
> +	int ret = 0, len;
> 
>  	/*
>  	 * For platform devices we allocate a separate group for @@ -1073,7
> +1073,13 @@ static int fsl_pamu_add_device(struct de
>  	if (!group || IS_ERR(group))
>  		return PTR_ERR(group);
> 
> -	ret = iommu_group_add_device(group, dev);
> +	/*
> +	 * Check if device has already been added to an iommu group.
> +	 * Group could have already been created for a PCI device in
> +	 * the iommu_group_get_for_dev path.
> +	 */
> +	if (!dev->iommu_group)
> +		ret = iommu_group_add_device(group, dev);
> 
>  	iommu_group_put(group);
>  	return ret;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
