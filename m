Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaLULNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:13:19 -0500
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:7206
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204AbaLULNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:13:15 -0500
X-WSS-ID: 0NGXJ5S-07-8T4-02
X-M-MSG: 
Message-ID: <5496AB2F.9050804@amd.com>
Date: Sun, 21 Dec 2014 13:12:47 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <j.glisse@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, John Bridgman <John.Bridgman@amd.com>,
        <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
 <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
 <20141220212515.GA30589@kroah.com>
In-Reply-To: <20141220212515.GA30589@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(377454003)(479174004)(189002)(199003)(46102003)(65816999)(101416001)(97736003)(21056001)(99396003)(76176999)(50986999)(59896002)(54356999)(77156002)(62966003)(50466002)(120916001)(87936001)(20776003)(64706001)(33656002)(2950100001)(4396001)(83506001)(65956001)(65806001)(15975445007)(68736005)(77096005)(64126003)(84676001)(31966008)(19580405001)(47776003)(80316001)(106466001)(105586002)(107046002)(23746002)(92566001)(110136001)(19580395003)(36756003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0432A04947
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2014 11:13:06.4927
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/20/2014 11:25 PM, Greg KH wrote:
> On Sat, Dec 20, 2014 at 10:46:12PM +0200, Oded Gabbay wrote:
>> When amdkfd and radeon are compiled inside the kernel image (not as modules),
>> radeon will load before amdkfd and will set *kfd2kgd to its interface
>> structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd is loaded
>> because it will override radeon's initialization and cause kernel BUG.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> index 95d5af1..236562f 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> @@ -34,7 +34,7 @@
>>   #define KFD_DRIVER_MINOR	7
>>   #define KFD_DRIVER_PATCHLEVEL	0
>>
>> -const struct kfd2kgd_calls *kfd2kgd;
>> +const struct kfd2kgd_calls *kfd2kgd = NULL;
>
> This change does nothing, that is what the original code did already.
>
> thanks,
>
> greg k-h
Yeah. Sorry, I will remove it.
	
	Oded
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
