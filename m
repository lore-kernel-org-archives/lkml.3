Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaF0HxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:53:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38054 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaF0HxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:53:11 -0400
Message-ID: <53AD22D8.2090301@atmel.com>
Date: Fri, 27 Jun 2014 09:52:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Shen, Voice" <Voice.Shen@atmel.com>
Subject: Re: [PATCH v2 1/2] ARM: at91/dt: describe rgmii ethernet phy connected
 to sama5d3xek boards
References: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com> <1403777615-25685-2-git-send-email-boris.brezillon@free-electrons.com> <CAGVrzcbYAEMsU1SFSH761H0isQ4z1M++KK_GLf0OAbGS48YUmw@mail.gmail.com> <53AC7BFD.2070806@free-electrons.com>
In-Reply-To: <53AC7BFD.2070806@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/2014 22:01, Boris BREZILLON :
> Hi Florian,
> 
> On 26/06/2014 20:15, Florian Fainelli wrote:
>> Hi Boris,
>>
>> 2014-06-26 3:13 GMT-07:00 Boris BREZILLON <boris.brezillon@free-electrons.com>:
>>> Add ethernet-phy node and specify phy interrupt (connected to pin PB25).
>>>
>>> The PHY address is not specified here because atmel have 2 different
>>> designs
>>> for its CPU modules: one is connecting PHYAD[0-2] pins to pull up resistors
>>> (Embest design) and the other one is connection PHYAD0 to a pull up
>>> resistor and PHYAD[1-2] to pull down resistors (Ronetix design).
>>> As a result, Ronetix design will have its PHY available at address 0x1 and
>>> Embest design at 0x7.
>>> Let the net PHY core automatically detect the PHY address by scanning the
>>> MDIO bus.
>> I though the compatible string was listed as a required property, but
>> it is not. The 'reg' property however is listed as required, although
>> the of_miodbus_register() works just fine without it, although that is
>> a Linux-specific implementation detail.
> 
> Indeed, it's listed in the required property list of the DT binding doc,
> but the code implement auto detection if reg is missing.
> However this line [1] clearly shows that specifying the reg property is
> the preferred way of doing things.
> 
> I could define 2 different sama5d3xcm.dtsi (sama5d3xcm-ronetix.dtsi and
> sama5d3xcm-embest.dtsi) to avoid this dirty hack,
> but then we would have 2 more dtb and the user would have to determine
> which CPU module he owns to choose the appropriate dtb.
> If at91, arm-soc and DT maintainers agree with this approach I can
> definitely propose something.

Yes Boris, I definitively prefer not to add another .dtsi file for this
series if we can avoid it.

So, I would push for this "reg-less" solution. If it is chosen, you can
add my:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, bye.


>>> Define board specific delays to apply to RGMII signals.
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks for your review.
> 
> Best Regards,
> 
> Boris
> 
> [1] http://lxr.free-electrons.com/source/drivers/of/of_mdio.c#L187
> 


-- 
Nicolas Ferre
