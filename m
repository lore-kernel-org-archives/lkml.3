Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3LGBf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:35:28 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53442 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3LGBfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAGVrzcb_r9_p4urz4XkE2A-G85KAHJa4PJ=Gt9a4RPYQNJ6j0g@mail.gmail.com>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-8-git-send-email-wens@csie.org> <CAGVrzcb_r9_p4urz4XkE2A-G85KAHJa4PJ=Gt9a4RPYQNJ6j0g@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 7 Dec 2013 09:35:04 +0800
X-Google-Sender-Auth: AKphChxeDaHgwlrf3t4hdJOxuxU
Message-ID: <CAGb2v64yFhkTXvdq=1VpemULhXew-5fvmSoTBzEb6iFDiSqy1Q@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: dts: sun7i: cubietruck: Enable the GMAC
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 5:09 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 2013/12/6 Chen-Yu Tsai <wens@csie.org>:
>> The CubieTruck uses the GMAC with an RGMII phy.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>> index 8a1009d..af212a2 100644
>> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>> @@ -33,6 +33,14 @@
>>                         pinctrl-0 = <&uart0_pins_a>;
>>                         status = "okay";
>>                 };
>> +
>> +               gmac: ethernet@01c50000 {
>> +                       pinctrl-names = "default";
>> +                       pinctrl-0 = <&gmac_pins_rgmii>;
>> +                       snps,phy-addr = <1>;
>
> What is this snps,phy-addr property? Why is not a standard device tree
> node for an Ethernet PHY node used?

This property is implemented by stmmac and documented in the DT
bindings. stmmac has not been updated to use Ethernet PHY nodes.

Removing this property will not affect the function of the driver.
The driver probes its MDIO bus and selects the lowest available
address if not specified.

>> +                       phy-mode = "rgmii";
>
> Especially since you use the relatively standard "phy-mode" property here?

Used as specified in stmmac DT bindings.


Wens
