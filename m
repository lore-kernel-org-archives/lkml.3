Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab3LICz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:55:26 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:64208 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097Ab3LICzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:55:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAGVrzcaxV88dU3vEVGUiEQihUHLxq+QvQVQ6VvmOFVRsqbbX7w@mail.gmail.com>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-8-git-send-email-wens@csie.org> <CAGVrzcb_r9_p4urz4XkE2A-G85KAHJa4PJ=Gt9a4RPYQNJ6j0g@mail.gmail.com>
 <CAGb2v64yFhkTXvdq=1VpemULhXew-5fvmSoTBzEb6iFDiSqy1Q@mail.gmail.com> <CAGVrzcaxV88dU3vEVGUiEQihUHLxq+QvQVQ6VvmOFVRsqbbX7w@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 9 Dec 2013 10:55:02 +0800
X-Google-Sender-Auth: Mg3wl0uNJFHSMq0DILG3Adb2zmU
Message-ID: <CAGb2v675Cg6S512zfM1z4b+wqE_PesDGWdgcmpzWmPzyzXqbeA@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: dts: sun7i: cubietruck: Enable the GMAC
To: Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian, Giuseppe:

On Sat, Dec 7, 2013 at 9:57 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 2013/12/6 Chen-Yu Tsai <wens@csie.org>:
>> On Sat, Dec 7, 2013 at 5:09 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> 2013/12/6 Chen-Yu Tsai <wens@csie.org>:
>>>> The CubieTruck uses the GMAC with an RGMII phy.
>>>>
>>>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>>>> ---
>>>>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> index 8a1009d..af212a2 100644
>>>> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> @@ -33,6 +33,14 @@
>>>>                         pinctrl-0 = <&uart0_pins_a>;
>>>>                         status = "okay";
>>>>                 };
>>>> +
>>>> +               gmac: ethernet@01c50000 {
>>>> +                       pinctrl-names = "default";
>>>> +                       pinctrl-0 = <&gmac_pins_rgmii>;
>>>> +                       snps,phy-addr = <1>;
>>>
>>> What is this snps,phy-addr property? Why is not a standard device tree
>>> node for an Ethernet PHY node used?
>>
>> This property is implemented by stmmac and documented in the DT
>> bindings. stmmac has not been updated to use Ethernet PHY nodes.
>
> This driver property should be removed and deprecated since there is
> an ePAPR standardized Ethernet PHY node. What I am worried here is the
> loss of information, the standard Ethernet DT node allows to specify
> much more information (clause, maximum speed, compatible string
> etc...).

Giuseppe, any thoughts on this?

>> Removing this property will not affect the function of the driver.
>> The driver probes its MDIO bus and selects the lowest available
>> address if not specified.
>
> So if this is just giving the driver a hint on where to  probe for a
> PHY on the MDIO bus, then let's drop it and use the standard DT node
> no?

Sure. I will remove it from the DT.

The stmmac driver does not have a seperate MDIO bus driver, nor
does it support Ethernet PHY node bindings. So I will not add
a phy node at this moment.

>>>> +                       phy-mode = "rgmii";
>>>
>>> Especially since you use the relatively standard "phy-mode" property here?
>>
>> Used as specified in stmmac DT bindings.
>
> That one is kind of okay because of_get_phy_mode() knows about it,
> even though ePAPR states this should be "phy-connection-type", so I am
> okay with keeping that one because current practice and helpers are
> here.

It seems all ARM DTs currently use "phy-mode".

> --
> Florian

Chen-Yu
