Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaD2BRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:17:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36592 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaD2BRm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:17:42 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Jan Kasprzak <kas@fi.muni.cz>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 18:16:36 -0700
Subject: RE: PATCH: mvsas: add support for Supermicro AOC-SAS2LP-MV8
Thread-Topic: PATCH: mvsas: add support for Supermicro AOC-SAS2LP-MV8
Thread-Index: Ac9i8W00NjhDLV6qQDaRdGLPgENWCAAVo4kg
Message-ID: <F766E4F80769BD478052FB6533FA745D4F6368598F@SC-VEXCH4.marvell.com>
References: <20140428145201.GG29712@fi.muni.cz>
In-Reply-To: <20140428145201.GG29712@fi.muni.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-28_03:2014-04-28,2014-04-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404290017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jan
I think below change may be better:
{ PCI_VDEVICE(MARVELL_EXT, 0x9485), chip_9485 },

> Add support for the AOC-SAS2LP-MV8 SAS-2 controller from SuperMicro.
> This controller has subdevice id 0x9485 instead of 0x9480, and apparently
> this simple patch is the only thing needed to make it work.
> 
> # lspci -vn
> [...]
> 03:00.0 0104: 1b4b:9485 (rev 03)
> 	Subsystem: 1b4b:9485
> 	Flags: bus master, fast devsel, latency 0, IRQ 24
> 	Memory at feba0000 (64-bit, non-prefetchable) [size=128K]
> 	Memory at febc0000 (64-bit, non-prefetchable) [size=256K]
> 	Expansion ROM at feb90000 [disabled] [size=64K]
> 	Capabilities: [40] Power Management version 3
> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> 	Capabilities: [70] Express Endpoint, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Virtual Channel
> 	Kernel driver in use: mvsas
> 	Kernel modules: mvsas
> 
> Signed-off-by: Jan Kasprzak <kas@fi.muni.cz>
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 5ff978b..eacee48 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -728,6 +728,15 @@ static struct pci_device_id mvs_pci_table[] = {
>  		.class_mask	= 0,
>  		.driver_data	= chip_9485,
>  	},
> +	{
> +		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
> +		.device		= 0x9485,
> +		.subvendor	= PCI_ANY_ID,
> +		.subdevice	= 0x9485,
> +		.class		= 0,
> +		.class_mask	= 0,
> +		.driver_data	= chip_9485,
> +	},
>  	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
>  	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact
> model unknown) */
>  	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact
> model unknown) */
> 
> --
> | Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
> | New GPG 4096R/A45477D5 - see http://www.fi.muni.cz/~kas/pgp-rollover.txt |
> | http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/
> |
>   There's clearly a balance between "octopus merges are fine" and "Christ,
>   that's not an octopus, that's a Cthulhu merge".         --Linus Torvalds
