Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaDOJRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:17:34 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:2575
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbaDOJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:17:30 -0400
X-WSS-ID: 0N42F4X-08-64S-02
X-M-MSG: 
Message-ID: <534CF922.8010204@amd.com>
Date: Tue, 15 Apr 2014 11:17:22 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Christoph Jaeger <christophjaeger@linux.com>,
        "airlied@linux.ie" <airlied@linux.ie>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/radeon: fix VCE fence command
References: <1397513422-1566-1-git-send-email-christophjaeger@linux.com>
 <A3397C8B8B789E45844E7EC5DEAD89D03ECB19EF@satlexdag05.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D03ECB19EF@satlexdag05.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.106]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(199002)(189002)(51704005)(164054003)(13464003)(83072002)(85852003)(77982001)(20776003)(47776003)(59896001)(84676001)(87936001)(92566001)(65956001)(80022001)(92726001)(50466002)(86362001)(2009001)(74502001)(74662001)(50986999)(31966008)(64126003)(77096999)(54356999)(76176999)(99396002)(97736001)(65816999)(83322001)(23756003)(44976005)(19580405001)(19580395003)(4396001)(80976001)(81342001)(76482001)(33656001)(65806001)(83506001)(81542001)(46102001)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB115;H:atltwp02.amd.com;FPR:1A7E41A1.80F30542.F0E0AB87.B2EC7ACA.2021C;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0182DBBB05
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.04.2014 00:13, schrieb Deucher, Alexander:
>> -----Original Message-----
>> From: Christoph Jaeger [mailto:christophjaeger@linux.com]
>> Sent: Monday, April 14, 2014 6:10 PM
>> To: Deucher, Alexander; Koenig, Christian; airlied@linux.ie
>> Cc: dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; Christoph
>> Jaeger
>> Subject: [PATCH] drm/radeon: fix VCE fence command
>>
>> Due to a type mismatch that causes an implicit type conversion, the
>> upper 32 bits of the GPU address have been zeroed out when adding to the
>> command buffer.
>>
>> Picked up by Coverity - CID 1198624.
>>
>> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> Good catch!

Indeed.

>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Added to my 3.15 fixes queue.

Thanks,
Christian.

>
>> ---
>>   drivers/gpu/drm/radeon/radeon_vce.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_vce.c
>> b/drivers/gpu/drm/radeon/radeon_vce.c
>> index 76e9904..ced53dd 100644
>> --- a/drivers/gpu/drm/radeon/radeon_vce.c
>> +++ b/drivers/gpu/drm/radeon/radeon_vce.c
>> @@ -613,7 +613,7 @@ void radeon_vce_fence_emit(struct radeon_device
>> *rdev,
>>   			   struct radeon_fence *fence)
>>   {
>>   	struct radeon_ring *ring = &rdev->ring[fence->ring];
>> -	uint32_t addr = rdev->fence_drv[fence->ring].gpu_addr;
>> +	uint64_t addr = rdev->fence_drv[fence->ring].gpu_addr;
>>
>>   	radeon_ring_write(ring, VCE_CMD_FENCE);
>>   	radeon_ring_write(ring, addr);
>> --
>> 1.9.0

