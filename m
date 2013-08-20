Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926Ab3HTKIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:08:31 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:41500
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802Ab3HTKIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:08:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1889i1155h)
Message-ID: <52134030.4030502@freescale.com>
Date: Tue, 20 Aug 2013 18:08:48 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <kernel@pengutronix.de>, <gregkh@linuxfoundation.org>,
        <shawn.guo@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 0/3] refactor some ldb related clocks
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com> <1376991823.4000.22.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1376991823.4000.22.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 05:43 PM, Philipp Zabel wrote:
> Am Dienstag, den 20.08.2013, 16:38 +0800 schrieb Liu Ying:
>> The ldb_di[0/1]_ipu_div clock dividers in the CSCMR2 register
>> of i.MX53, i.MX6Q and i.MX6DL SoCs can be configured to a 1/3.5
>> drivider or a 1/7 divider. The common clock framework cannot
>> deal with the two dividers directly even with the divider table
>> which only supports integral dividers. So, the idea is to take
>> the 1/3.5 and 1/7 dividers as separate fixed factor dividers and
>> introduce a new multiplexer clock to be derived from the them.
>> Then, the ldb display clock trees can be setup correctly.
>> This series contains the necessary clock driver changes, dts code
>> changes and imx-drm/ldb driver changes to fullfill the task.
> 
> I don't see how this improves the situation. Does this solve any real
> problem?
>

I don't see any functional problem without this series.
But, it may correct ldb_di[n] clock frequency returned from clk_get_rate() when using 1/7 divider.
Furthermore, since this series makes the ldb related clocks from pll to ldb_di[0/1] have the CLK_SET_RATE_PARENT flag set, the imx-drm/ldb driver may set the clocks' frequency more flexibly, i.e.,
only calling clk_set_rate() for ldb_di[n] clock would be an alternative.

> While I admit to having introduced the combination of 1/3.5 fixed
> divider and configurable 1/1,1/2 divder clocks to describe this
> fractional divider for the reasons you state, I think the correct
> solution would be to improve the table divider to support fractional
> values and get rid of the virtual ldb_di<n>_div_3_5 clocks, not
> introduce more virtual clocks.

Yes, it's good to support fractional values for the table divider(not sure if there is any plan for this).
I see there is something similar in 'include/linux/sh_clk.h'.

> 
> regards
> Philipp
> 
> 

Regards,
Liu Ying

