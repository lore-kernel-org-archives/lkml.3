Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3JBQvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:51:37 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:58583 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493Ab3JBQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:51:34 -0400
X-Greylist: delayed 15370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 12:51:34 EDT
Message-ID: <524C4CF1.7060407@overkiz.com>
Date: Wed, 02 Oct 2013 18:42:25 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [v2,2/4] watchdog: at91sam9_wdt: update device tree doc
References: <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com> <20131002155118.GA16703@roeck-us.net>
In-Reply-To: <20131002155118.GA16703@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5544494092054001679
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 17:51, Guenter Roeck wrote:
> On Fri, Jun 21, 2013 at 03:23:34PM -0000, Boris BREZILLON wrote:
>> Add new at91sam9 watchdog properties to the documentation.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Acked-by: Grant Likely<grant.likely@linaro.org>
>>
>> ---
>> .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 ++++++++++++++++++--
>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> index fcdd48f..e043106 100644
>> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> @@ -9,11 +9,37 @@ Required properties:
>>   
>>   Optional properties:
>>   - timeout-sec: contains the watchdog timeout in seconds.
>> +- interrupts : Should contain WDT interrupt.
>> +- atmel,max-heartbeat-sec : Should contain the maximum heartbeat value in
>> +	seconds. This value should be less than 16. It is used to compute the
>> +	WDV field.
>> +- atmel,min-heartbeat-sec : Should contain the minimum heartbeat value in
>> +	seconds. This value should be less than 4 times the max-heartbeat-sec
>> +	value. It is used to compute the WDD field.
> I am a bit at loss about "less than 4 times the max-heartbeat-sec value".
> Why would a min-timeout larger than the max-timeout make sense under any
> condition ? Do you mean to say that max-heartbeat should be at least four
> times the value of min-heartbeat (or that min-heartbeat should be less or
> equal to one-forth of max-heartbeat) ?
That's exactely what I meant (should be less or equal to one-forth of 
max-heartbeat).
I'll fix it.

> Guenter
>
>> +- atmel,watchdog-type : Should be "hardware" or "software". Hardware watchdog
>> +	use the at91 watchdog reset. Software watchdog use the watchdog
>> +	interrupt to trigger a software reset.
>> +- atmel,reset-type : Should be "proc" or "all".
>> +	"all" : assert peripherals and processor reset signals
>> +	"proc" : assert the processor reset signal
>> +	This is valid only when using "hardware" watchdog.
>> +- atmel,disable : Should be present if you want to disable the watchdog.
>> +- atmel,idle-halt : Should be present if you want to stop the watchdog when
>> +	entering idle state.
>> +- atmel,dbg-halt : Should be present if you want to stop the watchdog when
>> +	entering debug state.
>>   
>>   Example:
>> -
>>   	watchdog@fffffd40 {
>>   		compatible = "atmel,at91sam9260-wdt";
>>   		reg = <0xfffffd40 0x10>;
>> -		timeout-sec = <10>;
>> +		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
>> +		timeout-sec = <15>;
>> +		atmel,watchdog-type = "hardware";
>> +		atmel,reset-type = "all";
>> +		atmel,dbg-halt;
>> +		atmel,idle-halt;
>> +		atmel,max-heartbeat-sec = <16>;
>> +		atmel,min-heartbeat-sec = <0>;
>> +		status = "okay";
>>   	};

