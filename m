Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaL2IwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:52:05 -0500
Received: from mail-bl2on0120.outbound.protection.outlook.com ([65.55.169.120]:26954
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbaL2IwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:52:01 -0500
X-WSS-ID: 0NHC5YK-07-D3Z-02
X-M-MSG: 
Message-ID: <54A11610.901@amd.com>
Date: Mon, 29 Dec 2014 10:51:28 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <airlied@linux.ie>, <alexander.deucher@amd.com>, <j.glisse@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <John.Bridgman@amd.com>, <Andrew.Lewycky@amd.com>, <joro@8bytes.org>
Subject: Re: [PATCH] amdkfd: actually allocate longs for the pasid bitmask
References: <1419785077-25800-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1419785077-25800-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(189002)(51704005)(24454002)(199003)(479174004)(83506001)(107046002)(86362001)(87936001)(46102003)(84676001)(47776003)(31966008)(33656002)(21056001)(92566001)(110136001)(120916001)(20776003)(64126003)(50466002)(50986999)(76176999)(54356999)(65816999)(77096005)(64706001)(23676002)(65806001)(97736003)(4396001)(99396003)(19580405001)(106466001)(77156002)(68736005)(101416001)(62966003)(36756003)(19580395003)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0440AC9990
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 08:51:57.0175
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/28/2014 06:44 PM, Sasha Levin wrote:
> Commit "amdkfd: use sizeof(long) granularity for the pasid bitmask" calculated
> the number of longs it will need, but ended up allocating that number of
> bytes rather than longs.
>
> Fix that silly error and allocate the amount of data really required.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_pasid.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> index 71699ad..4c25ef5 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> @@ -32,7 +32,7 @@ int kfd_pasid_init(void)
>   {
>   	pasid_limit = max_num_of_processes;
>
> -	pasid_bitmap = kzalloc(BITS_TO_LONGS(pasid_limit), GFP_KERNEL);
> +	pasid_bitmap = kcalloc(BITS_TO_LONGS(pasid_limit), sizeof(long), GFP_KERNEL);
>   	if (!pasid_bitmap)
>   		return -ENOMEM;
>
>
Thanks!
Applied to my amdkfd-fixes tree.

	Oded
