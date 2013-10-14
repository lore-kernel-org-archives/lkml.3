Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3JNXSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:18:24 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43137 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3JNXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:18:23 -0400
Message-ID: <525C7BB7.8000209@gmail.com>
Date: Tue, 15 Oct 2013 01:18:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jisheng Zhang <jszhang@marvell.com>
Subject: Re: [PATCH 7/8] ARM: add Armada 1500 and Sony NSZ-GS7 device tree
 files
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-8-git-send-email-sebastian.hesselbarth@gmail.com> <525C7A91.9060101@gmail.com>
In-Reply-To: <525C7A91.9060101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 01:13 AM, Sebastian Hesselbarth wrote:
> On 10/08/2013 02:24 PM, Sebastian Hesselbarth wrote:
>> This adds very basic device tree files for the Marvell Armada 1500 SoC
>> (88DE3100) and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has
>> nodes for cpus, some clocks, l2 cache controller, local timer, apb
>> timers,
>> uart, and interrupt controllers. The Sony NSZ-GS7 is a GoogleTV consumer
>> device comprising the Armada 1500 SoC above.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
>> Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> Changelog:
>> RCFv2->v1:
>> - switch to (soon to be) correct "marvell,pj4b" cpu compatible
>> - reference fixed-clock for uarts instead of hard-coded clock-frequency
>> - disable timers except two for clksrc and clkevt
>> RFCv1->RFCv2:
>> - add binding documentation (Reported by Jason Cooper)
>> - change l2cc from aurora to tauros3 (Reported by Thomas Petazzoni)
>> - add copyright reference
>> - adapt compatibles to mach-berlin instead of mach-mvebu
>>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   .../devicetree/bindings/arm/marvell,berlin.txt     |   23 ++
>>   arch/arm/boot/dts/Makefile                         |    2 +
>>   arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts      |   29 +++
>>   arch/arm/boot/dts/mv88de3100.dtsi                  |  227
>> ++++++++++++++++++++
>>   4 files changed, 281 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/arm/marvell,berlin.txt
>>   create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
>>   create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi
>>
>> diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> new file mode 100644
>> index 0000000..e389cba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> @@ -0,0 +1,23 @@
>> +Marvell Berlin (88DE3xxx) family SoCs Device Tree Bindings
>> +---------------------------------------------------------------
>> +
>> +Boards with a SoC of the Marvell Berlin (88DE3xxx) family, e.g.
>> Armada 1500
>> +shall have the following properties:
>> +
>> +* Required root node properties:
>> +compatible: must contain "marvell,berlin"
>> +
>> +In addition, the above compatible shall be extended with the specific
>> +SoC and board used. Currently known SoC compatibles are:
>> +    "marvell,88de3100"    for Marvell 88DE3100 (Armada 1500),
>> +    "marvell,88de3010"    for Marvell 88DE3010 (Armada 1000),
>> +    "marvell,88de3005"    for Marvell 88DE3005 (Armada 1500-mini)
>
> Jisheng,

(adding Jisheng to Cc, missed that)

> I am trying to follow your request to get rid of 88DExxxx numbering and
> replace it where possible with berlin type-of names.
>
> For the above, I have:
> "marvell,berlin-bg2" for Marvell Armada 1500 (BG2, 88DE3100)
> "marvell,berlin-bg2cd" for Marvell Armada 1500-mini (BG2CD, 88DE3005)
>
> I cannot pin down Armada 1000 in the BG naming scheme. It would be great
> if you provide info here on how Marvell would like to see the
> compatibles.
>
> Sebastian
>

