Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLaDig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:38:36 -0500
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:29616
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbaLaDi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:38:29 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH 3/4] ASoC: wm8960: use pr_debug instead of pr_err
Date: Wed, 31 Dec 2014 11:39:13 +0800
Message-ID: <1419997154-860-3-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419997154-860-1-git-send-email-b50113@freescale.com>
References: <1419997154-860-1-git-send-email-b50113@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(62966003)(21056001)(69596002)(77156002)(33646002)(85426001)(92566001)(84676001)(87936001)(2950100001)(81156004)(48376002)(50986999)(107046002)(76176999)(31966008)(104016003)(106466001)(2351001)(6806004)(47776003)(19580395003)(46102003)(50466002)(4396001)(77096005)(99396003)(68736005)(110136001)(89996001)(20776003)(229853001)(120916001)(50226001)(97736003)(36756003)(19580405001)(64706001)(86362001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1251;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1251;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1251;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1251;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 03:38:26.8945
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine driver, we should find a appropriate sysclk for codec driver,
and will use codec set_dai_pll to judge if pll can generate such sysclk.
When sample rate changed, we should look for a useful bclk, lrclk division
ratio, and will try set_dai_pll for several times. So use pr_debug so that
don't generate much error logs.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 86a5489..cb42385 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -914,7 +914,7 @@ static int pll_factors(unsigned int source, unsigned int target,
 		pll_div->pre_div = 0;
 
 	if ((Ndiv < 6) || (Ndiv > 12)) {
-		pr_err("WM8960 PLL: Unsupported N=%d\n", Ndiv);
+		pr_debug("WM8960 PLL: Unsupported N=%d\n", Ndiv);
 		return -EINVAL;
 	}
 
-- 
1.9.1

