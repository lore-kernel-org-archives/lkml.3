Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbbADT6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:58:13 -0500
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:19480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752782AbbADT6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:58:12 -0500
X-WSS-ID: 0NHO4SU-07-616-02
X-M-MSG: 
Message-ID: <54A99B4A.4030606@amd.com>
Date: Sun, 4 Jan 2015 21:58:02 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Alex Deucher <alexander.deucher@amd.com>,
        =?windows-1252?Q?Christian_?= =?windows-1252?Q?K=F6nig?= 
	<christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] drm/radeon: do not left queue acquired if timeout happens
 in kgd_hqd_destroy()
References: <1420327880-25415-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1420327880-25415-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.10.47]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(479174004)(189002)(199003)(24454002)(52604005)(51704005)(97736003)(99396003)(86362001)(120916001)(59896002)(77156002)(62966003)(92566001)(83506001)(31966008)(36756003)(87936001)(19580395003)(19580405001)(84676001)(21056001)(80316001)(4396001)(64126003)(2950100001)(50466002)(65956001)(65806001)(33656002)(110136001)(50986999)(54356999)(87266999)(76176999)(65816999)(23746002)(4477795004)(101416001)(64706001)(20776003)(47776003)(46102003)(106466001)(105586002)(107046002)(68736005)(77096005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp01.amd.com;FPR:;SPF:None;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0446F0FCE1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2015 19:58:08.4372
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/04/2015 01:31 AM, Alexey Khoroshilov wrote:
> If timeout happens, kgd_hqd_destroy() just returns -ETIME leaving queue acquired.
> It may cause a deadlock, so the patch proposes to release queue before return.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/gpu/drm/radeon/radeon_kfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
> index 242fd8b1b221..335e29dbab05 100644
> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
> @@ -556,6 +556,7 @@ static int kgd_hqd_destroy(struct kgd_dev *kgd, uint32_t reset_type,
>  		if (timeout == 0) {
>  			pr_err("kfd: cp queue preemption time out (%dms)\n",
>  				temp);
> +			release_queue(kgd);
>  			return -ETIME;
>  		}
>  		msleep(20);
> 

Thanks for catching that!
Applied to my fixes tree.

	Oded
