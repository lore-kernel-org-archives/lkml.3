Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaAIErD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:47:03 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49470 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAIErB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:47:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140108094104.GC6701@e106331-lin.cambridge.arm.com>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
	<1389162390-4582-3-git-send-email-sachin.kamat@linaro.org>
	<20140108094104.GC6701@e106331-lin.cambridge.arm.com>
Date: Thu, 9 Jan 2014 10:17:00 +0530
Message-ID: <CAK9yfHxvjacrqodCw+_WuGN1egg2==wwk7BdAL4JD8iJ1Sa7qA@mail.gmail.com>
Subject: Re: [PATCH 3/3] Documentation: mfd: Add binding document for S2MPA01
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 January 2014 15:11, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Jan 08, 2014 at 06:26:30AM +0000, Sachin Kamat wrote:
>> Added initial binding documentation for S2MPA01 MFD.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/mfd/s2mpa01.txt |   91 +++++++++++++++++++++
>>  1 file changed, 91 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/s2mpa01.txt b/Documentation/devicetree/bindings/mfd/s2mpa01.txt
>> new file mode 100644
>> index 000000000000..ae750a28821b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/s2mpa01.txt
>> @@ -0,0 +1,91 @@
>> +
>> +* Samsung S2MPA01 Voltage and Current Regulator
>> +
>> +The Samsung S2MPA01 is a multi-function device which includes high
>> +efficiency buck converters including Dual-Phase buck converter, various LDOs,
>> +and an RTC. It is interfaced to the host controller using an I2C interface.
>> +Each sub-block is addressed by the host system using different I2C slave
>> +addresses.
>> +
>> +Required properties:
>> +- compatible: Should be "samsung,s2mpa01-pmic".
>> +- reg: Specifies the I2C slave address of the PMIC block. It should be 0x66.
>> +
>> +Optional properties:
>> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
>> +  the interrupts from s2mpa01 are delivered to.
>> +- interrupts: Interrupt specifiers for interrupt sources.
>
> That sounds a bit odd. How many interrupts might there be? What do they
> signal?

Actually there is only one interrupt line for sending interrupts to
the AP for conditons like sudden
voltage drop, etc. I will make the above sentence singular.

>> +
>> +Optional nodes:
>> +- regulators: The regulators of s2mpa01 that have to be instantiated should be
>> +included in a sub-node named 'regulators'. Regulator nodes included in this
>> +sub-node should be of the format as listed below.
>> +
>> +     regulator_name {
>> +             [standard regulator constraints....];
>> +     };
>> +
>
> Why not just say that the regulators node contains regulators in the
> usual format, with reference to the regulator binding?

OK. I will update this (as also suggested by your later comment).

>
>> + regulator-ramp-delay for BUCKs = [6250/12500(default)/25000/50000] uV/us
>> +
>> + BUCK[1/2/3/4] supports disabling ramp delay on hardware, so explictly
>> + regulator-ramp-delay = <0> can be used for them to disable ramp delay.
>> + In the absence of the regulator-ramp-delay property, the default ramp
>> + delay will be used.
>> +
>> +NOTE: Some BUCKs share the ramp rate setting i.e. same ramp value will be set
>> +for a particular group of BUCKs. So provide same regulator-ramp-delay<value>.
>> +Grouping of BUCKs sharing ramp rate setting is as follow : BUCK[1, 6],
>> +BUCK[2, 4], and BUCK[8, 9, 10]
>
> It would probably be better to have a heading like "Properties for BUCK
> regulator nodes" for all of the above.

OK.

>
>> +
>> +The regulator constraints inside the regulator nodes use the standard regulator
>> +bindings which are documented elsewhere.
>
> As mentioned above, state this at the beginning and point to the
> regulator bindings.

OK.

>> +
>> +The following are the names of the regulators that the s2mpa01 PMIC block
>> +supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
>> +as per the datasheet of s2mpa01.
>
> So these are what the nodes should be called? (rather than values for
> regulator-name).

Yes. That is the convention followed here.

>
> Otherwise this looks ok to me.
>

Thanks for reviewing.

-- 
With warm regards,
Sachin
