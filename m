Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3LMKWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:22:43 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49292 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386Ab3LMKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:22:41 -0500
Message-ID: <52AADFC4.1070003@st.com>
Date: Fri, 13 Dec 2013 11:21:56 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev <netdev@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 07/10] ARM: dts: sun7i: cubietruck: Enable the GMAC
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-8-git-send-email-wens@csie.org> <CAGVrzcb_r9_p4urz4XkE2A-G85KAHJa4PJ=Gt9a4RPYQNJ6j0g@mail.gmail.com> <CAGb2v64yFhkTXvdq=1VpemULhXew-5fvmSoTBzEb6iFDiSqy1Q@mail.gmail.com> <CAGVrzcaxV88dU3vEVGUiEQihUHLxq+QvQVQ6VvmOFVRsqbbX7w@mail.gmail.com>
In-Reply-To: <CAGVrzcaxV88dU3vEVGUiEQihUHLxq+QvQVQ6VvmOFVRsqbbX7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/2013 2:57 AM, Florian Fainelli wrote:
> 2013/12/6 Chen-Yu Tsai <wens@csie.org>:
>> On Sat, Dec 7, 2013 at 5:09 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> 2013/12/6 Chen-Yu Tsai <wens@csie.org>:
>>>> The CubieTruck uses the GMAC with an RGMII phy.
>>>>
>>>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>>>> ---
>>>>   arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 8 ++++++++
>>>>   1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> index 8a1009d..af212a2 100644
>>>> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>>> @@ -33,6 +33,14 @@
>>>>                          pinctrl-0 = <&uart0_pins_a>;
>>>>                          status = "okay";
>>>>                  };
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


yes Florian you are right and I have already started updating the
driver. I do not sure that I'll be able to send all the patches soon
but for sure I can re-base them.

>>
>> Removing this property will not affect the function of the driver.
>> The driver probes its MDIO bus and selects the lowest available
>> address if not specified.
>
> So if this is just giving the driver a hint on where to  probe for a
> PHY on the MDIO bus, then let's drop it and use the standard DT node
> no?
>
>>
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
>

