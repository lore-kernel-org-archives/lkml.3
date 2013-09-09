Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3IIQCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:02:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40845 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3IIQCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:02:32 -0400
Message-ID: <522DF112.9000205@arm.com>
Date: Mon, 09 Sep 2013 17:02:26 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>
CC: Koen Kooi <koen@dominion.thruhere.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
References: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net> <20130909133059.GD10973@ohporter.com> <522DD251.2030607@arm.com> <20130909135924.GE10973@ohporter.com> <20130909141606.GF10973@ohporter.com>
In-Reply-To: <20130909141606.GF10973@ohporter.com>
X-OriginalArrivalTime: 09 Sep 2013 16:02:27.0513 (UTC) FILETIME=[FB0E7290:01CEAD75]
X-MC-Unique: 113090917022904701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 09/09/13 15:16, Matt Porter wrote:
> On Mon, Sep 09, 2013 at 09:59:26AM -0400, Matt Porter wrote:
>> On Mon, Sep 09, 2013 at 02:51:13PM +0100, Jonathan Austin wrote:
>>> Hi Matt,
>>>
>>> On 09/09/13 14:31, Matt Porter wrote:
>>>> On Sun, Sep 08, 2013 at 01:12:26PM +0200, Koen Kooi wrote:
>>>>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>>>>> so create a common dtsi both can use.
>>>>>
>>>>> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver
>>>>> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
>>>>> of 1.8.
>>>>>
>>>>> MMC support for AM335x still isn't in, so only the LDO change has been added.
>>>>>
>>>>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>>>>
>>>> Tested-by: Matt Porter <matt.porter@linaro.org>
>>>>
>>>> Works fine for me on tip and 3.11. I did notice a regression in musb (worked
>>>> on 3.11, now failing to probe but this is not related to your new dts as it
>>>> happens on am335x-bone.dts too, assuming merge window volatility). One nit,
>>>> git-am picked up a whitespace error on that extra line at EOF so you should
>>>> trim that out.
>>>>
>>>> Only thing is...for a clear bug like this that will destroy hardware, it
>>>> should be marked Cc: stable@vger.kernel.org to be picked up in stable.
>>>>
>>>
>>> If I've understood Koen correctly then what he's saying is that if
>>> you *were* to use the current (before this patch) am335x-bone.dts on
>>> a Beagle Bone Black (which would be wrong, as that's not the board
>>> you have...) then things would break.
>>>
>>> I don't see that this patch fixes that - as far as I can see, even
>>> after the patch, using am335x-bone.dts with a Bone Black will risk
>>> the damage?
>>>
>>> If so, I don't think this is a 'stable fix' kind of thing, as it
>>> doesn't actually fix the problem?
>>
>> It fixes the problem by providing the correct dts for BBB which the
>> vendor tree has had for sometime. In the absence of a specific dts
>> for BBB, it appears everybody (TI and OMAP maintainers, included)
>> has assumed that am335x-bone.dts is correct and safe.
>>
>> I'm sure there's plenty of systems represented in dts/* where you
>> could cause damage by loading another dtb for a similar board from
>> the same SoC family...it's a common risk if you get the wrong dtb
>> with more-or-less arbitrary regulator settings.
>
> Sorry to reply to myself, but I probably didn't make it 100% clear as
> to why this effectively fixes the problem. Both mainline u-boot *and*
> the vendor u-boot have findfdt implemented to load an
> am335x-boneblack.dtb based on board detection.

This makes more sense now, thanks. Not sure that it is still a good case 
for CC:stable. Are people currently working around findfdt failing, etc? 
If so, do you think backporting the fix will stop them doing that? I 
don't really know what the workflow looks like...

Generally the idea of backporting DT fixes to older kernels gives me the 
Heebie-Jeebies - this case of being able to damage hardware is a great 
example of why it might be scary (though I acknowledge that this 
specific patch is unlikely to have a bad outcome)

Jonny
>
> Hopefully this makes it clear why this fixes a bug in the kernel. If
> you use appended dtb to include the wrong one, well, you shouldn't
> be using appended dtb. It's a *hack* and loading it separately
> works fine if you use the U-Boot that ships with BBB or mainline.
>
> -Matt
>
>>> Koen - is there a way for a booting kernel to detect which board it
>>> is on and avoid any potential damage if someone gives it the wrong
>>> DT?
>>>
>>> Jonny
>>>
>>>> -Matt
>>>>
>>>> _______________________________________________
>>>> linux-arm-kernel mailing list
>>>> linux-arm-kernel@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


