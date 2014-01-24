Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaAXVjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:39:32 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47330 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:39:28 -0500
Message-ID: <52E2DD8D.1050609@gmail.com>
Date: Fri, 24 Jan 2014 13:39:25 -0800
From: Marc C <marc.ceeeee@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 8/8] ARM: brcmstb: dts: add a reference DTS for Broadcom
 7445
References: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com> <1390361452-3124-9-git-send-email-marc.ceeeee@gmail.com> <20140124110910.GC814@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140124110910.GC814@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> As I commented on v3 [1], these are contiguous and can be described with
> a single entry:
>
> memory {
> 	device_type = "memory";
> 	reg = <0x0 0x00000000 0x0 0xc0000000>;
> };
>
> Is there any reason to have three entries?

Oopsies, sorry for missing that.

On BCM7445 and derivatives, there are 3 memory controllers. For each memory controller,
the first 1GB of physical DRAM is mapped to:

* 0x00_0000_0000
* 0x00_4000_0000
* 0x00_8000_0000

The memory controllers aren't interleaved. So, it's possible for the SoC to have a
discontiguous memory-mapping, where a designer chooses not to populate physical DRAM in
the middle.

The 'reg' property was broken-up to have each chunk of memory given a dedicated memblock.

All that said, if you like, I can rework the patch as you've suggested.

Thanks,
Marc C


On 01/24/2014 03:09 AM, Mark Rutland wrote:
> On Wed, Jan 22, 2014 at 03:30:52AM +0000, Marc Carino wrote:
>> Add a sample DTS which will allow bootup of a board populated
>> with the BCM7445 chip.
>>
>> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  arch/arm/boot/dts/bcm7445.dts |  111 +++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 111 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/bcm7445.dts
>>
>> diff --git a/arch/arm/boot/dts/bcm7445.dts b/arch/arm/boot/dts/bcm7445.dts
>> new file mode 100644
>> index 0000000..ffa3305
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/bcm7445.dts
>> @@ -0,0 +1,111 @@
>> +/dts-v1/;
>> +/include/ "skeleton.dtsi"
>> +
>> +/ {
>> +	#address-cells = <2>;
>> +	#size-cells = <2>;
>> +	model = "Broadcom STB (bcm7445)";
>> +	compatible = "brcm,bcm7445", "brcm,brcmstb";
>> +	interrupt-parent = <&gic>;
>> +
>> +	chosen {};
>> +
>> +	memory {
>> +		device_type = "memory";
>> +		reg = <0x00 0x00000000 0x00 0x40000000>,
>> +		      <0x00 0x40000000 0x00 0x40000000>,
>> +		      <0x00 0x80000000 0x00 0x40000000>;
>> +	};
> 
> As I commented on v3 [1], these are contiguous and can be described with
> a single entry:
> 
> memory {
> 	device_type = "memory";
> 	reg = <0x0 0x00000000 0x0 0xc0000000>;
> };
> 
> Is there any reason to have three entries?
> 
> Thanks,
> Mark.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/225899.html
> 

