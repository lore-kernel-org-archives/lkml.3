Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3H1MYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:24:04 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61583 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3H1MYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:24:02 -0400
Message-ID: <521DEBDC.8090207@gmail.com>
Date: Wed, 28 Aug 2013 14:23:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 5/6] ARM: add Armada 1500 and Sony NSZ-GS7 device
 tree files
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377648874-6714-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130828121403.GL19598@titan.lakedaemon.net>
In-Reply-To: <20130828121403.GL19598@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 14:14, Jason Cooper wrote:
> On Wed, Aug 28, 2013 at 02:14:33AM +0200, Sebastian Hesselbarth wrote:
>> This adds very basic device tree files for the Marvell Armada 1500 SoC
>> (88DE3100) and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has
>> nodes for cpus, some clocks, l2 cache controller, local timer, apb timers,
>> uart, and interrupt controllers. The Sony NSZ-GS7 is a GoogleTV consumer
>> device comprising the Armada 1500 SoC above.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Changelog:
>> v1->v2:
>> - add binding documentation (Reported by Jason Cooper)
>> - change l2cc from aurora to tauros3 (Reported by Thomas Petazzoni)
>> - add copyright reference
>> - adapt compatibles to mach-berlin instead of mach-mvebu
>>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   .../devicetree/bindings/arm/marvell,berlin.txt     |   23 ++
>>   arch/arm/boot/dts/Makefile                         |    2 +
>>   arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts      |   29 +++
>>   arch/arm/boot/dts/mv88de3100.dtsi                  |  222 ++++++++++++++++++++
>>   4 files changed, 276 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
>>   create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
>>   create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi
>>
>> diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> new file mode 100644
>> index 0000000..a4c3056
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> @@ -0,0 +1,23 @@
>> +Marvell Berlin (88DE3xxx) family SoCs Device Tree Bindings
>> +---------------------------------------------------------------
>> +
>> +Boards with a SoC of the Marvell Berlin (88DE3xxx) family, e.g. Armada 1500
>> +shall have the following properties:
>> +
>> +* Required root node properties:
>> +compatible: must contain "marvell,berlin"
>> +
>> +In addition, the above compatible shall be extended with the specific
>> +SoC used, i.e.
>> +    "marvell,88de3100"	for Marvell 88DE3100 (Armada 1500),
>> +    "marvell,88de3010"	for Marvell 88DE3010 (Armada 1000),
>> +    "marvell,88de3005"	for Marvell 88DE3005 (Armada 1500-mini)
>> +
>> +* Example:
>> +
>> +/ {
>> +	model = "Sony NSZ-GS7";
>> +	compatible = "marvell,88de3100", "marvell,berlin";
>
> I would make this:
>
> 	compatible = "sony,nsz-gs7", "marvell,88de3100", "marvell,berlin";

Ok.

>> +
>> +	...
>> +}
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index d45058e..2989b51 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -43,6 +43,8 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d35ek.dtb
>>
>>   dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>>   dtb-$(CONFIG_ARCH_BCM) += bcm11351-brt.dtb
>> +dtb-$(CONFIG_ARCH_BERLIN) += \
>> +	mv88de3100-sony-nsz-gs7.dtb
>>   dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>>   	da850-evm.dtb
>>   dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
>> diff --git a/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts b/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
>> new file mode 100644
>> index 0000000..1081bc1
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
>> @@ -0,0 +1,29 @@
>> +/*
>> + * Device Tree file for Sony NSZ-GS7
>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include "mv88de3100.dtsi"
>> +
>> +/ {
>> +	model = "Sony NSZ-GS7";
>> +	compatible = "sony,nsz-gs7", "marvell,88de3100", "marvell,berlin";
>> +
>> +	chosen {
>> +		bootargs = "console=ttyS0,115200 earlyprintk verbose debug";
>
> I would remove 'verbose debug' before official submission, no point to
> defaulting to log-spammer.

Agree.

Maybe, for the next patches, I'll add some I/O device drivers that
allow you to actually boot into some rootfs. All those fooHCI IP
shouldn't be that hard - hopefully some quirks only.

I also had a look at I2C and SPI, both DW IP with mainline drivers
available. SPI needs a little DT tweaking and I did not carry out any
functional tests, yet.

Thanks for the constant reviews!

Sebastian
