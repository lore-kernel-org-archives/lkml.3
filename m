Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3J2IJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:09:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35547 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3J2IJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:09:55 -0400
Subject: Re: [RFC][PATCHv5 4/4] Documentation: Add device tree bindings for Freescale FTM PWM.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F8286BD27@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Tue, 29 Oct 2013 03:09:52 -0500
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "matt.porter@linaro.org" <matt.porter@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <754E4595-A2C5-4BAD-BBA7-29091A83197B@codeaurora.org>
References: <1382951151-31517-1-git-send-email-Li.Xiubo@freescale.com> <224C2E26-6C33-4DBB-BC06-A4BA470FDA39@codeaurora.org> <1DD289F6464F0949A2FCA5AA6DC23F8286BD27@039-SN2MPN1-013.039d.mgd.msft.net>
To: Xiubo Li-B47053 <B47053@freescale.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 10:48 PM, Xiubo Li-B47053 wrote:

>>> This adds the Document for Freescale FTM PWM driver under
>>> Documentation/devicetree/bindings/pwm/.
>>> 
>>> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>>> ---
>>> .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 34
>> ++++++++++++++++++++++
>>> 1 file changed, 34 insertions(+)
>>> create mode 100644
>>> Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>>> 
>>> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>>> b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>>> new file mode 100644
>>> index 0000000..175b762
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>>> @@ -0,0 +1,34 @@
>>> +Freescale FTM PWM controller
>> 
>> What does FTM stand for, and can we spell out PWM at least once early on.
>> 
> 
> "FTM" is for short of "FlexTimer Module", I'll use the full name then.
> 
>>> +
>>> +Required properties:
>>> +- compatible: Should be "fsl,vf610-ftm-pwm"
>>> +- reg: Physical base address and length of the controller's registers
>>> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a
>>> +description of
>>> +  the cells format.
>>> +- clock-names : Includes the following module clock source entries:
>>> +    "ftm0" (system clock),
>>> +    "ftm0_fix_sel" (fixed frequency clock),
>>> +    "ftm0_ext_sel" (external clock)
>>> +- clocks : Must contain a clock specifier for each entry in
>>> +clock-names,
>>> +  See ../clock/clock-bindings.txt for details of the property values.
>>> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be
>>> +one of the
>>> +  entries in clock-names.
>> 
>> Why do we need this, why not just have only the clock-names/clocks
>> reference the clk that is actually used?
>> 
> 
> As I have replied before, the FTM has two clock sources: the module clock and the counter clock.
> 
> The counter clock source is selectable depends on different board and also the hardware design:
> +++++
> * FTM source clock is selectable
> * Source clock can be the system clock, the fixed frequency clock, or an external
> clock
> * Fixed frequency clock is an additional clock input to allow the selection of an on
> chip clock source other than the system clock
> * Selecting external clock connects FTM clock to a chip level input pin therefore
> allowing to synchronize the FTM counter with an off chip clock source
> -----
> From the above description we can see that the external clock source can allow to synchronize the
> FTM counter with an off chip clock source.
> 
> As the chip spec permits the counter clock source be selectable, so the different board maybe has different
> implementation, if the driver do not support, this will be a bug.

The binding specs the HW so what a driver does or doesn't support isn't relevant.  Since I assume only one of these clocks makes sense for a given system I don't see a reason the binding should not just state that a given dts will have the one the system specified rather than all 3.

>>> +- pinctrl-names: must contain a "default" entry.
>>> +- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
>>> +  See ../pinctrl/pinctrl-bindings.txt for details of the property
>> values.
>> 
>> let's drop the .. when making directory references.
>> 
> 
> Is absolute path " Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt " or just "pinctrl/pinctrl-bindings.txt " ?

The later.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

