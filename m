Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaIIS0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:26:54 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:43920 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIIS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:26:52 -0400
Message-ID: <540F4B88.5080108@lategoodbye.de>
Date: Tue, 09 Sep 2014 20:48:40 +0200
From: Stefan Wahren <info@lategoodbye.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 1/3] DT: add binding for MXS regulator
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de> <1410089869-6611-2-git-send-email-info@lategoodbye.de> <20140909175940.GF3896@leverpostej>
In-Reply-To: <20140909175940.GF3896@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am 09.09.2014 19:59, schrieb Mark Rutland:
> On Sun, Sep 07, 2014 at 12:37:47PM +0100, Stefan Wahren wrote:
>> This patch adds the Device tree bindings for the Freescale MXS on-chip
>> regulators.
>>
>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>> ---
>>   .../bindings/regulator/mxs-regulator.txt           | 38 ++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>>
>> diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>> new file mode 100644
>> index 0000000..c3226cc
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>> @@ -0,0 +1,38 @@
>> +MXS regulators
>> +
>> +Required node properties:
>> +- compatible: Should be "fsl,<soc>-power", where soc is "imx23" or "imx28"
>> +- reg: Offset and length of the register set for the device
>
> We require #address-cells and #size-cells if the child nodes have reg
> entries.

okay.

>
>> +
>> +Required regulator properties:
>> +- compatible: Must be "fsl,mxs-regulator"
>> +- reg: Offset of the register set for the regulator
>
> Is this the offset or the absolute physical address?
>
> The example seems to be absolute.

You are right, the description is wrong.

>
>> +- mxs-max-reg-val: Maximum value of this register
>
> What does this even mean? What's the format?
>
> Is this not implied by standard properties like regulator-max-microvolt?

Unfortunately not as long the step size in microvolt isn't defined. The 
parameter defines the register value in hex corresponding to 
regulator-max-microvolt.

step size = (regulator-max-microvolt - regulator-min-microvolt) / 
mxs-max-reg-val

May be i missed or understand something wrong?

>
>> +Optional regulator properties:
>> +- mxs-default-microvolt: initial voltage of the regulator
>
> Why is this necessary?

The original driver from Freescale set the MX28 regulator vddio to 3.38 
V during registering. I think that is ugly to implement in the driver 
part, so i add a more general property in the devicetree binding.

>
> Mark.

Stefan
