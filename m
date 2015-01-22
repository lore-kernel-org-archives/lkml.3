Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbbAVTYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:24:21 -0500
Received: from mail-bl2on0147.outbound.protection.outlook.com ([65.55.169.147]:56960
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752552AbbAVTYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:24:18 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jake Oshins <jakeo@microsoft.com>
Subject: RE: [PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove
Thread-Topic: [PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove
Thread-Index: AQHQNazKoApgvmNw9USmazKFF4JNlpzMf08g
Date: Thu, 22 Jan 2015 19:08:29 +0000
Message-ID: <BY2PR0301MB0711E8D8C81EE6EF2DE848EAA0490@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
 <1421866929-20167-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421866929-20167-3-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [167.220.67.233]
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0774;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-forefront-prvs: 0464DBBBC4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(377454003)(479174004)(74316001)(46102003)(87936001)(2656002)(86612001)(66066001)(2501002)(19580395003)(19580405001)(99286002)(86362001)(106116001)(54206007)(54356999)(76176999)(50986999)(54606007)(92566002)(33656002)(76576001)(77156002)(2950100001)(102836002)(2900100001)(62966003)(15975445007)(122556002)(40100003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0774;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2015 19:08:29.2532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Wednesday, January 21, 2015 11:02 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove
> 
> In case we do request_resource() in vmbus_acpi_add() we need to tear it
> down to be able to load the driver again. Otherwise the following crash in
> oberved when hv_vmbus unload/load sequence is performed on
> Generation2 instance:
> 
> [   38.165701] BUG: unable to handle kernel paging request at ffffffffa00075a0
> [   38.166315] IP: [<ffffffff8107dc5f>] __request_resource+0x2f/0x50
> [   38.166315] PGD 1f34067 PUD 1f35063 PMD 3f723067 PTE 0
> [   38.166315] Oops: 0000 [#1] SMP
> [   38.166315] Modules linked in: hv_vmbus(+) [last unloaded: hv_vmbus]
> [   38.166315] CPU: 0 PID: 267 Comm: modprobe Not tainted 3.19.0-
> rc5_bug923184+ #486
> [   38.166315] Hardware name: Microsoft Corporation Virtual Machine/Virtual
> Machine, BIOS Hyper-V UEFI Release v1.0 11/26/2012
> [   38.166315] task: ffff88003f401cb0 ti: ffff88003f60c000 task.ti:
> ffff88003f60c000
> [   38.166315] RIP: 0010:[<ffffffff8107dc5f>]  [<ffffffff8107dc5f>]
> __request_resource+0x2f/0x50
> [   38.166315] RSP: 0018:ffff88003f60fb58  EFLAGS: 00010286
> ...
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/hv/vmbus_drv.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
> 4d6b269..b06cb87 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -902,6 +902,15 @@ acpi_walk_err:
>  	return ret_val;
>  }
> 
> +static int vmbus_acpi_remove(struct acpi_device *device) {
> +	int ret = 0;
> +
> +	if (hyperv_mmio.start && hyperv_mmio.end)
> +		ret = release_resource(&hyperv_mmio);
> +	return ret;
> +}
> +
>  static const struct acpi_device_id vmbus_acpi_device_ids[] = {
>  	{"VMBUS", 0},
>  	{"VMBus", 0},
> @@ -914,6 +923,7 @@ static struct acpi_driver vmbus_acpi_driver = {
>  	.ids = vmbus_acpi_device_ids,
>  	.ops = {
>  		.add = vmbus_acpi_add,
> +		.remove = vmbus_acpi_remove,
>  	},
>  };

Vitaly,

Jake has sent the following patch that has fixed retrieving of the mmio resources:
https://lkml.org/lkml/2015/1/20/876

This patch also deals with the resource cleanup that you have in this patch.

Regards,

K. Y
> 
> --
> 1.9.3

