Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaGGTz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:55:26 -0400
Received: from plane.gmane.org ([80.91.229.3]:59662 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGGTzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:55:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
Date: Mon, 07 Jul 2014 21:55:06 +0200
Message-ID: <lpetuq$bt8$1@ger.gmane.org>
References: <lpeofi$1fl$1@ger.gmane.org> <20140707191430.GA23004@roeck-us.net> <lpeseg$lip$1@ger.gmane.org> <20140707194223.GA29819@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5dd560e1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
In-Reply-To: <20140707194223.GA29819@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 09:42 PM, Guenter Roeck wrote:
>> I tracked the problem down to the following patch:
>>
>>
>> diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts
>> b/arch/arm/boot/dts/imx23-olinuxino.dts
>> index d107c4a..993da2e 100644
>> --- a/arch/arm/boot/dts/imx23-olinuxino.dts
>> +++ b/arch/arm/boot/dts/imx23-olinuxino.dts
>> @@ -64,7 +64,14 @@
>>   				compatible = "fsl,imx23-spi";
>>   				pinctrl-names = "default";
>>   				pinctrl-0 = <&spi2_pins_a>;
>> +				clock-frequency = <1000000>;
>
> If I understand the code correctly, that means you reduce the access speed
> for SPI flashes from 160 MHz down to 1 MHz.
>
> If so, and if your system loads anything from a SPI flash, I would not be too
> surprised that your system is now a bit on the slow side.

The iMX233 has two separate SPI connections. The first one is used to 
connect to the SD card where the system boots from and the second one is 
the one I plan to use. The idea was to only set clock frequency for the 
SPI bus, I want to use to connect to external devices. The "SD SPI" has 
to run with "full speed". So where is the mistake...

Thanks in advance.

Greetings,

Manuel

