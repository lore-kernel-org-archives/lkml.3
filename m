Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaKZFOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:14:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47856 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaKZFOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:14:04 -0500
Message-ID: <54756164.3070206@ti.com>
Date: Wed, 26 Nov 2014 10:43:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 6/7] ARM: mvebu: add PHY support to the dts for the
 USB controllers on Armada 375
References: <1415879269-29711-1-git-send-email-gregory.clement@free-electrons.com> <1415879269-29711-7-git-send-email-gregory.clement@free-electrons.com> <20141122020811.GO22670@titan.lakedaemon.net> <5470556B.6080608@free-electrons.com> <20141126035929.GJ22670@titan.lakedaemon.net>
In-Reply-To: <20141126035929.GJ22670@titan.lakedaemon.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 26 November 2014 09:29 AM, Jason Cooper wrote:
> On Sat, Nov 22, 2014 at 10:20:43AM +0100, Gregory CLEMENT wrote:
>> Hi Jason,
>>
>> On 22/11/2014 03:08, Jason Cooper wrote:
>>> On Thu, Nov 13, 2014 at 12:47:48PM +0100, Gregory CLEMENT wrote:
>>>> Now that the USB cluster node has been added, use it as a PHY provider
>>>> for the USB controller linked to it: the first EHCI and the xHCI.
>>>>
>>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Looks like I'm not cc'ed in v4 of this patch series :-(

-Kishon
>>>> ---
>>>>  arch/arm/boot/dts/armada-375.dtsi | 5 +++++
>>>>  1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
>>>> index 8f45cf5d2a50..f344ec420c95 100644
>>>> --- a/arch/arm/boot/dts/armada-375.dtsi
>>>> +++ b/arch/arm/boot/dts/armada-375.dtsi
>>>> @@ -14,6 +14,7 @@
>>>>  #include "skeleton.dtsi"
>>>>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>>>>  #include <dt-bindings/interrupt-controller/irq.h>
>>>> +#include <dt-bindings/phy/phy.h>
>>>
>>> Odd.  The previous patch in this series simply adds a line to phy.h,
>>> however, I get the following error during 'make dtbs':
>>>
>>> ########
>>>   DTC     arch/arm/boot/dts/armada-375-db.dtb
>>> In file included from arch/arm/boot/dts/armada-375-db.dts:17:0:arch/arm/boot/dts/armada-375.dtsi:17:33:
>>> fatal error: dt-bindings/phy/phy.h: No such file or directory
>>>  #include <dt-bindings/phy/phy.h>
>>>                                  ^
>>> compilation terminated.
>>> scripts/Makefile.lib:282: recipe for target 'arch/arm/boot/dts/armada-37 5-db.dtb' failed
>>> ########
>>>
>>> mvebu/dt is based on v3.18-rc1.  Is there a missing dependency
>>> somewhere?  Perhaps we should let Kishon take the whole series and
>>> handle the (hopefully trivial) merge conflict?
>>
>> Actually Kishon asked me to use the dt-bindings/phy/phy.h file which
>> was introduced by the patch "phy: Add PHY header file for DT x Driver
>> defines". So indeed I had to have a dependency on the phy_dt_header
>> branch (which is based on v3.18-rc4 and have only this single commit).
>> The git tree is located at
>> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
>>
>>
>> Maybe we could add this branch in mvebu as a dependency as it is done
>> on arm-soc. I suggest this because I would prefer that we continue to
>> be the only ones to merge the device tree files in order to reduce the
>> merge conflict.
> 
> Ok, I've applied patches 5 and 6 to mvebu/dt-usb_phy with a dependency
> on tags/phy-dt-header.
> 
> Patches 1-4:
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> thx,
> 
> Jason.
> 
