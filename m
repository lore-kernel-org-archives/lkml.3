Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbaLKCse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:48:34 -0500
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:35132
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933176AbaLKCsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:48:33 -0500
Message-ID: <548906FD.5070009@freescale.com>
Date: Thu, 11 Dec 2014 10:52:45 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <p.zabel@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: Re: [PATCH RFC 04/15] drm/dsi: Do not add DSI devices for the child
 nodes with input-port property
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-5-git-send-email-Ying.Liu@freescale.com>
 <20141210122105.GC23558@ulmo.nvidia.com>
In-Reply-To: <20141210122105.GC23558@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(189002)(377454003)(479174003)(51704005)(52604005)(65816999)(64706001)(120916001)(50986999)(23746002)(110136001)(50466002)(68736005)(62966003)(99396003)(87936001)(20776003)(47776003)(87266999)(59896002)(77156002)(85426001)(4396001)(84676001)(31966008)(92566001)(65806001)(65956001)(77096005)(104016003)(46102003)(33656002)(86362001)(19580395003)(21056001)(97736003)(106466001)(107046002)(64126003)(99136001)(105606002)(54356999)(19580405001)(76176999)(36756003)(6806004)(80316001)(83506001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0630;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BY2PR0301MB0630;
X-Forefront-PRVS: 0422860ED4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/10/2014 08:21 PM, Thierry Reding wrote:
> On Wed, Dec 10, 2014 at 04:37:17PM +0800, Liu Ying wrote:
>> The MIPI DSI bus driver would try to add a DSI device for a host's every
>> child node which contains the reg property.  Unfortunately, the existing
>> i.MX6Q/SDL MIPI DSI host device tree node's child nodes contain the reg
>
> There aren't any existing nodes for the DSI host on i.MX. This patch
> series adds support for them.

There are existing nodes for the DSI host node. Please find them in 
arch/arm/boot/dts/imx6qdl.dtsi and arch/arm/boot/dts/imx6q.dts. The DSI 
host node contains two child nodes for i.MX6DL and another two for 
i.MX6Q.  Each child node has a reg property embedded.

>
>> property, but the child nodes are ports pointing to dedicated CRTCs.
>> So, this patch phases out the child nodes with input-port property before
>> adding DSI devices for them and updates the MIPI DSI bus OF binding
>> documentation.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>   Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt | 4 ++++
>>   drivers/gpu/drm/drm_mipi_dsi.c                              | 5 +++--
>>   2 files changed, 7 insertions(+), 2 deletions(-)
>
> Sorry, but NAK. There's no need for this special-case. I'll go into more
> detail in response to patch 09/15.

Thanks for reviewing the patches.

Any idea how to handle the special case?  The existing child nodes for 
the DSI host node do have the reg properties embedded.

Regards,

Liu Ying

>
> Thierry
>
