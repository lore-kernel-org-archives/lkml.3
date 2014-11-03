Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaKCQs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:48:28 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54674 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbaKCQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:48:25 -0500
Message-ID: <5457B1CE.4060108@free-electrons.com>
Date: Mon, 03 Nov 2014 17:48:14 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Add support for USB cluster(PHY muxer) on the
 Armada 375
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com> <20141101224647.GD3698@titan.lakedaemon.net>
In-Reply-To: <20141101224647.GD3698@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 01/11/2014 23:46, Jason Cooper wrote:
> Gregory,
> 
> On Fri, Oct 24, 2014 at 05:24:08PM +0200, Gregory CLEMENT wrote:
>> Hello,
>>
>> this is the second version of a series I initially submitted in May:
>> https://lkml.org/lkml/2014/5/16/743
>>
>> This series adds support for the USB cluster which is on the Armada
>> 375 SoC. We can mainly see this device as a PHY muxer.
>>
>> I more or less forgotten this series until the talk of Kishon Vijay
>> Abraham I about the phy framework.
>>
>> Since this time, things have changed in the USB framework and I no
>> longer have to add the generic phy support in the xhci driver since it
>> was done at the usb core level.
>>
>> While I ran coccicheck on my code I also found some possible
>> improvement in the phy driver: it was done in the 1st patch.
>>
>> The second patch was a patch initially submitted by Andrew. This patch
>> added the mvebu-phy.txt but fell through a crack when adding the
>> driver. I join this patch on my series in order to be able to add the
>> new binding for the USB cluster of the Armada 375.
>>
>> This was done in the third patch.
>>
>> The forth patch was the addition of the phys driver itself.
>>
>> The fifth and sixth patches are updating the device tree files related
>> to the Armada 375 using the new biding.
>>
>> Thanks,
>>
>> Gregory
>>
>> Changelog:
>>
>> v1 -> v2:
>>
>> - Add a patch fixing the use of PTR_ERR_OR_ZERO.
>>
>> - Add the patch adding the DT binding documentation for Marvell MVEBU
>> SATA phy from Andrew Lunn
>>
>> - Move the DT binding documentation of the Armada 375 USB cluster into
>>   the phy-mvebu.txt file.
>>
>> - Made the armada375_usb_phy_xlate more robust" if there is a phy_put
>>   and then a phy_get".
>>
>> Andrew Lunn (1):
>>   Phy: DT binding documentation for Marvell MVEBU SATA phy.
>>
>> Gregory CLEMENT (5):
>>   phy: Use PTR_ERR_OR_ZERO to fix warning raised by coccinelle
>>   Phy: DT binding documentation for the Armada 375 USB cluster binding
>>   phy: add support for USB cluster on the Armada 375 SoC
>>   ARM: mvebu: add Device Tree description of USB cluster controller on
>>     Armada 375
>>   ARM: mvebu: add PHY support to the dts for the USB controllers on
>>     Armada 375
> 
> I assume Kishon is taking the phy portion of this series and we'll
> handle the dts portion? 

Yes I expect that we merge the patch 5 and 6, and patch 1-4 should
be pulled by Kishon.


> Before doing so, I'd like to see an Ack from
> the DT maintainers and Kishon...

I also would like have a feedback from them :)


Thanks,

Gregory

> 
> thx,
> 
> Jason.
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
