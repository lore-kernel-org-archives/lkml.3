Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaLVCwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:52:40 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:12968
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753633AbaLVCwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:52:38 -0500
Message-ID: <54978876.3090408@freescale.com>
Date: Mon, 22 Dec 2014 10:56:54 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <thierry.reding@gmail.com>, <kernel@pengutronix.de>,
        <mturquette@linaro.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC v2 08/14] drm: imx: Add MIPI DSI host controller driver
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-9-git-send-email-Ying.Liu@freescale.com>
	 <1418902740.4212.46.camel@pengutronix.de> <5493BD52.8070804@freescale.com>
 <1418984246.3165.45.camel@pengutronix.de>
In-Reply-To: <1418984246.3165.45.camel@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(479174004)(199003)(377454003)(189002)(54534003)(24454002)(51704005)(57704003)(83506001)(68736005)(46102003)(19580395003)(21056001)(85426001)(77096005)(2950100001)(23746002)(99396003)(84676001)(120916001)(19580405001)(6806004)(93886004)(97736003)(16799955002)(64126003)(50986999)(54356999)(87266999)(76176999)(65806001)(36756003)(65816999)(64706001)(105606002)(50466002)(86362001)(59896002)(77156002)(47776003)(31966008)(92566001)(15975445007)(87936001)(117636001)(99136001)(107046002)(104016003)(4396001)(62966003)(110136001)(106466001)(20776003)(217873001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0630;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0630;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 02:52:33.5747
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0630
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 12/19/2014 06:17 PM, Philipp Zabel wrote:
> Hi Liu,
>
> Am Freitag, den 19.12.2014, 13:53 +0800 schrieb Liu Ying:
> [...]
>>>> +	mipi_dsi: mipi@021e0000 {
>>>> +		#address-cells = <1>;
>>>> +		#size-cells = <0>;
>>>> +		compatible = "fsl,imx6q-mipi-dsi";
>>>> +		reg = <0x021e0000 0x4000>;
>>>> +		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
>>>> +		gpr = <&gpr>;
>>>> +		clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
>>>> +			 <&clks IMX6QDL_CLK_HSI_TX>,
>>>> +			 <&clks IMX6QDL_CLK_HSI_TX>;
>>>> +		clock-names = "pllref", "pllref_gate", "core_cfg";
>>>
>>> Not sure about this. Are those names from the Synopsys documentation?
>>
>> No, I don't think it's from there.
>
> Do you have access to it? I'd like to see the proper names used if
> possible, considering this IP core will be used on other SoCs, too.

I'm using the Synopsys documentation for Freescale copy.
I'm not sure if it may be provided in the open mailing lists.

You probably may try [1] to require one copy from Synopsys.

[1] https://www.synopsys.com/dw/ipdir.php?ds=mipi_dsi

>
>>> According to Table 41-1 in the i.MX6Q Reference Manual, this module has
>>> 6 clock inputs:
>>>    - ac_clk_125m (from ahb_clk_root)
>>>    - pixel_clk (from axi_clk_root)
>>>    - cfg_clk and pll_refclk (from video_27m)
>>>    - ips_clk and ipg_clk_s (from ipg_clk_root)
>>> The CCM chapter says that of these, "ac_clk_125m", "cfg_clk", ips_clk",
>>> and "pll_refclk" are gated by a single bit called
>>> "mipi_core_cfg_clk_enable", that is clk[CLK_HSI_TX].
>>> If that is correct, I see no reason for the "pllref_gate" clock.
>>> I suppose two clocks "pllref" and "cfg" should suffice.
>>
>> Using the two clocks makes the code look like this, perhaps:
>>
>>         clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
>>                  <&clks IMX6QDL_CLK_HSI_TX>;
>>         clock-names = "pllref", "core_cfg";
>>
>> Then, it seems that I have no way to disable the pllref clock if
>> using the clock tree after applying this patch set?
>
> Correct. In my opinion we should put a new gate clock in the clock path
> between video_27m and the pllref input triggers the same bit as hsi_tx,
> see below.
>
>> Or, perhaps, this one?
>>
>>         clocks = <&clks IMX6QDL_CLK_HSI_TX>,
>>                  <&clks IMX6QDL_CLK_HSI_TX>;
>>         clock-names = "pllref", "core_cfg";
>>
>> This only uses the gate clock hsi_tx.  The current clock tree states
>> that it comes from:
>>
>>        pll3_120m ->
>>                    | -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
>> pll2_pfd2_396m ->
>>
>> So, I can not get the correct pllref clock frequency with this tree.
>> The pllref clock should be derived from the video_27m clock.
>
> According to the i.MX6 reference manual, the cfg clock also is derived
> from video_27m, so both have the wrong rate if connected to hsi_tx (yes,
> for cfg we don't care about the rate).
>
> Currently we have this:
>
> pll2_pfd2_396m -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
> pll3_pfd1_540m -> video_27m -> hdmi_isfr
>
> - hsi_tx_podf represents the hsi_tx_clk_root at its output.
> - hsi_tx represents the gate between hsi_tx_clk_root and the tx_ref_clk
>    input to the MIPI_HSI module, which is controlled by the
>    mipi_core_cfg_clk_enable bit.
> - video_27m represents the video_27m_clk_root at its output.
>
> I'd say we should turn hsi_tx into a shared gate clock and add a new
> shared gate clock using the same gate bit. Maybe name it mipi_core_cfg,
> after the gating bit in the CCM.
>
> pll2_pfd2_396m -> hsi_tx_sel -> hsi_tx_podf -> hsi_tx
> pll3_pfd1_540m -> video_27m -> mipi_core_cfg
> pll3_pfd1_540m -> video_27m -> hdmi_isfr
>
> - mipi_core_cfg represents the gate between video_27_clk_root and the
>    cfg_clk and pllref_clk inputs to the MIPI_DSI module, which is also
>    controlled by the mipi_core_cfg_clk_enable bit.
>
>> The way I decided to use the three clocks is:
>> 1) PLL related
>> * pllref clock only cares about the pll reference rate(the frequency).
>>     And, the frequency does matter as it has an impact on the lane clock
>>     frequency.
>> * pllref_gate is a gate clock and it only cares about the gate.
>>
>> 2) register configuration related
>> * core_cfg is a gate clock and it only cares about the gate.
>> Usually, the register configuration clock frequency is not so important
>> and the gate is what we really need.
>>
>> I am currently not strong on the way I used.  I am open to any better
>> solution.
>
> Since cfg is a real clock input to the MIPI DSI IP, that's ok. But the
> two pllref entries in reality are one and the same clock input.
>
>>> Maybe HSI_TX should be split up into multiple shared gate clocks that
>>> all set the mipi_core_cfg clock bits (see below).
>>
>> Yes, maybe.
>> If that's the case, do we need to add two gate clocks in the DT node to
>> represent cfg_gate and pllref_gate respectively?
>
> I'd say yes. While on i.MX6 it could be represented by a single clock
> because both have the same rate and use the same gate bit, that doesn't
> have to be the case on other SoCs. With my suggestion above, that would
> be:
>
> 	clocks = <&clks IMX6QDL_CLK_MIPI_CORE_CFG>,
> 		 <&clks IMX6QDL_CLK_MIPI_CORE_CFG>;
> 	clock-names = "pllref", "cfg";

Your suggestion looks better. I'll implement it in the next version
and give you the "Suggested-by" credit. Thanks.

>
>>>> diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
> [...]
>>>> +static int imx_mipi_dsi_bind(struct device *dev, struct device *master, void *data)
>>>> +{
> [...]
>>>> +	dsi->pllref_clk = devm_clk_get(dev, "pllref");
>>>> +	if (IS_ERR(dsi->pllref_clk)) {
>>>> +		ret = PTR_ERR(dsi->pllref_clk);
>>>> +		dev_err(dev, "Unable to get pll reference clock: %d\n", ret);
>>>> +		return ret;
>>>> +	}
>>>> +	clk_prepare_enable(dsi->pllref_clk);
>
> What I mean below is this: Here you enable pllref ...
>
> [...]
>>>> +	dsi->cfg_clk = devm_clk_get(dev, "core_cfg");
>>>> +	if (IS_ERR(dsi->cfg_clk)) {
>>>> +		ret = PTR_ERR(dsi->cfg_clk);
>>>> +		dev_err(dev, "Unable to get configuration clock: %d\n", ret);
>>>
>>> And leave pllref enabled?
>>
>> As I mentioned in the v1-> v2 change log, I enable/disable the
>> pllref_clk and pllref_gate_clk at the component binding/unbinding stages
>> to help remove the flag 'enabled' introduced in v1.
>>
>> I referred to the i.MX HDMI driver which enables/disables the isfr clock
>> and the iahb clock at the component binding/unbinding stages.
>>
>> I may try to handle the clock enablement/disablement more decently and
>> avoid using the flag 'enable'.
>>
>>>
>>>> +		return ret;
>
> ... and here you return with an error without disabling pllref again. If
> the bind fails, unbind won't be called, and the clock stays enabled. For
> reference, see how imx-hdmi unprepare_disables its iahb/isfr clocks in
> the bind function's error path.

I'll improve the logic for the bail-out path.

Regards,
Liu Ying

>
>>>> +	}
>>>> +
>>>> +	clk_prepare_enable(dsi->cfg_clk);
>>>> +	val = dsi_read(dsi, DSI_VERSION);
>>>> +	clk_disable_unprepare(dsi->cfg_clk);
>>>> +
>>>> +	dev_info(dev, "version number is 0x%08x\n", val);
>>>> +
>>>> +	ret = imx_mipi_dsi_register(drm, dsi);
>>>> +	if (ret)
>>>
>>> Same here.
>>
>> You meant that the pllref_gate clock is left enabled above, right?
>
> Yes.
>
>> Regards,
>> Liu Ying
>>
>>>
>>>> +		return ret;
>
> This return with an error leaves the pllref enabled.
>
> regards
> Philipp
>
