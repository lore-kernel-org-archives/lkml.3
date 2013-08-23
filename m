Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3HWTga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:36:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3HWTg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:36:29 -0400
Message-ID: <5217B9B7.9080802@wwwdotorg.org>
Date: Fri, 23 Aug 2013 13:36:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
        ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for Freescale
 FTM PWM
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com> <20130823091052.GG3535@ulmo>
In-Reply-To: <20130823091052.GG3535@ulmo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 03:10 AM, Thierry Reding wrote:
> On Wed, Aug 21, 2013 at 11:07:42AM +0800, Xiubo Li wrote:
>> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com> --- 
>> .../devicetree/bindings/pwm/fsl-ftm-pwm.txt        | 52
>> ++++++++++++++++++++++ 1 file changed, 52 insertions(+) create
>> mode 100644
>> Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt

>> diff --git
>> a/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
>> b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt

>> +Required properties: +- compatible: should be
>> "fsl,vf610-ftm-pwm" +- reg: physical base address and length of
>> the controller's registers +- #pwm-cells: Should be 3. Number of
>> cells being used to specify PWM property. +  First cell specifies
>> the per-chip channel index of the PWM to use, the +  second cell
>> is the period in nanoseconds and bit 0 in the third cell is +
>> used to encode the polarity of PWM output. Set bit 0 of the third
>> in PWM +  specifier to 1 for inverse polarity & set to 0 for
>> normal polarity.

Lines 2..n of a property description should be indented so it's easier
to see where each entry in the list starts.

>> +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler, divide-by
>> 2^n(n = 0 ~ 7). +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM) mode.

>> +- fsl,pwm-number: the number of PWM devices, and is must equal
>> to the number +  of "fsl,pwm-channels".

Isn't that value a static facet of the HW, and hence it can be
determined solely from the compatible value?

>> +- fsl,pwm-channels: the channels' order which is be used for pwm
>> in ftm0 +  module, and they must be one or some of 0 ~ 7, because
>> the ftm0 only has +  8 channels can be used.

Why is there a need to re-order the channels? Why not simply reference
the actual physical channel IDs in client nodes?

>> +- for very channel, the revlatived the pinctrl should be at
>> least two state +  {"enN", "dsN"}, which "en" means "enable",
>> "ds" means "disable" and "N" +  means the order of the channel.

revlatived??

Why is there a need for pinctrl interaction at all?

Is the "N" in these property names the index into fsl,pwm-channels, or
the physical channel number in the controller HW, or something else?

"dis" would be better than "ds", although "enable-chN", "disable-chN"
would be even better.

Note that it's not possible to enable multiple pinctrl states at once,
so what happens when channel 0 is enabled, yet channel 1 is disabled,
and you want to enable "en0" and "ds1" at the same time?
