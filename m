Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaLDMVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:21:44 -0500
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:1909
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753420AbaLDMVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:21:42 -0500
X-WSS-ID: 0NG2500-08-ES1-02
X-M-MSG: 
Message-ID: <548051BE.3000602@amd.com>
Date: Thu, 4 Dec 2014 14:21:18 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <airlied@linux.ie>, <alexander.deucher@amd.com>, <j.glisse@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <John.Bridgman@amd.com>, <Andrew.Lewycky@amd.com>, <joro@8bytes.org>
Subject: Re: [PATCH] amdkfd: use sizeof(long) granularity for the pasid bitmask
References: <1417616785-5143-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1417616785-5143-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(479174003)(199003)(41574002)(51704005)(189002)(24454002)(65806001)(80316001)(20776003)(68736005)(59896002)(19580395003)(19580405001)(92726001)(84676001)(92566001)(97736003)(86362001)(50466002)(23676002)(77096005)(99396003)(110136001)(64126003)(64706001)(120916001)(36756003)(47776003)(21056001)(102836001)(95666004)(106466001)(31966008)(33656002)(87936001)(46102003)(101416001)(62966003)(65816999)(50986999)(76176999)(105586002)(54356999)(83506001)(4396001)(87266999)(77156002)(107046002)(99136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601001);SRVR:BN1PR02MB199;
X-Forefront-PRVS: 041517DFAB
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2014 04:26 PM, Sasha Levin wrote:
> All the bit operations (such as find_first_zero_bit()) read sizeof(long) bytes
> at a time. If we allocated less than sizeof(long) bytes for the bitmask we
> would be accessing invalid memory when working with the bitmask.
>
> Change the allocator to allocate sizeof(long) multiples for the bitmask.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_pasid.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> index 2458ab7..71699ad 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
> @@ -32,8 +32,7 @@ int kfd_pasid_init(void)
>   {
>   	pasid_limit = max_num_of_processes;
>
> -	pasid_bitmap = kzalloc(DIV_ROUND_UP(pasid_limit, BITS_PER_BYTE),
> -				GFP_KERNEL);
> +	pasid_bitmap = kzalloc(BITS_TO_LONGS(pasid_limit), GFP_KERNEL);
>   	if (!pasid_bitmap)
>   		return -ENOMEM;
>
>

Thanks!
Applied to my -next tree.

Oded
