Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbaLKFpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:45:49 -0500
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:53885
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222AbaLKFpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:45:47 -0500
Message-ID: <54893088.4000203@freescale.com>
Date: Thu, 11 Dec 2014 13:50:00 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 04/15] drm/dsi: Do not add DSI devices for the child
 nodes with input-port property
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-5-git-send-email-Ying.Liu@freescale.com>
 <20141210122105.GC23558@ulmo.nvidia.com> <548906FD.5070009@freescale.com>
In-Reply-To: <548906FD.5070009@freescale.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(479174003)(51704005)(24454002)(52604005)(199003)(15975445007)(69596002)(65806001)(65956001)(68736005)(77096005)(87936001)(1720100001)(99396003)(117636001)(23676002)(83506001)(77156002)(120916001)(107046002)(62966003)(6806004)(81156004)(106466001)(19580405001)(54356999)(19580395003)(59896002)(64706001)(84676001)(93886004)(104016003)(76176999)(87266999)(47776003)(86362001)(92566001)(105606002)(97736003)(21056001)(46102003)(110136001)(65816999)(4396001)(50986999)(20776003)(50466002)(36756003)(64126003)(31966008)(217873001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0638;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:DM2PR0301MB0638;
X-Forefront-PRVS: 0422860ED4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/11/2014 10:52 AM, Liu Ying wrote:
> Hi Thierry,
>
> On 12/10/2014 08:21 PM, Thierry Reding wrote:
>> On Wed, Dec 10, 2014 at 04:37:17PM +0800, Liu Ying wrote:
>>> The MIPI DSI bus driver would try to add a DSI device for a host's every
>>> child node which contains the reg property.  Unfortunately, the existing
>>> i.MX6Q/SDL MIPI DSI host device tree node's child nodes contain the reg
>>
>> There aren't any existing nodes for the DSI host on i.MX. This patch
>> series adds support for them.
>
> There are existing nodes for the DSI host node. Please find them in
> arch/arm/boot/dts/imx6qdl.dtsi and arch/arm/boot/dts/imx6q.dts. The DSI
> host node contains two child nodes for i.MX6DL and another two for
> i.MX6Q.  Each child node has a reg property embedded.
>
>>
>>> property, but the child nodes are ports pointing to dedicated CRTCs.
>>> So, this patch phases out the child nodes with input-port property
>>> before
>>> adding DSI devices for them and updates the MIPI DSI bus OF binding
>>> documentation.
>>>
>>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>>> ---
>>>   Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt | 4 ++++
>>>   drivers/gpu/drm/drm_mipi_dsi.c                              | 5 +++--
>>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> Sorry, but NAK. There's no need for this special-case. I'll go into more
>> detail in response to patch 09/15.
>
> Thanks for reviewing the patches.
>
> Any idea how to handle the special case?  The existing child nodes for
> the DSI host node do have the reg properties embedded.
>

I see your suggestions on this topic in the comments for patch 09/15.
I will try to move the existing child nodes into a parent port node.

Liu Ying

>
>>
>> Thierry
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
