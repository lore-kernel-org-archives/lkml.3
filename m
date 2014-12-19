Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaLSCT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:19:27 -0500
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:32288
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387AbaLSCTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:19:25 -0500
X-Greylist: delayed 69097 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2014 21:19:25 EST
Message-ID: <54938C2D.1020504@freescale.com>
Date: Fri, 19 Dec 2014 10:23:41 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 05/14] ARM: imx6q: clk: Add the video_27m clock
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-6-git-send-email-Ying.Liu@freescale.com>
 <1418898675.4212.10.camel@pengutronix.de>
In-Reply-To: <1418898675.4212.10.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(24454002)(377454003)(189002)(51704005)(479174004)(164054003)(23676002)(2950100001)(76176999)(84676001)(106466001)(105606002)(107046002)(97736003)(77096005)(21056001)(19580395003)(83506001)(110136001)(33656002)(99136001)(77156002)(6806004)(120916001)(54356999)(62966003)(50986999)(99396003)(19580405001)(65816999)(87936001)(64706001)(47776003)(20776003)(46102003)(65806001)(85426001)(4396001)(104016003)(86362001)(68736005)(50466002)(80316001)(36756003)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0637;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0637;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 02:19:22.2551
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 12/18/2014 06:31 PM, Philipp Zabel wrote:
> Am Donnerstag, den 18.12.2014, 15:11 +0800 schrieb Liu Ying:
>> This patch supports the video_27m clock which is a fixed factor
>> clock of the pll3_pfd1_540m clock.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>> v1->v2:
>>   * None.
>>
>>   arch/arm/mach-imx/clk-imx6q.c             | 1 +
>>   include/dt-bindings/clock/imx6qdl-clock.h | 3 ++-
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
>> index 4e79da7..9470df3 100644
>> --- a/arch/arm/mach-imx/clk-imx6q.c
>> +++ b/arch/arm/mach-imx/clk-imx6q.c
>> @@ -246,6 +246,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>>   	clk[IMX6QDL_CLK_PLL3_60M]  = imx_clk_fixed_factor("pll3_60m",  "pll3_usb_otg",   1, 8);
>>   	clk[IMX6QDL_CLK_TWD]       = imx_clk_fixed_factor("twd",       "arm",            1, 2);
>>   	clk[IMX6QDL_CLK_GPT_3M]    = imx_clk_fixed_factor("gpt_3m",    "osc",            1, 8);
>> +	clk[IMX6QDL_CLK_VIDEO_27M] = imx_clk_fixed_factor("video_27m", "pll3_pfd1_540m", 1, 20);
>
> The HDMI TX isfr clock input is sourced from video_27m, too, according
> to Table 33-1 "HDMI clocks".
> I think the parent of clk[IMX6QDL_CLK_HDMI_ISFR] should be changed from
> "pll3_pfd1_540m" to "video_27m", then.

I'll add a new patch in the next version to change the hdmi_isfr
clock's parent.

Thanks,
Liu Ying

>
> regards
> Philipp
>
