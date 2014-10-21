Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaJUMIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:08:45 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35302 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaJUMIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:08:43 -0400
Message-ID: <54464CC3.2050408@cogentembedded.com>
Date: Tue, 21 Oct 2014 16:08:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] ARM: berlin: Add phy-connection-type to BG2Q PHY
References: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com> <1413881627-21639-9-git-send-email-sebastian.hesselbarth@gmail.com> <54464401.20900@cogentembedded.com> <54464796.90804@gmail.com>
In-Reply-To: <54464796.90804@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 3:46 PM, Sebastian Hesselbarth wrote:

>>> From: Antoine Ténart <antoine.tenart@free-electrons.com>

>>> Internal FastEthernet PHY on BG2Q is connected via MII, add a
>>> corresponding phy-connection-type property.

>>> Tested-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ---
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: Eric Miao <eric.y.miao@gmail.com>
>>> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: netdev@vger.kernel.org
>>> Cc: devicetree@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   arch/arm/boot/dts/berlin2q.dtsi | 1 +
>>>   1 file changed, 1 insertion(+)

>>> diff --git a/arch/arm/boot/dts/berlin2q.dtsi
>>> b/arch/arm/boot/dts/berlin2q.dtsi
>>> index 891d56b03922..6dbc520bddc1 100644
>>> --- a/arch/arm/boot/dts/berlin2q.dtsi
>>> +++ b/arch/arm/boot/dts/berlin2q.dtsi
>>> @@ -127,6 +127,7 @@
>>>               status = "disabled";
>>>
>>>               ethphy0: ethernet-phy@0 {
>>> +                phy-connection-type = "mii";

>>     You're adding this prop to the PHY node? That's very weird...
>> normally, it's a property of a MDIO bus node.

> Sergei,

> How can this be a property of the MDIO bus node? Just think of an MDIO
> bus with two PHYs where one is connected via GMII and the other via
> RGMII? How should this work?

    Hm, this is an unexpected case...

> But you are right that the property should not be part of the PHY node
> but the controller node instead. I'll rework and send an update, thanks
> for the hint.

    Oh, not at all. :-)

> Sebastian

WBR, Sergei

