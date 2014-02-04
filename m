Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaBDDGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:06:47 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:58844 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBDDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140203193431.GD25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-3-git-send-email-wens@csie.org> <20140203193431.GD25625@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 4 Feb 2014 11:06:24 +0800
X-Google-Sender-Auth: Nu5laQSPdgYNFq5bMp3w0Ha8lNs
Message-ID: <CAGb2v660qoKDC6SKjoD29b-r5y9OwkeKoWZ9PWBF5tC5PgeEYQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] ARM: dts: sun7i: Add GMAC clock node to sun7i DTSI
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 3:34 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Mon, Feb 03, 2014 at 11:32:20AM +0800, Chen-Yu Tsai wrote:
>> The GMAC uses 1 of 2 sources for its transmit clock, depending on the
>> PHY interface mode. Add both sources as dummy clocks, and as parents
>> to the GMAC clock node.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun7i-a20.dtsi | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
>> index 1595e9a..fc7f470 100644
>> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
>> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
>> @@ -314,6 +314,34 @@
>>               };
>>
>>               /*
>> +              * The following two are dummy clocks, placeholders used
>> +              * on gmac_tx clock. The actual frequency and availability
>> +              * depends on the external PHY, operation mode and link
>> +              * speed.
>> +              */
>
> If it depends on the external PHY, I guess that means it also depends
> on the board, right? Or is the GMAC supposed to always have that clock
> running at 25MHz, no matter what PHY is connected to it?

What I meant in the comment is that we cannot control the actual clock
rate of the TX clock. We can only select the source, and this is what
gmac_tx clock does. It is just a clock mux. The 125MHz and 25MHz clock
rates are used by the clk_set_rate in the stmmac glue layer to do
auto-reparenting.

The board dependent factor is what _type_ of PHY it is using, i.e.
MII, GMII, or RGMII. If it's MII, the PHY should provide the clock.
If it's RGMII, the internal clock would be used. GMII is a mix of
both. The actual clock rate depends on the link speed.

I should rephrase the comment along the lines of:

The following two are dummy clocks, placeholders used in the gmac_tx
clock. The gmac driver will choose one parent depending on the PHY
interface mode, using clk_set_rate auto-reparenting.
The actual TX clock rate is not controlled by the gmac_tx clock.


Cheers
ChenYu
