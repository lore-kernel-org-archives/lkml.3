Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaDNWNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:13:20 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:26432
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755682AbaDNWNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:13:15 -0400
X-Greylist: delayed 1783 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 18:13:15 EDT
X-WSS-ID: 0N41KDV-08-EI7-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Christoph Jaeger <christophjaeger@linux.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "airlied@linux.ie" <airlied@linux.ie>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drm/radeon: fix VCE fence command
Thread-Topic: [PATCH] drm/radeon: fix VCE fence command
Thread-Index: AQHPWC5qzje95AzAV0CBczEcWMQp+ZsRrN4A
Date: Mon, 14 Apr 2014 22:13:08 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D03ECB19EF@satlexdag05.amd.com>
References: <1397513422-1566-1-git-send-email-christophjaeger@linux.com>
In-Reply-To: <1397513422-1566-1-git-send-email-christophjaeger@linux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(13464003)(51704005)(97756001)(80976001)(44976005)(19580395003)(83322001)(19580405001)(50986999)(76176999)(54356999)(99396002)(2009001)(50466002)(53416003)(4396001)(76482001)(55846006)(79102001)(23726002)(80022001)(20776003)(47776003)(81542001)(46406003)(2656002)(92566001)(92726001)(86362001)(84676001)(46102001)(77982001)(33656001)(81342001)(87936001)(85852003)(31966008)(74502001)(74662001)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:atltwp02.amd.com;FPR:1A7E41A1.80F70542.F3E0AB87.B2EE7AC2.201F6;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0181F4652A
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Christoph Jaeger [mailto:christophjaeger@linux.com]
> Sent: Monday, April 14, 2014 6:10 PM
> To: Deucher, Alexander; Koenig, Christian; airlied@linux.ie
> Cc: dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; Christoph
> Jaeger
> Subject: [PATCH] drm/radeon: fix VCE fence command
> 
> Due to a type mismatch that causes an implicit type conversion, the
> upper 32 bits of the GPU address have been zeroed out when adding to the
> command buffer.
> 
> Picked up by Coverity - CID 1198624.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Good catch!

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/radeon_vce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_vce.c
> b/drivers/gpu/drm/radeon/radeon_vce.c
> index 76e9904..ced53dd 100644
> --- a/drivers/gpu/drm/radeon/radeon_vce.c
> +++ b/drivers/gpu/drm/radeon/radeon_vce.c
> @@ -613,7 +613,7 @@ void radeon_vce_fence_emit(struct radeon_device
> *rdev,
>  			   struct radeon_fence *fence)
>  {
>  	struct radeon_ring *ring = &rdev->ring[fence->ring];
> -	uint32_t addr = rdev->fence_drv[fence->ring].gpu_addr;
> +	uint64_t addr = rdev->fence_drv[fence->ring].gpu_addr;
> 
>  	radeon_ring_write(ring, VCE_CMD_FENCE);
>  	radeon_ring_write(ring, addr);
> --
> 1.9.0

