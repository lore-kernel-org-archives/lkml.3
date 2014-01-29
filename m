Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaA2JKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:10:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53462 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaA2JKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:10:39 -0500
Message-ID: <52E8C586.7040907@ti.com>
Date: Wed, 29 Jan 2014 11:10:30 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <chf.fritz@googlemail.com>, <nm@ti.com>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com> <52E76EE0.2060006@ti.com> <52E7F451.7040708@gmail.com>
In-Reply-To: <52E7F451.7040708@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 08:17 PM, Ivaylo Dimitrov wrote:
>
>
> On 28.01.2014 10:48, Tomi Valkeinen wrote:
>
>> I made a somewhat hacky quickfix for beagle. Applying that and the
>> clk-divider from the link above makes things work for me. However, as I
>> said, the issue with n900 might be different, but it'd be interesting to
>> hear if it has any effect.
>>
>>   Tomi
>>
>
> Applying those 2 patches doesn't help, still get exactly the same warning.
>
> Find attached my clk_summary (with my hacky patch applied, otherwise I
> cannot boot the device)
>
> Ivo

It looks like the omap36xx version of the omap96m_alwon_fck is modelled 
improperly in the dts files. I don't have access to omap36xx hardware 
myself, but give a try for the following patch:


From: Tero Kristo <t-kristo@ti.com>
Date: Wed, 29 Jan 2014 11:03:46 +0200
Subject: [PATCH] ARM: dts: omap36xx: fix omap96m_alwon_fck

OMAP36xx has different hardware implementation for the omap96m_alwon_fck
compared to other OMAP3 variants. Reflect this properly in the dts file.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
  arch/arm/boot/dts/omap36xx-clocks.dtsi |    9 +++++++++
  1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/omap36xx-clocks.dtsi 
b/arch/arm/boot/dts/omap36xx-clocks.dtsi
index 2fcf253..24ddf3f 100644
--- a/arch/arm/boot/dts/omap36xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap36xx-clocks.dtsi
@@ -88,3 +88,12 @@
  			 <&mcbsp4_ick>, <&uart4_fck>;
  	};
  };
+
+&omap_96m_alwon_fck {
+	compatible = "ti,divider-clock";
+	clocks = <&omap_192m_alwon_fck>;
+	ti,bit-shift = <12>;
+	ti,max-div = <2>;
+	reg = <0x0a40>;
+	ti,index-starts-at-one;
+};
-- 
1.7.9.5
