Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaAJOJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:09:07 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46726 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAJOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:09:03 -0500
Message-ID: <52CFFEFB.7060202@cogentembedded.com>
Date: Fri, 10 Jan 2014 18:08:59 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "anton@enomsg.org" <anton@enomsg.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mk7.kang@samsung.com" <mk7.kang@samsung.com>
Subject: Re: [PATCH 2/3] dt: Document ModelGauge gauge bindings
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com> <1389286145-15375-3-git-send-email-vladimir.barinov@cogentembedded.com> <20140110105621.GC6798@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140110105621.GC6798@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thank you for the review.

On 01/10/2014 02:56 PM, Mark Rutland wrote:
> On Thu, Jan 09, 2014 at 04:49:04PM +0000, Vladimir Barinov wrote:
>> These bindings can be used to register Maxim ModelGauge ICs fuel gauge
>> (MAX17040/41/43/44/48/49/58/59)
>>
>> Signed-off-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>>
>> ---
>>   Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt |   82 ++++++++++
>>   1 file changed, 82 insertions(+)
>>
>> Index: battery-2.6/Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt
>> ===================================================================
>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>> +++ battery-2.6/Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt	2014-01-09 15:09:38.035138887 +0400
>> @@ -0,0 +1,82 @@
>> +modelgauge_battery
>> +~~~~~~~~~~~~~~~~~~
>> +
>> +Required properties:
>> + - compatible		: should contain one of the following:
>> +			  - "maxim,max17040" for MAX17040
>> +			  - "maxim,max17041" for MAX17041
>> +			  - "maxim,max17043" for MAX17043
>> +			  - "maxim,max17044" for MAX17044
>> +			  - "maxim,max17048" for MAX17048
>> +			  - "maxim,max17049" for MAX17049
>> +			  - "maxim,max17058" for MAX17058
>> +			  - "maxim,max17059" for MAX17059
>> +
>> +Optional properties:
>> + - maxim,empty_alert_threshold	: Capacity threshold where an interrupt is
>> +				  generated on the ALRT pin;
> s/_/-/ in proeprty names please.
I'll make this parameter configurable via sysfs in the driver. Is it ok?
>
> Why is this property in the dt at all?
>
> Surely the driver can choose the value it wants.
>
> The driver can choose a sensible value, surely?
Ok. I'll exclude the platform data from DT and put into sysfs.
>> +
>> + - soc_change_alert		: /* alert for 1% soc change */
> Likewise, surely the driver should decide if it wants this?
Ditto.
>
>> + - hibernate_threshold		: Hibernate threshold (crate), where IC
>> +				  enters hibernate mode
>> + - active_threshold		: Active threshold (mV), where IC exits
>> +				  hibernate mode
>> + - undervoltage			: Voltage (mV), when IC alerts while battery
>> +				  voltage less then undervoltage
>> + - overvoltage			: Voltage (mV), when IC alerts while battery
>> +				  voltage greater then overvoltage
>> + - maxim,resetvoltage		: Voltage threshold (mV) below which the IC
>> +				  resets itself. Used to detect battery removal
>> +				  and reinsertion;
> Could you elaborate on what these are for. How variable are these
> between batteries?
Ditto.
>
>> + - maxim,empty_adjustment	: Capacity charge empty design value;
>> + - maxim,full_adjustment	: Capacity charge full design value;
> These names are a bit odd.
May be you are right. But I've got this from MAXIM documentation.
>
> How about maxim,charge-empty and maxim,charge-full (perhaps
> maxim,charge-empty-design).
I'll leave the original names to avoid misunderstanding between names in 
MAXIM docs
and driver's naming.
>
>> + - maxim,rcomp0			: ModelGauge RCOMP parameter, used for
>> +				  temperature compensation;
>> + - maxim,temp_co_up		: ModelGauge TempCoUp parameter, used for
>> +				  temperature compensation;
>> + - maxim,temp_co_down		: ModelGauge TempCoDown parameter, used for
>> +				  temperature compensation;
>> + - maxim,ocvtest		: ModelGauge OCVTest parameter, used for
>> +				  verification of Custom Model calibration data
>> +				  loaded into IC RAM;
>> + - maxim,soc_check_a		: ModelGauge SOCCheckA parameter, used for
>> +				  verification of Custom Model calibration data
>> +				  loaded into IC RAM;
>> + - maxim,soc_check_b		: ModelGauge SOCCheckB parameter, used for
>> +				  verification of Custom Model calibration data
>> +				  loaded into IC RAM;
>> + - maxim,bits			: ModelGauge Bits parameter, used as
>> +				  scaling parameter in Custom Model algorithm;
>> + - maxim,model_data		: ModelGauge ModelData data,
>> +				  Custom Model calibration data.
> I have no idea what these properties mean, so I can't comment on them as
> they are other than to say this looks a bit low-level. Are there any
> docs?
These are the calibration parameters for specific battery to be used in 
ModelGauge algorithm inside MAXIM ICs.
They are provided by MAXIM for unique battery once requested. So vendor 
needs to send the battery to MAXIM in order
to calibrate/adopt it for MAXIM's firmware algorithm that makes capacity 
calculation more accurate.
>
>> +
>> +Example:
>> +
>> +modelgauge@36 {
>> +	compatible = "maxim,max17058";
>> +	reg =<0x36>;
>> +	interrupt-parent =<&msmgpio>;
>> +	interrupts =<107 0x2>;
> This portion of the example looks fine.
>
>> +
>> +	maxim,empty_alert_threshold = /bits/ 8<15>;
>> +	maxim,resetvoltage = /bits/ 16<0>;
>> +	maxim,empty_adjustment = /bits/ 8<0>;
>> +	maxim,full_adjustment = /bits/ 8<100>;
>> +	maxim,rcomp0 = /bits/ 8<175>;
> You did not describe that any of these were 8-bit values in the binding.
As mentioned above, I'll move this portion out from DT, except rcomp0, 
since this is battery unique value.
>
>> +	maxim,temp_co_up =<(-1100)>;
>> +	maxim,temp_co_down =<(-4000)>;
> These weren't described as signed.
Will describe, thx.
>
>> +	maxim,ocvtest = /bits/ 16<56144>;
>> +	maxim,soc_check_a = /bits/ 8<241>;
>> +	maxim,soc_check_b = /bits/ 8<243>;
>> +	maxim,bits = /bits/ 8<19>;
> These weren't described as 8-bit either.
Will describe.
>
>> +
>> +	maxim,model_data = /bits/ 8<
>> +		0x9B 0x70 0xAB 0x30 0xB5 0xA0 0xB9 0xD0
>> +		0xBB 0xA0 0xBC 0x00 0xBC 0xB0 0xBD 0x00
>> +		0xBD 0x60 0xBE 0x40 0xBF 0x40 0xC1 0xF0
>> +		0xC5 0x60 0xC8 0xA0 0xCD 0x00 0xD1 0x50
>> +		0x00 0xE0 0x01 0x80 0x18 0x60 0x1C 0x20
>> +		0x54 0x00 0x6A 0xC0 0x79 0x20 0x65 0xC0
>> +		0x0B 0xE0 0x2A 0xC0 0x1D 0x00 0x17 0xE0
>> +		0x15 0xE0 0x11 0xE0 0x11 0x00 0x11 0x00>;
>> +};
> This looks scary.
This is a calibration data provided by MAXIM vendor for specific battery.
These are unique data for every battery and they are intended to be loaded
into IC's RAM for further use by MAXIM MadelGauge algorithm.

I do not know the internals for MAXIM's firmware, but I assume that 
these data are
reference offsets for Capacity on OCV dependency.

The vendor can calibrate the battery by itself in s/w (Capacity(OCV) 
dependency). The MAXIM
allows to do it in h/w.

Regards,
Vladimir
