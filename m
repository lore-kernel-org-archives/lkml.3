Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbAHDGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:06:24 -0500
Received: from mail-bl2on0109.outbound.protection.outlook.com ([65.55.169.109]:45029
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752151AbbAHDGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:06:22 -0500
X-WSS-ID: 0NHU7YA-08-AZT-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: RE: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
 by default on BTC
Thread-Topic: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm
 by default on BTC
Thread-Index: AQHQKsyDkXQZKaorv0C9Tt5ssWsoXZy1RGNQ
Date: Thu, 8 Jan 2015 02:51:45 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D0635DD4D6@satlexdag06.amd.com>
References: <54ADB86B.10105@canonical.com>
In-Reply-To: <54ADB86B.10105@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(13464003)(377454003)(189002)(199003)(51704005)(164054003)(105586002)(120916001)(19580395003)(19580405001)(68736005)(47776003)(20776003)(99396003)(4396001)(21056001)(46102003)(87936001)(92566001)(77156002)(62966003)(110136001)(1720100001)(102836002)(107046002)(15975445007)(97736003)(64706001)(106466001)(31966008)(106116001)(575784001)(86362001)(23676002)(55846006)(2900100001)(101416001)(53416004)(2950100001)(15198665003)(2656002)(2920100001)(54356999)(50986999)(76176999)(15395725005)(50466002)(33656002)(84676001)(10090945008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR02MB202;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB202;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 02:51:48.9817
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0836USF028362



> -----Original Message-----
> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com]
> Sent: Wednesday, January 07, 2015 5:51 PM
> To: Deucher, Alexander
> Cc: stable@vger.kernel.org; LKML; Koenig, Christian; David Airlie; dri-devel
> Subject: [Regression][v3.17][3.18][3.19-rc3] drm/radeon: re-enable dpm by
> default on BTC
> 
> Hi Alexander,
> 
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
> 
> commit c08abf11900e19b14dd3a0cc3d105bd74519cd18
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Mon Jul 14 12:01:40 2014 -0400
> 
>     drm/radeon: re-enable dpm by default on BTC
> 
> The regression was introduced as of v3.17-rc1 and still exists in
> current mainline.  It has also made it's way into the stable releases.
> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
> 

Does revering b2dccf24e77 help?  I'd hate to revert this patch because it disables power management for a whole family of chips.  If it doesn't help I'd prefer to just add a quirk to disable it for the specific problematic board.

Alex

> 
> Thanks,
> 
> Joe
> 
> [0] http://pad.lv/1386534

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
