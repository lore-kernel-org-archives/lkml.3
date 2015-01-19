Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbASS1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:27:31 -0500
Received: from mail-bn1bon0135.outbound.protection.outlook.com ([157.56.111.135]:45866
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752475AbbASS13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:27:29 -0500
X-WSS-ID: 0NIFSLN-07-415-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drm/radeon: remove unreachable code
Thread-Topic: [PATCH] drm/radeon: remove unreachable code
Thread-Index: AQHQM+p6wWkt46VcAEWMKMC4IYuhl5zHwe5w
Date: Mon, 19 Jan 2015 18:27:23 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D0635F03CC@satlexdag05.amd.com>
References: <1421673040-12305-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1421673040-12305-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(377454003)(13464003)(199003)(105586002)(2950100001)(47776003)(87936001)(50466002)(106466001)(50986999)(2656002)(77156002)(55846006)(53416004)(62966003)(64706001)(92566002)(76176999)(54356999)(23726002)(106116001)(2900100001)(86362001)(46102003)(33656002)(19580405001)(19580395003)(97756001)(110136001)(68736005)(101416001)(102836002)(46406003)(97736003)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB195;
X-Forefront-PRVS: 046164D5C4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2015 18:27:25.6511
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nicholas Mc Guire [mailto:der.herr@hofr.at]
> Sent: Monday, January 19, 2015 8:11 AM
> To: Deucher, Alexander
> Cc: Koenig, Christian; David Airlie; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; Nicholas Mc Guire
> Subject: [PATCH] drm/radeon: remove unreachable code
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

NACK.  I want to leave this in place for the future.  When we support dynamically adjusting the disp clock we'll need to update the sclk for ds mode.

Alex

> ---
> 
> As the if (CISLAND_MINIMUM_ENGINE_CLOCK !=
> CISLAND_MINIMUM_ENGINE_CLOCK) is never
> satisfied - the entire else branch is never going to be executed and could be
> removed - provided this is not simply a bug and needs to be fixed...
> 
> Patch is against 3.19.0-rc5 -next-20150119
> 
> Patch was only compile tested with x86_64_defconfig + CONFIG_DRM=m,
> CONFIG_DRM_RADEON=m
> 
>  drivers/gpu/drm/radeon/ci_dpm.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/ci_dpm.c
> b/drivers/gpu/drm/radeon/ci_dpm.c
> index f373a81..28db529 100644
> --- a/drivers/gpu/drm/radeon/ci_dpm.c
> +++ b/drivers/gpu/drm/radeon/ci_dpm.c
> @@ -3805,13 +3805,8 @@ static void
> ci_find_dpm_states_clocks_in_dpm_table(struct radeon_device *rdev,
>  			break;
>  	}
> 
> -	if (i >= sclk_table->count) {
> +	if (i >= sclk_table->count)
>  		pi->need_update_smu7_dpm_table |=
> DPMTABLE_OD_UPDATE_SCLK;
> -	} else {
> -		/* XXX check display min clock requirements */
> -		if (CISLAND_MINIMUM_ENGINE_CLOCK !=
> CISLAND_MINIMUM_ENGINE_CLOCK)
> -			pi->need_update_smu7_dpm_table |=
> DPMTABLE_UPDATE_SCLK;
> -	}
> 
>  	for (i = 0; i < mclk_table->count; i++) {
>  		if (mclk == mclk_table->dpm_levels[i].value)
> --
> 1.7.10.4

