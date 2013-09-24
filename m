Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3IXPkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:40:06 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:44231 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab3IXPkA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:40:00 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>
Date: Tue, 24 Sep 2013 17:38:34 +0200
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Topic: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Index: Ac65PCFF6IZk3JQnTIS/OHUEP1Jbzw==
Message-ID: <5241B1FA.6020500@st.com>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-2-git-send-email-maxime.coquelin@st.com>
 <5240AD6E.4090905@wwwdotorg.org>
In-Reply-To: <5240AD6E.4090905@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/23/2013 11:06 PM, Stephen Warren wrote:
> On 09/18/2013 04:01 AM, Maxime COQUELIN wrote:
>> This patch adds support to SSC (Synchronous Serial Controller)
>> I2C driver. This IP also supports SPI protocol, but this is not
>> the aim of this driver.
>>
>> This IP is embedded in all ST SoCs for Set-top box platorms, and
>> supports I2C Standard and Fast modes.
>> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt
>> +I2C for ST platforms
> If the HW block supports both I2C and SPI, the DT binding ought to
> support that too. It's be best to create a single DT binding that
> represents the IP block, and include a property that indicates whether
> the device should operate in I2C or SPI mode.
>
> I suppose you could reasonably define different compatible values for
> those two cases. However, the binding should be titled something more
> like "ST SSC binding, for I2C mode operation" and "ST SSC binding, for
> SPI mode operation", rather than "I2C for ST platforms", since the HW
> includes an SSC block, not an I2C block.
You are right Stephen.
I will rename the title and change the compatible value as per your 
recommendation.

>> +Required properties :
>> +- compatible : Must be "st,comms-i2c"
>> +- reg : Offset and length of the register set for the device
>> +- interrupts : the interrupt number
> It's an interrupt specifier, not an interrupt number. The format is
> defined by the interrupt controller, not this binding.
Ok. I will change to "the interrupt specifier".
>> +- clocks : phandle to the I2C clock source
> What about clock-names?
It will be added in next revision. It will be named "ssc"
>> +Recommended (non-standard) properties :
> Usually you'd just say "Optional properties:", or perhaps "Recommended
> properties:". I don't think adding "(non-standard)" serves any purpose.
Ok. then I will remove all the "non-standard" occurences.
>> +- clock-frequency : Desired I2C bus clock frequency in Hz. Otherwise
>> +  the default 100 kHz frequency will be used. As only Normal and Fast modes
>> +  are supported, possible values are 100000 and 400000.
>> +
>> +Optional (non-standard) properties:
> Same here.
>
>> +- st,glitches : Enable timing glitch suppression support.
> That property name doesn't really convey the "enables" that appears in
> the property description to me...
>
>> +- st,glitch-clk : SCL line timinig glitch suppression value in ns.
>> +- st,glitch-dat : SDA line timinig glitch suppression value in ns.
> s/timinig/timing/
>
>> +- st,hw-glitches : Enable filter glitch suppression support.
>> +- st,hw-glitch-clk : SCL line filter glitch suppression value in us.
>> +- st,hw-glitch-dat : SDA line filter glitch suppression value in us.
> Those sound more like runtime configuration rather than HW description.
> Can you rephrase the descriptions (and property names) more along the
> lines of HW properties? Perhaps e.g.:
>
> st,needs-glitch-suppression: The board design needs timing glitch
> suppression enabled to operate reliably.
>
> st,min-scl-pulse-width: The minimum valid SCL pulse width that is
> allowed through the deglitch circuit. In units of ns.
>
> (I just made up those descriptions to give a feel for the flavor of
> description that I expect. They likely need some adjustment to reflect
> whatever they're actually intended to represent in HW).
>
> What is the difference between "glitch" and "hw-glitch"?
"hw-glitch" is used to configure the anti-glitch filters.
It suppresses the pulses with a width lower than x microseconds.

"glitch" is is used to tune the I2C timing requirements, and has a 
nanosecond granularity.
These values are added to default timing values.
I'm not 100% sure, but it looks like the "samsung,i2c-sda-delay" in the 
i2c-s3c2410 driver.

I agree the names and descriptions are not clear, and even misleading.
I will come with a clearer implementation, as soon as I get 
clarification from HW team.

Thanks for the review,
Maxime

