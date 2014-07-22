Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaGVScU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:32:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54468 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbaGVScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:32:18 -0400
Message-ID: <53CEAE0F.9080901@ti.com>
Date: Tue, 22 Jul 2014 13:31:43 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
CC: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pinctrl: dra: dt-bindings: Fix pull enable/disable
References: <1406043594-14181-1-git-send-email-nm@ti.com> <20140722164752.GJ20588@saruman.home>
In-Reply-To: <20140722164752.GJ20588@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 11:47 AM, Felipe Balbi wrote:
> On Tue, Jul 22, 2014 at 10:39:54AM -0500, Nishanth Menon wrote:
>> The DRA74/72 control module pins have a weak pull up and pull down.
>> This is configured by bit offset 17. if BIT(17) is 1, a pull up is
>> selected, else a pull down is selected.
>>
>> However, this pull resisstor is applied based on BIT(16) -
>> PULLUDENABLE - if BIT(18) is *0*, then pull as defined in BIT(17) is
>> applied, else no weak pulls are applied. We defined this in reverse.
>>
>> Reference: Table 18-5 (Description of the pad configuration register
>> bits) in Technical Reference Manual Revision (DRA74x revision Q:
>> SPRUHI2Q Revised June 2014 and DRA72x revision F: SPRUHP2F - Revised
>> June 2014)
>>
>> Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
> 
> Tested on an upcoming board.
> 
> Tested-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> 
Felipe,
Thanks.

Tony,

If you could consider this for the rc cycle it might be great(as well
as for stable). The pull direction error can cause all kinds of
Pull-down Vs Pull-Up contention with severe risk for certain IP
reliability.

-- 
Regards,
Nishanth Menon
