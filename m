Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3HWT3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:29:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34322 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3HWT3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:29:16 -0400
Message-ID: <5217B807.7020800@wwwdotorg.org>
Date: Fri, 23 Aug 2013 13:29:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Xiubo Li-B47053 <B47053@freescale.com>,
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
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com> <1473340.OXSHEp7d4P@flatron> <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net> <20130822062610.GR31036@pengutronix.de> <20130823073612.GB3535@ulmo>
In-Reply-To: <20130823073612.GB3535@ulmo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 01:36 AM, Thierry Reding wrote:
> On Thu, Aug 22, 2013 at 08:26:10AM +0200, Sascha Hauer wrote:
>> On Thu, Aug 22, 2013 at 02:55:42AM +0000, Xiubo Li-B47053 wrote:
>>> Hi Tomasz,
>>> 
>>> Thanks for your comments.
>>> 
>>> 
>>>> Could you explain meaning of this property more precisely?
>>>> I'm interested especially how is this related to the PWM IP
>>>> block and boards.
>>>> 
>>> 
>>> Yes. There are 8 channels most. While the pinctrls of 4th and
>>> 5th channels could be used by uart's Rx and Tx, then these 2
>>> channels won't be used for pwm output, so there will be 6
>>> channels available by the pwm. Thus, the pwm chip will register
>>> only 6 pwms(6 channels) most("fsl,pwm-channel-orders = {0 1 2 3
>>> 6 7}").And also the "fsl,pwm-channel-number" will be 6.
>> 
>> If the chip has eight PWMs I would register all of them. If some
>> of them are not routed out by the pinmux then just nothing
>> happens if you use them. In a sane devicetree they won't be
>> referenced anyway when they are not routed out of the SoC.
> 
> In that case, shouldn't this be hooked up to the pinctrl subsystem
> as well? As I understand the above, the logical thing would be for
> each PWM channel's .request() operation to configure the pinmuxing
> appropriately. And if it can't be configured as necessary then
> .request() should return an error (or propagate the error from the
> pinctrl subsystem).

I think the pin-muxing should be static, i.e. set up when the PWM
device as a whole probe()s, rather than being twiddled at request/free
time. Certainly the pinmux support in the device core is now set up to
acquire the default state right before probe(). I don't see a need to
do anything custom here.
