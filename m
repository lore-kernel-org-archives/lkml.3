Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3H0EEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:04:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40569 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3H0EEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:04:02 -0400
Message-ID: <521C2531.10402@wwwdotorg.org>
Date: Mon, 26 Aug 2013 22:04:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiubo Li-B47053 <B47053@freescale.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for Freescale
 FTM PWM
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com> <1473340.OXSHEp7d4P@flatron> <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net> <20130822062610.GR31036@pengutronix.de> <20130823073612.GB3535@ulmo> <5217B807.7020800@wwwdotorg.org> <1DD289F6464F0949A2FCA5AA6DC23F827E11AC@039-SN2MPN1-012.039d.mgd.msft.net> <521BB40D.7040001@wwwdotorg.org> <1DD289F6464F0949A2FCA5AA6DC23F827E61F2@039-SN2MPN1-012.039d.mgd.msft.net>
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827E61F2@039-SN2MPN1-012.039d.mgd.msft.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 09:48 PM, Xiubo Li-B47053 wrote:
> Hi Stephen,
> 
> 
>> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
>> Freescale FTM PWM
>>
>> On 08/25/2013 11:35 PM, Xiubo Li-B47053 wrote:
>>>> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
>> ...
>>>>> Why do you need to manipulate the pinctrl to en/disable a channel?
>>>>
>>>> This is because in Vybrid VF610 TOWER board, there are 4 leds, and
>>>> each led's one point(diode's positive pole) is connected to 3.3V, and
>>>> the other point is connected to pwm's one channel. When the 4
>>>> pinctrls are configured as enable at the same time, the 4 pinctrls is
>>>> low valtage, and the 4 leds will be lighted up as default, then when
>>>> you enable/disable one led will effects others.
>>>>
>>>> These pinctrls are belong to pwm, and I don't think led or other
>>>> customer could control them directly.
>>>> So, here I authorize the 4 pinctrls to each channel controls.
>>>>
>>> "
>>> For the reason above, I have to control the pinctrls separately.
>>>
>>> If all the pinctrls set as default state, the 8 pinctrls must be
>> controlled together.
>>> And the 4 leds will all be lighted up as default and will influence
>> each other.
>>
>> Sorry, that still doesn't make much sense. ...

What may help here is to show the exact content you expect the various
en/dis states to have, so that we can see exactly which pinctrl options
get set when and why.
